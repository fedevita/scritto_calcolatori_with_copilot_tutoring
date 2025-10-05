#Requires -Version 5.1

<#
.SYNOPSIS
    Setup automatico dipendenze per sistema generazione PDF - Scritto Calcolatori

.DESCRIPTION
    Script per installazione automatica di tutte le dipendenze necessarie:
    - Pandoc (conversione Markdown → PDF con supporto LaTeX)
    - PDFtk (unione e manipolazione PDF)
    
Write-Host "\nRISULTATO FINALE:" -ForegroundColor $(if ($finalPandoc -and $finalPDFtk) { "Green" } else { "Yellow" })
Write-Host "  Pandoc: $(if ($finalPandoc) { "[OK]" } else { "[X] Mancante" })"
Write-Host "  PDFtk:  $(if ($finalPDFtk) { "[OK]" } else { "[X] Mancante" })" Supporta installazione automatica su Windows con fallback manuale.

.PARAMETER Force
    Forza il download e reinstallazione anche se le dipendenze sono gia presenti

.PARAMETER SkipPandoc
    Salta l'installazione di Pandoc

.PARAMETER SkipPDFtk
    Salta l'installazione di PDFtk

.EXAMPLE
    .\setup-dipendenze.ps1
    Installa tutte le dipendenze mancanti

.EXAMPLE
    .\setup-dipendenze.ps1 -Force
    Reinstalla tutte le dipendenze

.EXAMPLE
    .\setup-dipendenze.ps1 -SkipPandoc
    Installa solo PDFtk
#>

param(
    [switch]$Force,
    [switch]$SkipPandoc,
    [switch]$SkipPDFtk,
    [switch]$Verbose
)

# === CONFIGURAZIONE ===
$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"  # Velocizza download

# Percorsi
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$InstallersDir = Join-Path $ScriptDir "installers"
$LogsDir = Join-Path (Split-Path -Parent $ScriptDir) "logs"

# URLs per download (versioni più recenti)
$PandocUrl = "https://github.com/jgm/pandoc/releases/latest/download/pandoc-windows-x86_64.msi"
$PDFtkUrl = "https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/pdftk_free-2.02-win-setup.exe"

# === FUNZIONI UTILITY ===

function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] [$Level] $Message"
    
    # Colori per livelli
    switch ($Level) {
        "ERROR" { Write-Host $logMessage -ForegroundColor Red }
        "WARN"  { Write-Host $logMessage -ForegroundColor Yellow }
        "SUCCESS" { Write-Host $logMessage -ForegroundColor Green }
        default { Write-Host $logMessage -ForegroundColor White }
    }
    
    # Salva anche su file se la cartella logs esiste
    if (Test-Path $LogsDir) {
        $logFile = Join-Path $LogsDir "setup-dipendenze_$(Get-Date -Format 'yyyy-MM-dd').log"
        $logMessage | Add-Content -Path $logFile -Encoding UTF8
    }
}

