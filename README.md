# Scritto Calcolatori with Copilot Tutoring

## 📖 Descrizione

Progetto di allenamento per l'esame scritto di Calcolatori utilizzando **GitHub Copilot come tutor personale**. 

Il repository è organizzato in una **architettura pulita e strutturata** con categorie di esercizi basate su un compito d'esame reale, permettendo un allenamento sistematico e guidato su tutti gli argomenti principali.

## 🏗️ Architettura del Progetto

```
scritto_calcolatori_with_copilot_tutoring/
├── src/                        # 📚 Contenuti source
│   ├── esercizi/               # Tutti gli esercizi organizzati per categoria
│   │   ├── categoria-1-algebra-booleana/
│   │   ├── categoria-2-reti-combinatorie/
│   │   ├── categoria-3-fsm-mealy/
│   │   ├── categoria-4-fsm-moore/
│   │   ├── categoria-5-assembly-programmi/
│   │   └── categoria-6-assembly-procedure/
│   └── compiti-esempio/        # Esempi di compiti d'esame
├── build/                      # 🔧 Script di automazione e build
│   └── genera-pdf.ps1          # Script principale di generazione PDF
├── output/                     # 📄 Risultati della generazione
│   ├── pdf/                    # PDF generati per categoria
│   └── logs/                   # Log di sistema e operazioni
├── tools/                      # 🛠️ Strumenti di setup e verifica
│   ├── setup-dipendenze.ps1   # Setup automatico dipendenze
│   ├── verifica-sistema.ps1    # Verifica sistema e dipendenze
│   └── installers/             # File di installazione
└── README.md                   # 📖 Questa documentazione
```

### 📁 Dettaglio Directory

