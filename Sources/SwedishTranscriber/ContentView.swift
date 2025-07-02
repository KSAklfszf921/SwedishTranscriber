import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @StateObject private var transcriber = TranscriptionManager()
    @State private var isTargeted = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack {
                Text("SwedishTranscriber")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text("Transkribera svenska ljudfiler med AI")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.top)
            
            // Drop Zone
            VStack(spacing: 16) {
                if transcriber.audioFiles.isEmpty {
                    DropZoneView(isTargeted: $isTargeted)
                        .onDrop(of: [.audio], isTargeted: $isTargeted) { providers in
                            handleDrop(providers: providers)
                        }
                } else {
                    FileListView(transcriber: transcriber)
                }
            }
            
            // Controls
            HStack(spacing: 16) {
                Button("Välj filer") {
                    selectFiles()
                }
                .buttonStyle(.bordered)
                
                if !transcriber.audioFiles.isEmpty {
                    Button("Rensa alla") {
                        transcriber.clearFiles()
                    }
                    .buttonStyle(.bordered)
                    
                    Button("Transkribera") {
                        Task {
                            await transcriber.transcribeAll()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(transcriber.isProcessing)
                }
            }
            
            // Status
            if transcriber.isProcessing {
                ProgressView("Transkriberar...")
                    .progressViewStyle(CircularProgressViewStyle())
            }
            
            if let error = transcriber.error {
                Text("Fel: \(error)")
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
        .padding()
        .frame(minWidth: 500, minHeight: 400)
    }
    
    private func handleDrop(providers: [NSItemProvider]) -> Bool {
        for provider in providers {
            provider.loadItem(forTypeIdentifier: UTType.audio.identifier) { item, error in
                if let url = item as? URL {
                    DispatchQueue.main.async {
                        transcriber.addFile(url: url)
                    }
                }
            }
        }
        return true
    }
    
    private func selectFiles() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = true
        panel.allowedContentTypes = [.audio]
        
        if panel.runModal() == .OK {
            for url in panel.urls {
                transcriber.addFile(url: url)
            }
        }
    }
}

struct DropZoneView: View {
    @Binding var isTargeted: Bool
    
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(isTargeted ? Color.accentColor.opacity(0.1) : Color.gray.opacity(0.1))
            .stroke(isTargeted ? Color.accentColor : Color.gray.opacity(0.3), style: StrokeStyle(lineWidth: 2, dash: [10]))
            .frame(height: 200)
            .overlay {
                VStack(spacing: 12) {
                    Image(systemName: "waveform")
                        .font(.system(size: 48))
                        .foregroundColor(isTargeted ? .accentColor : .gray)
                    
                    Text("Släpp ljudfiler här")
                        .font(.headline)
                        .foregroundColor(isTargeted ? .accentColor : .primary)
                    
                    Text("Stöds: MP3, WAV, M4A, FLAC")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
    }
}

struct FileListView: View {
    @ObservedObject var transcriber: TranscriptionManager
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(transcriber.audioFiles) { file in
                    FileRowView(file: file)
                }
            }
            .padding()
        }
        .frame(maxHeight: 300)
        .background(Color.gray.opacity(0.05))
        .cornerRadius(8)
    }
}

struct FileRowView: View {
    let file: AudioFile
    
    var body: some View {
        HStack {
            Image(systemName: "waveform")
                .foregroundColor(.accentColor)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(file.url.lastPathComponent)
                    .font(.headline)
                    .lineLimit(1)
                
                Text(file.url.path)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            switch file.status {
            case .pending:
                Image(systemName: "clock")
                    .foregroundColor(.orange)
            case .processing:
                ProgressView()
                    .scaleEffect(0.8)
            case .completed:
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            case .failed:
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 1)
    }
}

#Preview {
    ContentView()
}