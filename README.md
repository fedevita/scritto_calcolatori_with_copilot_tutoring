# Scritto Calcolatori with Copilot Tutoring

## 📖 Descrizione

Progetto di allenamento per l'esame scritto di Calcolatori utilizzando **GitHub Copilot come tutor personale**. 

Il repository è organizzato in una **architettura pulita e strutturata** con categorie di esercizi basate su un compito d'esame reale, permettendo un allenamento sistematico e guidato su tutti gli argomenti principali.

## �️ Architettura del Progetto

```
scritto_calcolatori_with_copilot_tutoring/
├── src/                        # Contenuti source
│   ├── esercizi/               # Tutti gli esercizi organizzati per categoria
│   │   ├── categoria-1-algebra-booleana/
│   │   ├── categoria-2-reti-combinatorie/
│   │   ├── categoria-3-fsm-mealy/
│   │   ├── categoria-4-fsm-moore/
│   │   ├── categoria-5-assembly-programmi/
│   │   └── categoria-6-assembly-procedure/
│   └── compiti-esempio/        # Esempi di compiti d'esame
├── build/                      # Script di automazione e build
│   └── genera-pdf.ps1          # Script principale di generazione PDF
├── output/                     # Risultati della generazione
│   ├── pdf/                    # PDF generati per categoria
│   └── logs/                   # Log di sistema e operazioni
├── tools/                      # Strumenti di setup e verifica
│   ├── setup-dipendenze.ps1   # Setup automatico dipendenze
│   ├── verifica-sistema.ps1    # Verifica sistema e dipendenze
│   └── installers/             # File di installazione
├── docs/                       # Documentazione modulare
└── genera-pdf.ps1              # Script di lancio (wrapper)
```

## �🎯 Obiettivo

Prepararsi efficacemente all'esame di Calcolatori attraverso:
- ✅ **Allenamento guidato** con GitHub Copilot come tutor
- ✅ **Categorizzazione sistematica** degli esercizi per tipologia
- ✅ **Pratica progressiva** su tutte le competenze richieste
- ✅ **Feedback immediato** e spiegazioni dettagliate
- ✅ **Setup automatizzato** delle dipendenze e ambiente
- ✅ **Generazione PDF automatica** per studio offline

## 📚 Categorie di Esercizi

### **Categoria 1: Algebra Booleana e Multiplexer** 🔢
- Dimostrazioni algebriche booleane
- Implementazione con multiplexer
- Semplificazioni e trasformazioni

### **Categoria 2: Reti Combinatorie** ⚡
- Progettazione circuiti combinatori
- Tabelle di verità
- Forme canoniche (SOP/POS)
- Mappe di Karnaugh
- Schemi circuitali

### **Categoria 3: Macchine a Stati Finiti - Mealy** 🔄
- Riconoscimento di sequenze
- State Transition Graph (STG)
- State Transition Table (STT)
- Codifica degli stati
- Implementazione circuitale

### **Categoria 4: Macchine a Stati Finiti - Moore** 🎛️
- Contatori e controlli
- Logiche di enable/hold
- STG e STT per Moore
- Contatori modulo-N

### **Categoria 5: Assembly ARM - Programmi Base** 💻
- Elaborazione di array
- Operazioni aritmetiche
- Cicli e condizioni
- Gestione memoria

### **Categoria 6: Assembly ARM - Procedure** ⚙️
- Definizione di procedure
- Passaggio parametri
- Filtering e trasformazioni dati
- Gestione stack

## � Come Utilizzare

1. **Scegli una categoria** di esercizi da praticare
2. **Studia l'esempio** di riferimento nella cartella della categoria
3. **Prova a risolvere** l'esercizio autonomamente
4. **Chiedi aiuto a Copilot** quando necessario per:
   - Spiegazioni teoriche
   - Suggerimenti sui passaggi
   - Verifica delle soluzioni
   - Approcci alternativi

## 🛠️ Tecnologie e Strumenti

- **GitHub Copilot** - Tutor AI per l'apprendimento
- **Assembly ARM** - Programmazione a basso livello  
- **Logica Digitale** - Algebra booleana, FSM, circuiti
- **Markdown** - Documentazione e note
- **Git** - Versionamento e tracciamento progressi

## 📂 Struttura del progetto

```
scritto_calcolatori_with_copilot_tutoring/
├── README.md                          # Guida al progetto
├── compito-esempio-05092025.md        # Compito di riferimento
├── categoria-1-algebra-booleana/      # Algebra booleana e MUX
├── categoria-2-reti-combinatorie/     # Circuiti combinatori
├── categoria-3-fsm-mealy/             # Macchine a stati Mealy
├── categoria-4-fsm-moore/             # Macchine a stati Moore
├── categoria-5-assembly-programmi/    # Assembly ARM base
├── categoria-6-assembly-procedure/    # Assembly ARM procedure
└── artifacts/                         # PDF generati (ignorata da Git)
```

