#!/usr/bin/env python3
import os
import sys
from huggingface_hub import snapshot_download
from pathlib import Path

def download_kb_model(model_id="KBLab/kb-whisper-small"):
    """Ladda ner KB Whisper-modell från HuggingFace"""
    
    print(f"📥 Laddar ner {model_id}...")
    
    # Ladda ner modellen
    cache_dir = Path.home() / "Library/Application Support/SwedishTranscriber/Models"
    cache_dir.mkdir(parents=True, exist_ok=True)
    
    model_path = snapshot_download(
        repo_id=model_id,
        cache_dir=cache_dir,
        local_dir=cache_dir / model_id.replace("/", "_"),
        local_dir_use_symlinks=False
    )
    
    print(f"✅ Modell nedladdad: {model_path}")
    
    # TODO: Konvertera till Core ML här
    print("🔄 Konverterar till Core ML...")
    # convert_to_coreml(model_path)
    
    print("🎉 Klar!")

if __name__ == "__main__":
    model = sys.argv[1] if len(sys.argv) > 1 else "KBLab/kb-whisper-small"
    download_kb_model(model)
