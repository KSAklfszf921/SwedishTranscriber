import Foundation
import SwiftUI

@MainActor
class TranscriptionManager: ObservableObject {
    @Published var audioFiles: [AudioFile] = []
    @Published var isProcessing = false
    @Published var error: String?
    
    func addFile(url: URL) {
        let audioFile = AudioFile(url: url)
        audioFiles.append(audioFile)
        error = nil
    }
    
    func clearFiles() {
        audioFiles.removeAll()
        error = nil
    }
    
    func transcribeAll() async {
        isProcessing = true
        error = nil
        
        for i in audioFiles.indices {
            audioFiles[i].status = .processing
            
            do {
                let transcription = try await transcribe(file: audioFiles[i])
                audioFiles[i].status = .completed
                audioFiles[i].transcription = transcription
                
                // Spara transkription
                try await saveTranscription(transcription, for: audioFiles[i])
                
            } catch {
                audioFiles[i].status = .failed
                self.error = error.localizedDescription
                print("Transcription failed for \(audioFiles[i].url.lastPathComponent): \(error)")
            }
        }
        
        isProcessing = false
    }
    
    private func transcribe(file: AudioFile) async throws -> String {
        // Sök efter modellfilens sökväg
        let modelPath = findModelPath()
        
        let whisper = WhisperBridge(modelPath: modelPath)
        try whisper.loadModel()
        
        return try await whisper.transcribe(audioPath: file.url.path)
    }
    
    private func findModelPath() -> String {
        // Leta efter modeller i models-mappen
        let modelPaths = [
            "models/kb-whisper-small.mlmodelc",
            "models/ggml-base.bin",
            "models/ggml-small.bin"
        ]
        
        for path in modelPaths {
            if FileManager.default.fileExists(atPath: path) {
                return path
            }
        }
        
        // Fallback till en dummy-sökväg
        return "models/kb-whisper-small.mlmodelc"
    }
    
    private func saveTranscription(_ transcription: String, for file: AudioFile) async throws {
        let desktopURL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!
        let transcriptionsDir = desktopURL.appendingPathComponent("Transkriberingar")
        
        try FileManager.default.createDirectory(at: transcriptionsDir, withIntermediateDirectories: true)
        
        let fileName = file.url.deletingPathExtension().lastPathComponent
        
        // Exportera i alla format
        let formats: [ExportManager.ExportFormat] = [.txt, .srt, .vtt, .json]
        
        for format in formats {
            do {
                try ExportManager.export(
                    transcription: transcription,
                    fileName: fileName,
                    format: format,
                    outputDirectory: transcriptionsDir
                )
            } catch {
                print("Failed to export \(format.displayName): \(error)")
            }
        }
    }
}

struct AudioFile: Identifiable {
    let id = UUID()
    let url: URL
    var status: TranscriptionStatus = .pending
    var transcription: String?
}

enum TranscriptionStatus {
    case pending
    case processing
    case completed
    case failed
}