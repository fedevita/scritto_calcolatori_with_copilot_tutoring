# Scritto Calcolatori with Copilot Tutoring

## 📖 Descrizione

Progetto di allenamento per l'esame scritto di Calcolatori utilizzando **GitHub Copilot come tutor personale**. 

Il repository è organizzato in categorie di esercizi basate su un compito d'esame reale, permettendo un allenamento sistematico e guidato su tutti gli argomenti principali.

## 🎯 Obiettivo

Prepararsi efficacemente all'esame di Calcolatori attraverso:
- ✅ **Allenamento guidato** con GitHub Copilot come tutor
- ✅ **Categorizzazione sistematica** degli esercizi per tipologia
- ✅ **Pratica progressiva** su tutte le competenze richieste
- ✅ **Feedback immediato** e spiegazioni dettagliate

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

**Note:**
- La cartella `artifacts/` e tutti i PDF **non sono tracciati** da Git (esclusi tramite `.gitignore`)
- I PDF vengono **rigenerati automaticamente** quando necessario
- Lo script utilizza **Pandoc con XeLaTeX** per il rendering di formule matematiche
- Richiede l'installazione di [Pandoc](https://pandoc.org/) nel sistema

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
- `logs/genera-pdf_2025-10-04_18-31-51.log` - Log completo dell'esecuzione
- `logs/pandoc_error_*.tmp` - File di errore temporanei (solo se rilevanti)

**Note:**
- La cartella `logs/` **non è tracciata** da Git (esclusa tramite `.gitignore`)
- I log permettono di diagnosticare problemi di generazione PDF
- I file di errore vengono preservati solo se contengono informazioni utili
- I PDF locali nelle cartelle degli esercizi vengono mantenuti per riferimento durante lo sviluppo

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