#### `src/esercizi/` - Raccolta Esercizi
Organizzazione per **categoria tematica**:
- **categoria-1-algebra-booleana/** - Manipolazione booleana, mappe K, semplificazioni
- **categoria-2-reti-combinatorie/** - Reti logiche, multiplexer, decoder
- **categoria-3-fsm-mealy/** - Automi a stati finiti tipo Mealy
- **categoria-4-fsm-moore/** - Automi a stati finiti tipo Moore
- **categoria-5-assembly-programmi/** - Programmazione assembly, algoritmi
- **categoria-6-assembly-procedure/** - Procedure, stack, chiamate

#### `build/` - Automazione
- **genera-pdf.ps1** - Engine principale per conversione Markdown→PDF con supporto LaTeX

#### `output/` - Risultati
- **pdf/** - PDF generati per ogni esercizio + dispensa unificata
- **logs/** - File di log dettagliati per debugging

#### `tools/` - Strumenti Sistema
- **setup-dipendenze.ps1** - Installazione automatica Pandoc + PDFtk
- **verifica-sistema.ps1** - Controllo stato dipendenze e configurazione

## 🚀 Quick Start

### 1. Clone e Setup
```powershell
git clone <repository-url>
cd scritto_calcolatori_with_copilot_tutoring

# Setup automatico dipendenze
.\tools\setup-dipendenze.ps1

# Verifica che tutto funzioni
.\tools\verifica-sistema.ps1
```

### 2. Prima Generazione PDF
```powershell
# Genera tutti i PDF degli esercizi
.\build\genera-pdf.ps1 -Verbose
```

### 3. Verifica Risultati
```powershell
# Controlla i PDF generati
ls output\pdf\

# Apri la dispensa completa
.\output\pdf\dispensa-completa-esercizi.pdf
```

## 📝 Utilizzo Sistema PDF

### Comandi Base
```powershell
# Genera solo i PDF mancanti
.\build\genera-pdf.ps1

# Rigenera tutti i PDF anche se esistenti
.\build\genera-pdf.ps1 -Force

# Output dettagliato durante la generazione
.\build\genera-pdf.ps1 -Verbose

# Combinazione: rigenera tutto con dettagli
.\build\genera-pdf.ps1 -Force -Verbose
```

### Output Generato

#### PDF Individuali
- **Posizione**: `output\pdf\`
- **Formato**: `categoria-X-nome_esercizio-Y-nome.pdf`
- **Esempio**: `categoria-1-algebra-booleana_esercizio-1-dimostrazione-algebrica.pdf`

#### Dispensa Unificata
- **Nome**: `dispensa-completa-esercizi.pdf`
- **Contenuto**: Tutti i PDF uniti in ordine logico per categoria
- **Metadati**: Titolo, autore, soggetto
- **Dimensione**: ~500KB per 8 esercizi

### Caratteristiche Tecniche
- **Engine PDF**: XeLaTeX via Pandoc per supporto LaTeX completo
- **Formule matematiche**: Supporto nativo MathML
- **Immagini**: Risoluzione 300 DPI
- **Margini**: 2cm standardizzati
- **Font**: Supporto Unicode completo

## 📋 Dipendenze e Setup

### Dipendenze Automatiche
Il script `.\tools\setup-dipendenze.ps1` installa automaticamente:
- **Pandoc** - Conversione Markdown → PDF con supporto LaTeX
- **PDFtk** - Unione e gestione PDF per dispensa unificata

### Dipendenze Sistema
- **PowerShell 5.1+** - Già incluso in Windows
- **Connessione Internet** - Per download automatico dipendenze

### Setup Manuale (Se Necessario)

#### Installazione Pandoc
1. Scarica da: https://pandoc.org/installing.html
2. Installa il pacchetto MSI per Windows
3. Verifica: `pandoc --version`

#### Installazione PDFtk
1. Scarica da: https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/
2. Installa l'eseguibile per Windows
3. Verifica: `pdftk --version`

## 🎯 Workflow di Studio

### 1. Analisi Esercizi
- Naviga in `src\esercizi\categoria-X\`
- Studia il file `.md` con testo e formule
- Osserva diagrammi e immagini incluse

### 2. Allenamento con Copilot
- Usa GitHub Copilot per:
  - Spiegazioni step-by-step
  - Chiarimenti su concetti
  - Suggerimenti per la risoluzione
  - Verifica delle soluzioni

### 3. Generazione Materiale
- Genera PDF per studio offline: `.\build\genera-pdf.ps1`
- Usa dispensa unificata per ripasso completo
- Consulta log per debugging eventuali problemi

### 4. Espansione Repository
- Aggiungi nuovi esercizi in `src\esercizi\categoria-X\`
- Mantieni struttura: `esercizio-N-nome-descrittivo\`
- Include file `.md` + eventuali immagini
- Rigenera PDF: `.\build\genera-pdf.ps1 -Force`

## 🔧 Struttura Esercizi

### Template Cartella Esercizio
```
categoria-X-argomento/
└── esercizio-Y-nome-descrittivo/
    ├── esercizio-Y-nome-descrittivo.md    # Testo principale
    ├── schema-diagramma.jpg               # Immagini di supporto
    └── tabella-risultati.png              # Grafici e tabelle
```

### Template File Markdown
```markdown
# Esercizio Y - Nome Descrittivo

## Testo del Problema
[Descrizione del problema...]

## Dati
- Variabile A: ...
- Variabile B: ...

## Richiesta
[Cosa si chiede di fare...]

## Soluzione
[Soluzione step-by-step...]

### Passaggio 1
[Spiegazione...]

### Passaggio 2
[Spiegazione...]

## Risultato Finale
[Risultato e verifica...]
```

## 🚨 Troubleshooting

### Errori di Setup

#### "Pandoc non trovato"
**Soluzioni:**
1. Esegui: `.\tools\setup-dipendenze.ps1`
2. Riavvia PowerShell dopo l'installazione
3. Verifica PATH: `pandoc --version`
4. Setup manuale da https://pandoc.org/

#### "PDFtk non disponibile"
**Soluzioni:**
1. Esegui: `.\tools\setup-dipendenze.ps1`
2. Download manuale da pdflabs.com
3. **Nota**: I PDF individuali vengono comunque generati

#### Errori di download
**Soluzioni:**
1. Verifica connessione internet
2. Controlla firewall/proxy
3. Download manuale in `tools\installers\`
4. Retry setup

### Errori di Generazione PDF

#### "Directory non trovata"
**Soluzioni:**
1. Esegui dalla root del progetto
2. Verifica struttura: `ls src\esercizi`
3. Usa `cd` per directory corretta

#### "Pandoc failed"
**Soluzioni:**
1. Verifica sintassi Markdown
2. Controlla immagini esistenti
3. Usa `-Verbose` per dettagli
4. Consulta `output\logs\`

#### "PDFtk merge failed"
**Soluzioni:**
1. PDF individuali vengono comunque creati
2. Verifica installazione PDFtk
3. Controlla spazio su disco
4. Riprova con `-Force`

### Errori di Scrittura File

#### "Accesso negato"
**Soluzioni:**
1. Chiudi PDF aperti in viewer
2. Esegui come amministratore
3. Verifica permessi cartella `output\`

#### "Spazio insufficiente"
**Soluzioni:**
1. Libera spazio su disco
2. Pulisci `output\logs\` dai file vecchi
3. Verifica in `output\pdf\`

## 🎓 Categorie di Esercizi

### Categoria 1: Algebra Booleana
- **Focus**: Manipolazione espressioni, mappe K, semplificazioni
- **Competenze**: Teoremi booleani, forma normale, ottimizzazione
- **Strumenti**: Tabelle verità, mappe di Karnaugh

### Categoria 2: Reti Combinatorie  
- **Focus**: Design circuiti logici, multiplexer, decoder
- **Competenze**: Sintesi reti, analisi temporale, ottimizzazione
- **Strumenti**: Porte logiche, componenti standard

### Categoria 3: FSM Mealy
- **Focus**: Automi a stati finiti con uscite su transizioni
- **Competenze**: Design FSM, diagrammi stati, codifica
- **Strumenti**: Grafi stati, tabelle transizione

### Categoria 4: FSM Moore
- **Focus**: Automi a stati finiti con uscite su stati
- **Competenze**: Conversione Mealy/Moore, contatori, sequencer
- **Strumenti**: Diagrammi temporali, flip-flop

### Categoria 5: Assembly Programmi
- **Focus**: Programmazione assembly, algoritmi, strutture dati
- **Competenze**: Istruzioni base, loop, condizionali
- **Strumenti**: Debugger, trace execution

### Categoria 6: Assembly Procedure
- **Focus**: Procedure, stack, gestione parametri
- **Competenze**: Chiamate funzione, scope variabili, ricorsione
- **Strumenti**: Stack frame, calling convention

## 📊 Statistiche Progetto

- **Categorie**: 6 aree tematiche
- **Esercizi**: 8+ esercizi completi
- **PDF Generation**: Sistema automatico completo
- **Documentation**: Centralizzata in README
- **Scripts**: 3 tool automatici (setup, verifica, generazione)
- **Architecture**: Modulare e estendibile

## 🤝 Contribuire

Per contribuire a questo progetto, consulta le **[linee guida di contribuzione](CONTRIBUTING.md)** che includono:

- 📝 **Standard messaggi commit** - Formato unificato per i commit
- 🏗️ **Struttura esercizi** - Come aggiungere nuovi contenuti
- 🔧 **Processo di review** - Come sottomettere modifiche
- 🚨 **Troubleshooting** - Soluzioni ai problemi comuni

### Quick Start Contribuzioni
1. Leggi `CONTRIBUTING.md` per le convenzioni
2. Crea cartella in `src\esercizi\categoria-X\`
3. Segui il template markdown standard
4. Testa con `.\build\genera-pdf.ps1 -Verbose`
5. Commit seguendo lo standard `[TIPO] Azione | OBJ: file`

## 📄 Licenza

Progetto educativo per preparazione esame Calcolatori.

---

**🎯 Buono studio con GitHub Copilot!** 🚀