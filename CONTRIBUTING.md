# Contributing Guidelines

## 🌟 Come Contribuire al Progetto

Grazie per il tuo interesse nel contribuire a questo progetto! Questa guida ti aiuterà a comprendere le convenzioni e i processi che utilizziamo.

---

## 📋 Standard Messaggi Commit

### 🧱 Formato Base

```text
[TIPO] Azione svolta | OBJ: nome_oggetto | Dettaglio opzionale
```

Tutti i campi sono separati da `|` per garantire uniformità e leggibilità.

### 🏋️ Tipi di Commit

| Tag | Significato |
|-----|------------|
| `[DOC]` | Documentazione |
| `[FEAT]` | Nuova funzionalità |
| `[FIX]` | Correzione bug o errore |
| `[REF]` | Refactoring o pulizia del codice |
| `[TEST]` | Test creati o aggiornati |
| `[OPS]` | Attività operative o di sistema |
| `[CONF]` | Configurazione modificata |
| `[BUILD]` | Script di build, automazione |
| `[RM]` | Rimozione di codice o file |

### ✅ Esempi di Commit

```text
[FEAT] Aggiunto esercizio algebra booleana | OBJ: esercizio-8-semplificazione-avanzata | Livello universitario
[FIX] Corretti errori LaTeX | OBJ: esercizio-2-semplificazione-mux | Problemi encoding UTF-8
[DOC] Aggiornato README | OBJ: README.md | Sezione troubleshooting
[BUILD] Ottimizzato script PDF | OBJ: genera-pdf.ps1 | Gestione errori migliorata
[REF] Semplificata struttura esercizi | OBJ: categoria-1-algebra-booleana | Template standardizzato
```

### 🧠 Best Practice Commit

- ✅ Scrivi sempre **al passato**: "Aggiunto", "Corretto", "Aggiornato"
- ✅ Mantieni il messaggio **su una sola riga**
- ✅ Non omettere mai il `[TIPO]` iniziale
- ✅ Usa `OBJ:` per identificare chiaramente il file/componente
- ✅ Aggiungi dettagli utili nel campo finale
- ❌ Non usare versioni nel commit (gestite separatamente)

---

## 📁 Struttura del Progetto

### Aggiungere Nuovi Esercizi

1. **Crea la cartella dell'esercizio**:
   ```
   src/esercizi/categoria-X-argomento/esercizio-Y-nome-descrittivo/
   ```

2. **Usa il template standard**:
   ```markdown
   # Esercizio
   
   [Descrizione del problema con equazione/diagramma]
   ```

3. **Aggiungi immagini se necessarie**:
   - Formato: `.png`, `.jpg`, `.svg`
   - Risoluzione: minimo 300 DPI
   - Nomi descrittivi

4. **Testa la generazione PDF**:
   ```powershell
   .\build\genera-pdf.ps1 -Verbose
   ```

5. **Commit seguendo lo standard**:
   ```text
   [FEAT] Aggiunto nuovo esercizio | OBJ: esercizio-Y-nome | Descrizione breve
   ```

### Modificare Sistema Build

1. **Script in `tools/`** per nuove funzionalità di sistema
2. **Estendi `build/genera-pdf.ps1`** per nuove features PDF
3. **Aggiorna documentazione** per ogni modifica significativa
4. **Mantieni log dettagliati** in `output/logs/`

---

## 🎯 Categorie Esercizi

### Categoria 1: Algebra Booleana
- **Focus**: Semplificazioni, mappe K, teoremi
- **Template**: Equazioni con primo e secondo membro
- **Verifica**: Tabelle di verità obbligatorie

### Categoria 2: Reti Combinatorie
- **Focus**: Multiplexer, decoder, circuiti logici
- **Template**: Diagrammi + specifiche tecniche
- **Verifica**: Simulazione circuitale

### Categoria 3: FSM Mealy
- **Focus**: Automi con uscite su transizioni
- **Template**: Diagrammi stati + tabelle transizione
- **Verifica**: Trace di esecuzione

### Categoria 4: FSM Moore
- **Focus**: Automi con uscite su stati
- **Template**: Diagrammi stati + codifica
- **Verifica**: Diagrammi temporali

### Categoria 5: Assembly Programmi
- **Focus**: Algoritmi, loop, strutture dati
- **Template**: Codice assembly commentato
- **Verifica**: Trace esecuzione step-by-step

### Categoria 6: Assembly Procedure
- **Focus**: Procedure, stack, parametri
- **Template**: Codice + stack frame analysis
- **Verifica**: Gestione memoria

---

## 🔧 Processo di Review

### Prima di Sottomettere

1. **Verifica struttura**:
   - [ ] Cartella nel posto giusto
   - [ ] Nome file corretto
   - [ ] Template rispettato

2. **Testa funzionalità**:
   - [ ] PDF si genera senza errori
   - [ ] Formule LaTeX corrette
   - [ ] Immagini caricate correttamente

3. **Controllo qualità**:
   - [ ] Contenuto pedagogicamente valido
   - [ ] Livello di difficoltà appropriato
   - [ ] Spiegazioni chiare e complete

### Processo di Merge

1. **Revisione automatica**: Script di verifica
2. **Revisione manuale**: Controllo qualità contenuto
3. **Test integrazione**: Generazione PDF completa
4. **Merge**: Solo dopo approvazione

---

## 🚨 Troubleshooting Contribuzioni

### Errori Comuni

#### PDF non si genera
**Soluzioni**:
- Verifica sintassi Markdown
- Controlla formule LaTeX
- Usa `-Verbose` per dettagli errore
- Consulta `output/logs/`

#### Commit respinto
**Cause**:
- Formato messaggio non standard
- File binari non appropriati
- Conflitti di merge non risolti

#### Struttura non rispettata
**Controlli**:
- Nome cartella corretto
- Template file seguito
- Posizione nella gerarchia giusta

---

## 📞 Supporto

Per domande o problemi:

1. **Consulta README.md** per documentazione generale
2. **Controlla issues esistenti** su GitHub
3. **Crea nuovo issue** se il problema persiste
4. **Usa label appropriate** per categorizzare

---

## 🏆 Riconoscimenti

Ogni contribuzione significativa verrà riconosciuta nel progetto. Grazie per aiutare a migliorare questo strumento di studio!

---

**Ultimo aggiornamento**: 2025-10-05