#include "whisper_wrapper.h"
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

// For now, implement placeholder functions
// In a real implementation, this would link to whisper.cpp

whisper_context* whisper_init_from_file_wrapper(const char* path_model) {
    printf("Loading whisper model from: %s\n", path_model);
    // Return a dummy pointer to indicate "success"
    return (whisper_context*)malloc(sizeof(int));
}

void whisper_free_wrapper(whisper_context* ctx) {
    if (ctx) {
        free(ctx);
    }
}

char* whisper_transcribe_file_wrapper(whisper_context* ctx, const char* audio_path) {
    if (!ctx || !audio_path) {
        return NULL;
    }
    
    // Create a placeholder transcription
    const char* template = "Transkriberad text från: %s\nDetta är en placeholder-implementation som kommer att ersättas med whisper.cpp.";
    int len = snprintf(NULL, 0, template, audio_path) + 1;
    char* result = malloc(len);
    
    if (result) {
        snprintf(result, len, template, audio_path);
    }
    
    return result;
}

void whisper_free_string_wrapper(char* str) {
    if (str) {
        free(str);
    }
}