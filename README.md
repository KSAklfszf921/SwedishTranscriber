# SwedishTranscriber 🎙️

En kraftfull macOS-app för transkribering av svenskt tal med hjälp av KBLab's optimerade Whisper-modeller.

![SwedishTranscriber Screenshot](assets/screenshot.png)

## Funktioner ✨

- 🇸🇪 **Optimerad för svenska** - Använder KBLab's specialtränade Whisper-modeller
- 🚀 **Apple Silicon-optimerad** - Utnyttjar Neural Engine för maximal prestanda  
- 📁 **Drag & Drop** - Släpp bara filer för att transkribera
- 🔗 **URL-stöd** - Transkribera från YouTube, SR Play, podcasts m.m.
- 📊 **Realtidsstatistik** - Se ord/sekund och uppskattad tid
- 🎯 **Flera format** - Text, SRT, VTT, JSON med tidsmarkeringar
- ⚡ **Parallellbearbetning** - Transkribera flera filer samtidigt
- 🔧 **Avancerade inställningar** - Hallucinationshantering, prompt engineering

## Systemkrav 📋

- macOS 13.0 (Ventura) eller senare
- Apple Silicon Mac (rekommenderat) eller Intel Mac med AVX-stöd
- Minst 8 GB RAM (16 GB rekommenderat för stora modeller)

## Installation 🛠️

### Enkel installation (Rekommenderad)
1. Ladda ner senaste versionen från [Releases](https://github.com/yourusername/SwedishTranscriber/releases)
2. Öppna DMG-filen och dra SwedishTranscriber till Applications
3. Starta appen - första körningen laddar ner nödvändiga modeller automatiskt

### Bygg från källkod
```bash
# Klona projektet
git clone https://github.com/yourusername/SwedishTranscriber.git
cd SwedishTranscriber

# Installera beroenden
brew install cmake ninja ffmpeg

# Bygg appen
./build.sh

# Appen finns nu i build/Release/SwedishTranscriber.app
```

## Användning 🎯

### Grundläggande transkribering
1. Starta SwedishTranscriber
2. Dra och släpp ljudfiler på dropzonen eller klicka "Välj filer"
3. Klicka "Transkribera"
4. Resultatet sparas automatiskt i mappen "Transkriberingar" på skrivbordet

### Transkribera från URL
1. Klistra in URL i textfältet (YouTube, SR Play, etc.)
2. Klicka "Lägg till"
3. Fortsätt som vanligt

### Byta modell
- Klicka på modellnamnet i statusfältet
- Välj önskad modell (större = bättre kvalitet men långsammare)
- Modellen laddas ner automatiskt vid första användningen

## Modeller 🧠

| Modell | Storlek | Hastighet | Kvalitet | Användning |
|--------|---------|-----------|----------|------------|
| KB Tiny | 39 MB | ⚡⚡⚡⚡⚡ | ⭐⭐ | Snabb transkribering, prototyper |
| KB Base | 74 MB | ⚡⚡⚡⚡ | ⭐⭐⭐ | Balans mellan hastighet och kvalitet |
| KB Small | 244 MB | ⚡⚡⚡ | ⭐⭐⭐⭐ | Rekommenderad för de flesta |
| KB Medium | 769 MB | ⚡⚡ | ⭐⭐⭐⭐ | Professionell användning |
| KB Large | 1.55 GB | ⚡ | ⭐⭐⭐⭐⭐ | Maximal kvalitet |

## Avancerade funktioner ⚙️

### Hallucinationshantering
I inställningar kan du aktivera:
- **VAD (Voice Activity Detection)** - Ignorerar tystnad
- **Repetitionshantering** - Förhindrar upprepningar
- **Temperaturbegränsning** - Minskar kreativa tolkningar

### Prompt Engineering
Använd initial prompt för att styra transkriberingsstilen:
- Formell stil: `"Transkribera i formell stil med korrekt interpunktion."`
- Undertexter: `"Skapa korta, koncisa undertexter."`
- Medicinsk: `"Fokusera på medicinsk terminologi."`

### Automatisk transkribering
1. Aktivera i Inställningar > Avancerat
2. Välj en mapp att bevaka
3. Alla ljudfiler som läggs till transkriberas automatiskt

## Prestanda 📊

### Apple Silicon (M1/M2/M3)
- Använder Neural Engine för 3-5x snabbare transkribering
- KB Small: ~50x realtid på M1 Pro
- KB Large: ~15x realtid på M1 Pro

### Intel Mac
- Använder AVX/AVX2-instruktioner
- KB Small: ~10x realtid på i7
- KB Large: ~3x realtid på i7

## Felsökning 🔧

### "Modellen kunde inte laddas"
- Kontrollera internetanslutning
- Radera modellcachen: `~/Library/Application Support/SwedishTranscriber/Models`
- Starta om appen

### Långsam transkribering
- Byt till mindre modell
- Minska antal parallella jobb i inställningar
- Stäng andra resurskrävande appar

### Fel format på utdata
- Kontrollera att rätt format är valt i inställningar
- För undertexter, använd SRT eller VTT
- För programmering, använd JSON

## Bidra 🤝

Vi välkomnar bidrag! Se [CONTRIBUTING.md](CONTRIBUTING.md) för riktlinjer.

### Utvecklingsmiljö
```bash
# Installera utvecklingsberoenden
brew install swiftlint swift-format

# Kör tester
swift test

# Formatera kod
swift-format -i Sources/**/*.swift
```

## Licens 📄

SwedishTranscriber är licensierad under MIT License. Se [LICENSE](LICENSE) för detaljer.

Whisper-modellerna från KBLab är licensierade under Apache 2.0.

## Tack till 🙏

- [KBLab](https://www.kb.se/samverkan-och-utveckling/kblab.html) för de svenska Whisper-modellerna
- [OpenAI](https://openai.com) för Whisper
- [ggerganov](https://github.com/ggerganov) för whisper.cpp
- Alla bidragsgivare och testare

## Support 💬

- **Dokumentation**: [Wiki](https://github.com/yourusername/SwedishTranscriber/wiki)
- **Problem**: [GitHub Issues](https://github.com/yourusername/SwedishTranscriber/issues)
- **Diskussioner**: [GitHub Discussions](https://github.com/yourusername/SwedishTranscriber/discussions)

---

Skapad med ❤️ för det svenska språket
