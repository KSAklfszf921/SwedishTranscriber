#ifndef WHISPER_WRAPPER_H
#define WHISPER_WRAPPER_H

#ifdef __cplusplus
extern "C" {
#endif

// Simple C wrapper for whisper.cpp functionality
typedef struct whisper_context whisper_context;

// Initialize whisper context from model file
whisper_context* whisper_init_from_file_wrapper(const char* path_model);

// Free whisper context
void whisper_free_wrapper(whisper_context* ctx);

// Transcribe audio file and return result
char* whisper_transcribe_file_wrapper(whisper_context* ctx, const char* audio_path);

// Free transcription result string
void whisper_free_string_wrapper(char* str);

#ifdef __cplusplus
}
#endif

#endif