function Test-IsAdmin {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Test-CommandExists {
    param([string]$Command)
    try {
        if (Get-Command $Command -ErrorAction SilentlyContinue) {
            return $true
        }
        return $false
    }
    catch {
        return $false
    }
}

function Get-PandocVersion {
    try {
        $output = & pandoc --version 2>$null
        if ($output -match "pandoc\s+([\d\.]+)") {
            return $matches[1]
        }
    }
    catch { }
    return $null
}

function Get-PDFtkVersion {
    try {
        $output = & pdftk --version 2>$null
        if ($output -match "pdftk\s+([\d\.]+)") {
            return $matches[1]
        }
    }
    catch { }
    return $null
}

function Get-FileFromUrl {
    param(
        [string]$Url,
        [string]$OutputPath,
        [string]$Description
    )
    
    Write-Log "Download $Description da: $Url"
    
    try {
        # Crea directory se non esiste
        $dir = Split-Path -Parent $OutputPath
        if (!(Test-Path $dir)) {
            New-Item -ItemType Directory -Path $dir -Force | Out-Null
        }
        
        # Download con progress
        $webClient = New-Object System.Net.WebClient
        $webClient.DownloadFile($Url, $OutputPath)
        
        Write-Log "Download completato: $(Split-Path -Leaf $OutputPath)" "SUCCESS"
        return $true
    }
    catch {
        Write-Log "Errore download $Description : $($_.Exception.Message)" "ERROR"
        return $false
    }
}

function Install-PandocFromMSI {
    param([string]$MsiPath)
    
    Write-Log "Installazione Pandoc da: $MsiPath"
    
    try {
        $arguments = @(
            "/i", "`"$MsiPath`"",
            "/quiet",
            "/norestart"
        )
        
        $process = Start-Process -FilePath "msiexec.exe" -ArgumentList $arguments -Wait -PassThru
        
        if ($process.ExitCode -eq 0) {
            Write-Log "Pandoc installato con successo" "SUCCESS"
            return $true
        } else {
            Write-Log "Installazione Pandoc fallita (Exit Code: $($process.ExitCode))" "ERROR"
            return $false
        }
    }
    catch {
        Write-Log "Errore installazione Pandoc: $($_.Exception.Message)" "ERROR"
        return $false
    }
}

function Install-PDFtkFromEXE {
    param([string]$ExePath)
    
    Write-Log "Installazione PDFtk da: $ExePath"
    
    try {
        # PDFtk installer supporta installazione silenziosa
        $arguments = @("/S")  # Silent install
        
        $process = Start-Process -FilePath $ExePath -ArgumentList $arguments -Wait -PassThru
        
        if ($process.ExitCode -eq 0) {
            Write-Log "PDFtk installato con successo" "SUCCESS"
            return $true
        } else {
            Write-Log "Installazione PDFtk fallita (Exit Code: $($process.ExitCode))" "ERROR"
            return $false
        }
    }
    catch {
        Write-Log "Errore installazione PDFtk: $($_.Exception.Message)" "ERROR"
        return $false
    }
}

# === MAIN SCRIPT ===

Write-Host @"

========================================
  SETUP DIPENDENZE - SCRITTO CALCOLATORI
========================================
Installazione automatica di:
  • Pandoc (Markdown → PDF + LaTeX)
  • PDFtk (Unione e manipolazione PDF)

"@ -ForegroundColor Cyan

# Verifica permessi amministratore
if (!(Test-IsAdmin)) {
    Write-Log "ATTENZIONE: Script non eseguito come Amministratore" "WARN"
    Write-Log "Alcune installazioni potrebbero richiedere privilegi elevati" "WARN"
    
    $choice = Read-Host "Continuare comunque? (s/N)"
    if ($choice -notmatch "^[sS]") {
        Write-Log "Installazione annullata dall'utente" "WARN"
        exit 1
    }
}

# Assicura esistenza cartelle
if (!(Test-Path $LogsDir)) {
    New-Item -ItemType Directory -Path $LogsDir -Force | Out-Null
}
if (!(Test-Path $InstallersDir)) {
    New-Item -ItemType Directory -Path $InstallersDir -Force | Out-Null
}

Write-Log "Avvio setup dipendenze - Script con download automatico"

# === CONTROLLO STATO ATTUALE ===
Write-Log "Verifica dipendenze esistenti..."

$pandocInstalled = Test-CommandExists "pandoc"
$pandocVersion = if ($pandocInstalled) { Get-PandocVersion } else { $null }

$pdftkInstalled = Test-CommandExists "pdftk"
$pdftkVersion = if ($pdftkInstalled) { Get-PDFtkVersion } else { $null }

Write-Host "`nSTATO DIPENDENZE ATTUALI:" -ForegroundColor Yellow
Write-Host "  Pandoc: $(if ($pandocInstalled) { "[OK] Installato (v$pandocVersion)" } else { "[X] Non trovato" })"
Write-Host "  PDFtk:  $(if ($pdftkInstalled) { '[OK] Installato' + $(if ($pdftkVersion) { " (v$pdftkVersion)" } else { '' }) } else { '[X] Non trovato' })"

# === INSTALLAZIONE PANDOC ===
if (!$SkipPandoc) {
    if ($pandocInstalled -and !$Force) {
        Write-Log "Pandoc gia installato (v$pandocVersion) - Skip (usa -Force per reinstallare)"
    } else {
        Write-Log "=== INSTALLAZIONE PANDOC ===" "INFO"
        
        $pandocMsi = Join-Path $InstallersDir "pandoc-latest.msi"
        
        # Verifica se esiste gia il file MSI locale
        $existingMsi = Join-Path $InstallersDir "pandoc-installer.msi"
        if ((Test-Path $existingMsi) -and !$Force) {
            Write-Log "Trovato installer Pandoc locale: $existingMsi"
            $pandocMsi = $existingMsi
        } else {
            # Download versione più recente
            if (Get-FileFromUrl $PandocUrl $pandocMsi "Pandoc MSI") {
                # OK, procedi con installazione
            } else {
                Write-Log "Download fallito, tento con installer locale..." "WARN"
                if (Test-Path $existingMsi) {
                    $pandocMsi = $existingMsi
                } else {
                    Write-Log "Nessun installer Pandoc disponibile" "ERROR"
                    $pandocMsi = $null
                }
            }
        }
        
        if ($pandocMsi -and (Test-Path $pandocMsi)) {
            if (Install-PandocFromMSI $pandocMsi) {
                # Verifica installazione
                Start-Sleep -Seconds 2
                if (Test-CommandExists "pandoc") {
                    $newVersion = Get-PandocVersion
                    Write-Log "Pandoc installato correttamente (v$newVersion)" "SUCCESS"
                } else {
                    Write-Log "Pandoc installato ma non trovato nel PATH - riavvia PowerShell" "WARN"
                }
            }
        }
    }
}

# === INSTALLAZIONE PDFtk ===
if (!$SkipPDFtk) {
    if ($pdftkInstalled -and !$Force) {
        Write-Log "PDFtk gia installato - Skip (usa -Force per reinstallare)"
    } else {
        Write-Log "=== INSTALLAZIONE PDFtk ===" "INFO"
        
        $pdftkExe = Join-Path $InstallersDir "pdftk-setup.exe"
        
        # Download PDFtk
        if (Get-FileFromUrl $PDFtkUrl $pdftkExe "PDFtk Setup") {
            if (Install-PDFtkFromEXE $pdftkExe) {
                # Verifica installazione
                Start-Sleep -Seconds 2
                if (Test-CommandExists "pdftk") {
                    $newVersion = Get-PDFtkVersion
                    Write-Log "PDFtk installato correttamente $(if ($newVersion) { "(v$newVersion)" })" "SUCCESS"
                } else {
                    Write-Log "PDFtk installato ma non trovato nel PATH - riavvia PowerShell" "WARN"
                }
            }
        } else {
            Write-Log "Download PDFtk fallito - installazione manuale richiesta" "ERROR"
            Write-Log "Scarica da: https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/" "INFO"
        }
    }
}

# === VERIFICA FINALE ===
Write-Log "=== VERIFICA FINALE ===" "INFO"

$finalPandoc = Test-CommandExists "pandoc"
$finalPDFtk = Test-CommandExists "pdftk"

Write-Host "`nRISULTATO FINALE:" -ForegroundColor $(if ($finalPandoc -and $finalPDFtk) { "Green" } else { "Yellow" })
Write-Host "  Pandoc: $(if ($finalPandoc) { "✓ OK" } else { "✗ Mancante" })"
Write-Host "  PDFtk:  $(if ($finalPDFtk) { "✓ OK" } else { "✗ Mancante" })"

if ($finalPandoc -and $finalPDFtk) {
    Write-Log "Tutte le dipendenze sono installate correttamente!" "SUCCESS"
    Write-Host "`nPuoi ora eseguire: .\genera-pdf.ps1" -ForegroundColor Green
} else {
    Write-Log "Alcune dipendenze mancano - verifica gli errori sopra" "WARN"
    Write-Host "`nEsegui nuovamente lo script o installa manualmente le dipendenze mancanti" -ForegroundColor Yellow
}

Write-Host "`nPer verificare l'installazione: .\verifica-sistema.ps1" -ForegroundColor Cyan
