# 🔧 Strumenti di Gestione Dipendenze

Questa cartella contiene tutti gli strumenti per la gestione automatica delle dipendenze necessarie al sistema di generazione PDF.

## 📁 Struttura Directory

```
tools/
├── setup-dipendenze.ps1     # Script principale per installazione automatica
├── verifica-sistema.ps1     # Diagnostica e verifica dipendenze
├── installers/              # Directory per file di installazione
│   └── pandoc-installer.msi # Installer Pandoc incluso
└── README.md                # Questa documentazione
```

## 🚀 Script Principali

### 1. setup-dipendenze.ps1

**Scopo:** Installazione automatica di tutte le dipendenze necessarie

**Funzionalità:**
- ✅ **Auto-detection** sistema operativo e architettura
- ✅ **Download automatico** delle versioni più recenti di Pandoc e PDFtk
- ✅ **Installazione silenziosa** senza intervento utente
- ✅ **Verifica post-installazione** con controlli funzionali
- ✅ **Logging completo** con timestamp e livelli di errore
- ✅ **Fallback intelligente** su installer locali se download fallisce

**Utilizzo:**
```powershell
# Installazione standard (solo dipendenze mancanti)
.\setup-dipendenze.ps1

# Reinstallazione forzata di tutto
.\setup-dipendenze.ps1 -Force

# Installazione solo PDFtk (salta Pandoc)
.\setup-dipendenze.ps1 -SkipPandoc

# Installazione solo Pandoc (salta PDFtk)  
.\setup-dipendenze.ps1 -SkipPDFtk

# Output dettagliato per debugging
.\setup-dipendenze.ps1 -Verbose
```

**Requisiti:**
- PowerShell 5.1 o superiore
- Connessione internet per download automatico
- Privilegi amministratore (raccomandato ma non obbligatorio)

### 2. verifica-sistema.ps1

**Scopo:** Diagnostica completa dello stato delle dipendenze

**Funzionalità:**
- 🔍 **Verifica presenza** di Pandoc, PDFtk e PowerShell
- 📊 **Controllo versioni** e compatibilità
- 🧪 **Test supporto LaTeX** (XeLaTeX engine)
- 📁 **Verifica file progetto** e directory
- 📋 **Report dettagliato** con suggerimenti

**Utilizzo:**
```powershell
# Verifica standard
.\verifica-sistema.ps1

# Verifica dettagliata con percorsi e configurazioni
.\verifica-sistema.ps1 -Detailed
```

**Output esempio:**
```
===========================================
  VERIFICA SISTEMA - SCRITTO CALCOLATORI
===========================================

DIPENDENZE PRINCIPALI:
  ✓ Pandoc        (v3.8.1)
  ✓ PDFtk         (v2.02)
  ✓ PowerShell    (v5.1.19041.4648)

SUPPORTO LaTeX:
  ✓ XeLaTeX Engine

FILE PROGETTO:
  ✓ genera-pdf.ps1
  ✓ setup-dipendenze.ps1
  ✓ README.md

RIEPILOGO:
✓ Tutte le dipendenze sono installate correttamente!
✓ Il sistema è pronto per generare PDF
```

## 📦 Directory installers/

**Scopo:** Archiviazione locale degli installer per fallback offline

**Contenuto:**
- `pandoc-installer.msi` - Installer Pandoc locale (backup)
- `pdftk-setup.exe` - Installer PDFtk (scaricato automaticamente)

**Gestione automatica:**
- Il setup scarica automaticamente le versioni più recenti
- Usa i file locali come fallback se il download fallisce
- Mantiene solo installer funzionanti e testati

## 🔧 Risoluzione Problemi

### Problema: "Script non eseguito come Amministratore"

**Causa:** Alcune installazioni richiedono privilegi elevati

**Soluzione:**
```powershell
# Avvia PowerShell come Amministratore
Start-Process powershell -Verb RunAs

# Oppure continua senza privilegi (alcune funzioni potrebbero fallire)
# Lo script chiederà conferma
```

### Problema: "Download fallito"

**Causa:** Problemi di connessione o URL modificati

**Soluzioni:**
1. **Verifica connessione internet**
2. **Usa installer locale:** Gli installer in `installers/` vengono usati automaticamente
3. **Download manuale:** 
   - [Pandoc](https://pandoc.org/)
   - [PDFtk](https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/)

### Problema: "Comando non trovato dopo installazione"

**Causa:** PATH non aggiornato nella sessione corrente

**Soluzione:**
```powershell
# Riavvia PowerShell per aggiornare PATH
exit

# Oppure aggiorna PATH manualmente
$env:PATH = [System.Environment]::GetEnvironmentVariable("PATH","Machine")

# Verifica installazione
.\verifica-sistema.ps1
```

### Problema: "PDFtk Warning: unexpected case 1"

**Causa:** Warning normale di PDFtk, non influisce sulla funzionalità

**Soluzione:** Nessuna azione richiesta, il warning è innocuo

## 🔄 Workflow Tipico

### Prima installazione (nuovo sistema):
```powershell
# 1. Setup automatico
.\tools\setup-dipendenze.ps1

# 2. Verifica installazione
.\tools\verifica-sistema.ps1

# 3. Test generazione PDF
.\genera-pdf.ps1 -Verbose

# 4. Se tutto ok, usa normalmente
.\genera-pdf.ps1
```

### Aggiornamento dipendenze:
```powershell
# Reinstalla con versioni più recenti
.\tools\setup-dipendenze.ps1 -Force

# Verifica aggiornamento
.\tools\verifica-sistema.ps1 -Detailed
```

### Diagnostica problemi:
```powershell
# Verifica dettagliata
.\tools\verifica-sistema.ps1 -Detailed

# Log dettagliato setup
.\tools\setup-dipendenze.ps1 -Verbose

# Log generazione PDF
.\genera-pdf.ps1 -Verbose
```

## 📝 Logging e Monitoraggio

### File di log generati:
- `logs/setup-dipendenze_YYYY-MM-DD.log` - Log installazione dipendenze
- `logs/genera-pdf_YYYY-MM-DD_HH-mm-ss.log` - Log generazione PDF

### Analisi log utile:
```powershell
# Ultimi errori setup dipendenze
Get-Content logs\setup-dipendenze_*.log | Where-Object { $_ -match "ERROR" }

# Statistiche ultima generazione PDF
Get-Content logs\genera-pdf_*.log | Select-Object -Last 20

# Controllo warn/errori
Get-Content logs\*.log | Where-Object { $_ -match "ERROR|WARN" }
```

## 🎯 Best Practices

1. **Esegui sempre verifica-sistema.ps1** dopo modifiche al sistema
2. **Usa -Force solo quando necessario** per evitare download inutili
3. **Mantieni aggiornati i log** per troubleshooting efficace
4. **Testa su sistema pulito** se condividi il progetto
5. **Documenta modifiche** agli script per future versioni

## 🤝 Supporto

Per problemi non risolti da questa documentazione:

1. **Controlla i log** in `logs/` per errori specifici
2. **Verifica manualmente** le installazioni
3. **Testa componenti singoli** (Pandoc e PDFtk separatamente)
4. **Usa installazione manuale** come ultima risorsa