## 📄 Generazione PDF

Il progetto include uno script PowerShell per generare automaticamente i PDF di tutti gli esercizi nella cartella `artifacts/`:

```powershell
# Genera solo i PDF mancanti
.\genera-pdf.ps1

# Rigenera tutti i PDF
.\genera-pdf.ps1 -Force

# Output dettagliato
.\genera-pdf.ps1 -Verbose

# Rigenerazione completa con dettagli
.\genera-pdf.ps1 -Force -Verbose
```

### 📁 Organizzazione PDF

I PDF vengono salvati nella cartella `artifacts/` con la nomenclatura:
- `categoria-1-algebra-booleana_esercizio-1-dimostrazione-algebrica.pdf`
- `categoria-2-reti-combinatorie_esercizio-1-numeri-primi.pdf`
- `categoria-3-fsm-mealy_esercizio-1-riconoscimento-1010.pdf`
- E così via...

### 📚 Dispensa Unificata

Lo script genera automaticamente una **dispensa completa** che unisce tutti gli esercizi:

```
artifacts/dispensa-completa-esercizi.pdf
```

**Caratteristiche della dispensa:**
- **🔗 Unione intelligente**: Tutti gli 8 esercizi uniti con PDFtk
- **📋 Metadati professionali**: Titolo, autore, data di creazione automatici
- **🎨 Layout pulito**: Nessun numero di pagina, aspetto completamente pulito
- **🗜️ Ottimizzazione**: PDF compresso per dimensioni ridotte
- **📊 Ordine logico**: Esercizi organizzati per categoria progressiva

**Ideale per:**
- 👥 Condivisione con altri studenti
- 📖 Studio completo di tutti gli argomenti
- 🖨️ Stampa di riferimento rapido
- 📱 Lettura mobile senza distrazioni

**Note:**
- La cartella `artifacts/` e tutti i PDF **non sono tracciati** da Git (esclusi tramite `.gitignore`)
- I PDF vengono **rigenerati automaticamente** quando necessario
- Lo script utilizza **Pandoc con XeLaTeX** per il rendering di formule matematiche
- Richiede l'installazione di [Pandoc](https://pandoc.org/) e [PDFtk](https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/)

### 🎨 Miglioramenti Layout

**PDF senza numeri di pagina:**
- **Aspetto pulito**: Nessuna distrazione da elementi di navigazione
- **Lettura fluida**: Focus completo sul contenuto
- **Stampa ottimizzata**: Layout professionale per materiale di studio
- **Margini standardizzati**: 2cm uniformi per tutti i documenti

### 📊 Sistema di Logging

Lo script include un sistema di logging completo che traccia tutte le operazioni:

```powershell
# I log vengono salvati automaticamente in: logs/genera-pdf_YYYY-MM-DD_HH-mm-ss.log
```

**Caratteristiche del sistema di logging:**
- **Timestamp automatico** per ogni operazione
- **Output duplicato** su console e file di log
- **File di errore preservati** per debugging (solo quelli rilevanti)
- **Log strutturati** con dettagli sui comandi Pandoc eseguiti
- **Gestione errori avanzata** con distinzione tra warning e errori fatali

**File generati:**
- `logs/genera-pdf_YYYY-MM-DD_HH-mm-ss.log` - Log completo dell'esecuzione
- `logs/pandoc_error_*.tmp` - File di errore temporanei (solo se rilevanti)

**Note:**
- La cartella `logs/` **non è tracciata** da Git (esclusa tramite `.gitignore`)
- I log permettono di diagnosticare problemi di generazione PDF
- I file di errore vengono preservati solo se contengono informazioni utili
- Lo script gestisce automaticamente la pulizia dei file temporanei

### 🛠️ Setup Automatico Dipendenze

**Installazione semplificata (RACCOMANDATO):**
```powershell
# Setup automatico di tutte le dipendenze
.\tools\setup-dipendenze.ps1

# Verifica installazione
.\tools\verifica-sistema.ps1

# Genera PDF
.\genera-pdf.ps1
```

**Vantaggi del setup automatico:**
- ✅ **Download automatico** delle versioni più recenti
- ✅ **Installazione silenziosa** senza intervento utente
- ✅ **Verifica post-installazione** e diagnostica
- ✅ **Logging completo** per troubleshooting
- ✅ **Supporto fallback** per installazione manuale

### 🛠️ Prerequisiti Tecnici

