import Foundation

struct ExportManager {
    
    enum ExportFormat: String, CaseIterable {
        case txt = "txt"
        case srt = "srt"
        case vtt = "vtt"
        case json = "json"
        
        var displayName: String {
            switch self {
            case .txt: return "Plain Text"
            case .srt: return "SubRip (SRT)"
            case .vtt: return "WebVTT"
            case .json: return "JSON"
            }
        }
        
        var fileExtension: String {
            return rawValue
        }
    }
    
    static func export(
        transcription: String,
        fileName: String,
        format: ExportFormat,
        outputDirectory: URL
    ) throws {
        let content: String
        let fileExtension = format.fileExtension
        
        switch format {
        case .txt:
            content = transcription
            
        case .srt:
            content = convertToSRT(transcription: transcription)
            
        case .vtt:
            content = convertToVTT(transcription: transcription)
            
        case .json:
            content = try convertToJSON(transcription: transcription, fileName: fileName)
        }
        
        let outputURL = outputDirectory
            .appendingPathComponent(fileName)
            .appendingPathExtension(fileExtension)
        
        try content.write(to: outputURL, atomically: true, encoding: .utf8)
        print("Exported \(format.displayName): \(outputURL.path)")
    }
    
    private static func convertToSRT(transcription: String) -> String {
        // För nu, skapa en enkel SRT-fil
        // I en riktig implementation skulle vi ha timestamps från whisper.cpp
        var srt = ""
        let lines = transcription.components(separatedBy: .newlines).filter { !$0.isEmpty }
        
        for (index, line) in lines.enumerated() {
            let sequenceNumber = index + 1
            let startTime = formatSRTTime(seconds: Double(index * 5))
            let endTime = formatSRTTime(seconds: Double((index + 1) * 5))
            
            srt += """
            \(sequenceNumber)
            \(startTime) --> \(endTime)
            \(line)
            
            
            """
        }
        
        return srt
    }
    
    private static func formatSRTTime(seconds: Double) -> String {
        let hours = Int(seconds) / 3600
        let minutes = (Int(seconds) % 3600) / 60
        let secs = Int(seconds) % 60
        let milliseconds = Int((seconds - Double(Int(seconds))) * 1000)
        
        return String(format: "%02d:%02d:%02d,%03d", hours, minutes, secs, milliseconds)
    }
    
    private static func convertToVTT(transcription: String) -> String {
        var vtt = "WEBVTT\n\n"
        let lines = transcription.components(separatedBy: .newlines).filter { !$0.isEmpty }
        
        for (index, line) in lines.enumerated() {
            let startTime = formatVTTTime(seconds: Double(index * 5))
            let endTime = formatVTTTime(seconds: Double((index + 1) * 5))
            
            vtt += """
            \(startTime) --> \(endTime)
            \(line)
            
            
            """
        }
        
        return vtt
    }
    
    private static func formatVTTTime(seconds: Double) -> String {
        let hours = Int(seconds) / 3600
        let minutes = (Int(seconds) % 3600) / 60
        let secs = Int(seconds) % 60
        let milliseconds = Int((seconds - Double(Int(seconds))) * 1000)
        
        return String(format: "%02d:%02d:%02d.%03d", hours, minutes, secs, milliseconds)
    }
    
    private static func convertToJSON(transcription: String, fileName: String) throws -> String {
        let segments = transcription.components(separatedBy: .newlines).filter { !$0.isEmpty }
        
        let jsonObject: [String: Any] = [
            "task": "transcribe",
            "language": "sv",
            "duration": Double(segments.count * 5),
            "text": transcription,
            "segments": segments.enumerated().map { index, text in
                [
                    "id": index,
                    "seek": index * 5,
                    "start": Double(index * 5),
                    "end": Double((index + 1) * 5),
                    "text": text,
                    "temperature": 0.0,
                    "avg_logprob": -0.5,
                    "compression_ratio": 1.0,
                    "no_speech_prob": 0.1
                ]
            }
        ]
        
        let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
        return String(data: jsonData, encoding: .utf8) ?? ""
    }
}