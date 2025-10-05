# Troubleshooting

## 🚨 Problemi Comuni e Soluzioni

### ⚠️ Errori di Setup

#### Pandoc non trovato
```
ERRORE: Pandoc non trovato! Installazione richiesta.
```

**Soluzioni:**
1. **Setup automatico**: `.\tools\setup-dipendenze.ps1`
2. **Verifica PATH**: Riavvia PowerShell dopo l'installazione
3. **Installazione manuale**: Scarica da https://pandoc.org/
4. **Verifica**: `pandoc --version`

#### PDFtk non disponibile
```
PDFtk non trovato! Installare PDFtk per generare la dispensa unificata.
```

**Soluzioni:**
1. **Setup automatico**: `.\tools\setup-dipendenze.ps1`
2. **Installazione manuale**: Scarica da pdflabs.com
3. **Nota**: I PDF individuali vengono comunque generati

#### Errori di download
```
Errore durante il download di Pandoc
```

**Soluzioni:**
1. **Controllo connessione**: Verifica accesso internet
2. **Firewall**: Controlla impostazioni proxy/firewall
3. **Download manuale**: Usa browser per scaricare in `tools\installers\`
4. **Retry**: Esegui nuovamente il setup

### 🔧 Errori di Generazione PDF

#### Directory non trovata
```
Impossibile trovare il percorso 'src\esercizi'
```

**Soluzioni:**
1. **Directory corretta**: Esegui da root del progetto
2. **Verifica struttura**: `ls src\esercizi`
3. **Path assoluto**: Usa `cd` per andare nella directory corretta

#### File Markdown mancante
```
Nessun file .md trovato in esercizio-X
```

**Soluzioni:**
1. **Verifica file**: Controlla che esista `esercizio-X.md`
2. **Nome corretto**: Il file deve avere lo stesso nome della directory
3. **Estensione**: Assicurati che sia `.md` e non `.txt`

#### Errori LaTeX
```
! LaTeX Error: File `{package}` not found.
```

**Soluzioni:**
1. **Setup LaTeX**: Installa MiKTeX o TeX Live
2. **Pacchetti mancanti**: `tlmgr install {package}`
3. **Verifica**: `.\tools\verifica-sistema.ps1 -Detailed`

### 📁 Problemi Struttura

#### Percorsi relativi
```
Build failed: relative path issues
```

**Soluzioni:**
1. **Working directory**: Sempre dalla root del progetto
2. **Script wrapper**: Usa `.\genera-pdf.ps1` non `build\genera-pdf.ps1` direttamente
3. **Percorsi assoluti**: Gli script gestiscono automaticamente i percorsi

#### Permessi file
```
Access denied to output directory
```

**Soluzioni:**
1. **Amministratore**: Esegui PowerShell come amministratore
2. **Antivirus**: Aggiungi cartella alle eccezioni
3. **File aperti**: Chiudi PDF aperti prima della rigenerazione

### 🔄 Problemi PowerShell

#### Execution Policy
```
execution of scripts is disabled on this system
```

**Soluzioni:**
1. **Set policy**: `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`
2. **Bypass**: `PowerShell -ExecutionPolicy Bypass -File .\genera-pdf.ps1`
3. **Unblock**: `Unblock-File .\genera-pdf.ps1`

#### Encoding problemi
```
Caratteri speciali non visualizzati correttamente
```

**Soluzioni:**
1. **UTF-8**: Salva i file .md in UTF-8
2. **Console**: `chcp 65001` per UTF-8 in console
3. **Editor**: Configura VS Code per UTF-8

### 📊 Debug e Diagnostica

#### Log dettagliati
```powershell
# Verifica sistema completo
.\tools\verifica-sistema.ps1 -Detailed

# Log generazione con dettagli
.\genera-pdf.ps1 -Verbose

# Ultimi errori
Get-Content output\logs\*.log | Select-String "ERROR" -Context 2
```

#### Test singolo esercizio
```powershell
# Test manuale Pandoc
cd "src\esercizi\categoria-1-algebra-booleana\esercizio-1-dimostrazione-algebrica"
pandoc esercizio-1-dimostrazione-algebrica.md -o test.pdf --pdf-engine=xelatex
```

#### Verifica dipendenze
```powershell
# Check versioni
pandoc --version
pdftk --version

# Check PATH
$env:PATH -split ';' | Where-Object { $_ -like "*pandoc*" -or $_ -like "*pdftk*" }
```

### 🔍 Analisi File di Log

#### Struttura log
```
[2025-10-05 12:07:51] Generatore PDF Esercizi Calcolatori
[2025-10-05 12:07:51] Pandoc trovato: pandoc 3.8.1
[2025-10-05 12:07:51] Trovate 6 categorie:
[2025-10-05 12:07:51] Processando categoria: categoria-1-algebra-booleana
```

#### Ricerca errori specifici
```powershell
# Errori PDF
Select-String -Path "output\logs\*.log" -Pattern "Errore|Error|Failed"

# Warning ignorabili
Select-String -Path "output\logs\*.log" -Pattern "WARNING.*font"

# File di output
Select-String -Path "output\logs\*.log" -Pattern "PDF generato"
```

### 💡 Best Practices

#### Prevenzione problemi
1. **Setup iniziale**: Sempre `.\tools\setup-dipendenze.ps1` prima volta
2. **Verifica regolare**: `.\tools\verifica-sistema.ps1` dopo aggiornamenti
3. **Backup**: Git commit frequenti prima di modifiche importanti
4. **Test graduali**: `.\genera-pdf.ps1 -Verbose` per vedere cosa succede

#### Workflow consigliato
```powershell
# 1. Verifica ambiente
.\tools\verifica-sistema.ps1

# 2. Test con verbose
.\genera-pdf.ps1 -Verbose

# 3. Se ok, generazione normale
.\genera-pdf.ps1

# 4. In caso di problemi, forzare tutto
.\genera-pdf.ps1 -Force -Verbose
```

### 🆘 Aiuto Avanzato

#### Reset completo ambiente
```powershell
# Pulisci output
Remove-Item output\* -Recurse -Force

# Re-setup dipendenze
.\tools\setup-dipendenze.ps1

# Test sistema
.\tools\verifica-sistema.ps1 -Detailed

# Rigenera tutto
.\genera-pdf.ps1 -Force -Verbose
```

#### Contatto supporto
Se i problemi persistono:
1. **Log completi**: Allega file da `output\logs\`
2. **Output comando**: Copia output di `.\tools\verifica-sistema.ps1 -Detailed`
3. **Sistema**: Specifica versione Windows e PowerShell
4. **Errore specifico**: Messaggio esatto dell'errore

#### Informazioni utili per debug
```powershell
# Info sistema
$PSVersionTable
Get-ComputerInfo | Select-Object WindowsProductName, WindowsVersion

# Info progetto
Get-ChildItem -Recurse -Name | Measure-Object
dir output\pdf\*.pdf | Measure-Object -Property Length -Sum
```