**Software richiesto:**
- [Pandoc](https://pandoc.org/) - Per la conversione Markdown → PDF
- [PDFtk](https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/) - Per l'unione dei PDF
- PowerShell - Per l'esecuzione dello script

**Installazione manuale** (se il setup automatico non funziona):
1. Scarica e installa [Pandoc](https://pandoc.org/)
2. Scarica e installa [PDFtk](https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/)
3. Riavvia PowerShell e verifica: `.\tools\verifica-sistema.ps1`

**Controllo automatico:**
- Lo script verifica automaticamente la presenza di Pandoc e PDFtk
- Fornisce suggerimenti per setup automatico se mancanti
- Include diagnostica dettagliata per troubleshooting

## 📚 Come Utilizzare la Dispensa

### 🎯 Per lo Studio Individuale:
1. **Genera la dispensa completa**: `.\genera-pdf.ps1`
2. **Studia per categoria**: La dispensa è organizzata progressivamente
3. **Usa i PDF singoli**: Per focus su argomenti specifici
4. **Consulta i log**: Per debugging o informazioni tecniche

### 👥 Per Aiutare Altri Studenti:
1. **Condividi la dispensa unificata**: File `dispensa-completa-esercizi.pdf`
2. **Stampa sezioni specifiche**: Usa i PDF singoli per argomenti mirati
3. **Aggiorna contenuto**: Modifica i Markdown e rigenera con `-Force`
4. **Mantieni aggiornato**: Il repository è la fonte di verità

## 🔧 Strumenti e Utilità

### 📋 Script Disponibili:

| Script | Scopo | Utilizzo |
|--------|-------|----------|
| `.\genera-pdf.ps1` | **Generazione PDF principale** | `.\genera-pdf.ps1 -Force -Verbose` |
| `.\tools\setup-dipendenze.ps1` | **Setup automatico dipendenze** | `.\tools\setup-dipendenze.ps1` |
| `.\tools\verifica-sistema.ps1` | **Diagnostica sistema** | `.\tools\verifica-sistema.ps1 -Detailed` |

### 🚀 Comandi Principali:

```powershell
# PRIMO SETUP (una sola volta)
.\tools\setup-dipendenze.ps1          # Installa Pandoc + PDFtk
.\tools\verifica-sistema.ps1          # Verifica installazione

# USO QUOTIDIANO  
.\genera-pdf.ps1                      # Genera PDF mancanti
.\genera-pdf.ps1 -Force               # Rigenera tutti i PDF
.\genera-pdf.ps1 -Force -Verbose      # Rigenera con dettagli

# TROUBLESHOOTING
.\tools\verifica-sistema.ps1 -Detailed # Diagnostica completa
Get-Content output\logs\*.log | Select -Last 10 # Ultimi log
```

### 🔄 Flusso di Lavoro Consigliato:
```bash
# 1. Studia/modifica gli esercizi nei file .md in src/esercizi/
# 2. Genera PDF aggiornati
.\genera-pdf.ps1 -Force

# 3. Controlla i log per eventuali problemi
Get-Content output\logs\genera-pdf_*.log | Select-Object -Last 20

# 4. Condividi la dispensa aggiornata
# File: output\pdf\dispensa-completa-esercizi.pdf
```

## 📖 Documentazione Completa

Per informazioni dettagliate, consulta la documentazione modulare:

- **[Setup e Installazione](docs/setup.md)** - Guida completa al primo setup
- **[Generazione PDF](docs/generazione-pdf.md)** - Utilizzo avanzato del sistema di build  
- **[Struttura Progetto](docs/struttura-progetto.md)** - Architettura e organizzazione
- **[Troubleshooting](docs/troubleshooting.md)** - Risoluzione problemi comuni

## 🤝 Contributi

Questo è un progetto educativo per lo scritto di Calcolatori.

## 📝 Standard commit

Il progetto utilizza uno standard specifico per i messaggi di commit:

```text
[TIPO] Azione svolta | OBJ: nome_oggetto | Ver: x.y.z | Dettaglio opzionale
```

### Tipi di commit:
- `[DOC]` - Documentazione
- `[FEAT]` - Nuova funzionalità
- `[ADD]` - Aggiunta di nuovo file/oggetto
- `[FIX]` - Correzione bug
- `[REF]` - Refactoring
- `[TEST]` - Test
- `[OPS]` - Attività operative
- `[CONF]` - Configurazione
- `[BUILD]` - Build/CI-CD
- `[RM]` - Rimozione

## 📄 Licenza

Progetto educativo - vedere dettagli con il docente.

## 📧 Contatti

- Studente: [Nome]
- Email: [email]
- Corso: Calcolatori