# Struttura del Progetto

## 📁 Panoramica Architettura

Il progetto utilizza una **architettura pulita e modulare** che separa logicamente i contenuti, gli strumenti di build, e i risultati generati.

```
scritto_calcolatori_with_copilot_tutoring/
├── src/                        # 📚 CONTENUTI SOURCE
├── build/                      # 🔧 AUTOMAZIONE E BUILD  
├── output/                     # 📄 RISULTATI GENERATI
├── tools/                      # 🛠️ STRUMENTI DI SISTEMA
├── docs/                       # 📖 DOCUMENTAZIONE
└── genera-pdf.ps1              # 🚀 ENTRY POINT
```

## 📚 Directory `src/` - Contenuti Source

### `src/esercizi/` - Raccolta Esercizi
Organizzazione per **categoria tematica**:

```
src/esercizi/
├── categoria-1-algebra-booleana/
│   ├── esercizio-1-dimostrazione-algebrica/
│   │   ├── esercizio-1-dimostrazione-algebrica.md
│   │   └── [immagini e allegati]
│   ├── esercizio-2-semplificazione-mux/
│   └── esercizio-3-funzione-or/
├── categoria-2-reti-combinatorie/
├── categoria-3-fsm-mealy/
├── categoria-4-fsm-moore/
├── categoria-5-assembly-programmi/
└── categoria-6-assembly-procedure/
```

### `src/compiti-esempio/` - Esempi Completi
Compiti d'esame completi di riferimento per la pratica.

## 🔧 Directory `build/` - Automazione e Build

### `build/genera-pdf.ps1` - Script Principale
- **Conversione**: Markdown → PDF con Pandoc
- **Unificazione**: Merge PDF con PDFtk
- **Logging**: Tracciamento completo operazioni
- **Gestione Errori**: Recovery e diagnostica

## 📄 Directory `output/` - Risultati Generati

### `output/pdf/` - PDF Generati
- **PDF Individuali**: Un file per ogni esercizio
- **Dispensa Unificata**: `dispensa-completa-esercizi.pdf`
- **Nomenclatura**: `categoria-X-nome_esercizio-Y-nome.pdf`

### `output/logs/` - Log Sistema
- **Log Generazione**: `genera-pdf_YYYY-MM-DD_HH-mm-ss.log`
- **Log Setup**: `setup-dipendenze_YYYY-MM-DD.log`
- **File Temporanei**: Error files per debugging

## 🛠️ Directory `tools/` - Strumenti di Sistema

### `tools/setup-dipendenze.ps1` - Setup Automatico
- **Download**: Pandoc e PDFtk
- **Installazione**: Automatica e verificata
- **Logging**: Operazioni tracciabili

### `tools/verifica-sistema.ps1` - Diagnostica
- **Verifica Dipendenze**: Pandoc, PDFtk, LaTeX
- **Test Funzionalità**: Conversione e merge
- **Report Completo**: Stato sistema dettagliato

### `tools/installers/` - Cache Installatori
File di installazione scaricati per riutilizzo offline.

## 📖 Directory `docs/` - Documentazione

### Documentazione Modulare
- **`setup.md`**: Guida installazione e configurazione
- **`generazione-pdf.md`**: Utilizzo sistema di build
- **`struttura-progetto.md`**: Questo documento
- **`troubleshooting.md`**: Risoluzione problemi comuni

## 🚀 Entry Point - `genera-pdf.ps1`

### Script di Lancio (Wrapper)
- **Interfaccia Unificata**: Stesso comando di sempre
- **Redirezione**: Chiama `build\genera-pdf.ps1`
- **Passthrough**: Preserva tutti i parametri
- **Backward Compatibility**: Mantiene compatibilità

## 🔄 Flusso di Lavoro

### 1. Sviluppo Esercizi
```
src/esercizi/categoria-X/esercizio-Y/
└── esercizio-Y.md  [Crea/Modifica]
```

### 2. Build e Generazione
```
.\genera-pdf.ps1  [Esegui da root]
│
└── build\genera-pdf.ps1  [Elaborazione]
    │
    ├── src\esercizi\  [Input]
    └── output\pdf\    [Output]
```

### 3. Output e Distribuzione
```
output/
├── pdf/               [Risultati]
└── logs/              [Tracciamento]
```

## 📐 Convenzioni di Naming

### Directory Categorie
- **Formato**: `categoria-{numero}-{tema-principale}`
- **Esempio**: `categoria-1-algebra-booleana`

### Directory Esercizi
- **Formato**: `esercizio-{numero}-{descrizione-breve}`
- **Esempio**: `esercizio-1-dimostrazione-algebrica`

### File Markdown
- **Nome**: Identico alla directory contenitore
- **Estensione**: `.md`
- **Esempio**: `esercizio-1-dimostrazione-algebrica.md`

### PDF Generati
- **Formato**: `{categoria}_{esercizio}.pdf`
- **Esempio**: `categoria-1-algebra-booleana_esercizio-1-dimostrazione-algebrica.pdf`

## 🎯 Vantaggi Architettura

### ✅ Separazione delle Responsabilità
- **Contenuti** separati da **automazione**
- **Input** distinto da **output**
- **Documentazione** centralizzata

### ✅ Scalabilità
- Facile aggiunta di nuove categorie
- Estensibile con nuovi tool di build
- Modulare per diversi formati output

### ✅ Manutenibilità
- Script di build isolati e testabili
- Log centralizzati per debugging
- Documentazione modulare e aggiornabile

### ✅ Portabilità
- Setup automatico delle dipendenze
- Struttura indipendente dal sistema
- Git-friendly con .gitignore appropriato