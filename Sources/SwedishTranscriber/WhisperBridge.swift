import Foundation
import CoreML
import CWhisper

class WhisperBridge {
    private var context: OpaquePointer?
    private let modelPath: String
    
    init(modelPath: String) {
        self.modelPath = modelPath
    }
    
    func loadModel() throws {
        let modelCString = modelPath.cString(using: .utf8)
        context = whisper_init_from_file_wrapper(modelCString)
        
        guard context != nil else {
            throw WhisperError.modelNotLoaded
        }
        
        print("Whisper model loaded successfully from: \(modelPath)")
    }
    
    func transcribe(audioPath: String) async throws -> String {
        guard let context = context else {
            throw WhisperError.modelNotLoaded
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                let audioCString = audioPath.cString(using: .utf8)
                
                guard let resultCString = whisper_transcribe_file_wrapper(context, audioCString) else {
                    continuation.resume(throwing: WhisperError.transcriptionFailed)
                    return
                }
                
                let result = String(cString: resultCString)
                whisper_free_string_wrapper(resultCString)
                
                continuation.resume(returning: result)
            }
        }
    }
    
    deinit {
        if let context = context {
            whisper_free_wrapper(context)
        }
    }
}

enum WhisperError: Error, LocalizedError {
    case modelNotLoaded
    case transcriptionFailed
    case audioLoadFailed
    
    var errorDescription: String? {
        switch self {
        case .modelNotLoaded:
            return "Modell är inte laddad"
        case .transcriptionFailed:
            return "Transkription misslyckades"
        case .audioLoadFailed:
            return "Kunde inte ladda ljudfil"
        }
    }
}