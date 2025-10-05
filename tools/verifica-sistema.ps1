#Requires -Version 5.1

<#
.SYNOPSIS
    Verifica stato dipendenze sistema - Scritto Calcolatori

.DESCRIPTION
    Script per verificare l'installazione e le versioni delle dipendenze necessarie
    per il sistema di generazione PDF degli esercizi.

.PARAMETER Detailed
    Mostra informazioni dettagliate su percorsi e configurazioni

.EXAMPLE
    .\verifica-sistema.ps1
    Verifica basic delle dipendenze

.EXAMPLE
    .\verifica-sistema.ps1 -Detailed
    Verifica dettagliata con percorsi e configurazioni
#>

param(
    [switch]$Detailed
)

# === CONFIGURAZIONE ===
$ErrorActionPreference = "Continue"

# === FUNZIONI UTILITY ===

function Write-StatusLine {
    param(
        [string]$Component,
        [bool]$IsInstalled,
        [string]$Version = "",
        [string]$Path = "",
        [string]$Notes = ""
    )
    
    $status = if ($IsInstalled) { "OK" } else { "X" }
    $color = if ($IsInstalled) { "Green" } else { "Red" }
    
    $line = "  [{0}] {1,-15}" -f $status, $Component
    
    if ($Version) {
        $line += " (v$Version)"
    }
    
    if ($Detailed -and $Path) {
        $line += "`n      Percorso: $Path"
    }
    
    if ($Notes) {
        $line += "`n      Note: $Notes"
    }
    
    Write-Host $line -ForegroundColor $color
}

function Test-CommandExists {
    param([string]$Command)
    try {
        $cmd = Get-Command $Command -ErrorAction SilentlyContinue
        if ($cmd) {
            return @{
                Exists = $true
                Path = $cmd.Source
                Version = ""
            }
        }
    }
    catch { }
    
    return @{
        Exists = $false
        Path = ""
        Version = ""
    }
}

function Get-PandocInfo {
    try {
        $cmd = Test-CommandExists "pandoc"
        if ($cmd.Exists) {
            $output = & pandoc --version 2>$null
            if ($output -match "pandoc\s+([\d\.]+)") {
                $cmd.Version = $matches[1]
            }
        }
        return $cmd
    }
    catch {
        return @{ Exists = $false; Path = ""; Version = "" }
    }
}

function Get-PDFtkInfo {
    try {
        $cmd = Test-CommandExists "pdftk"
        if ($cmd.Exists) {
            $output = & pdftk --version 2>$null
            if ($output -match "pdftk\s+([\d\.]+)") {
                $cmd.Version = $matches[1]
            } elseif ($output -match "pdftk") {
                $cmd.Version = "installato"
            }
        }
        return $cmd
    }
    catch {
        return @{ Exists = $false; Path = ""; Version = "" }
    }
}

function Get-PowerShellInfo {
    return @{
        Exists = $true
        Version = $PSVersionTable.PSVersion.ToString()
        Path = (Get-Process -Id $PID).Path
    }
}

function Test-LaTeXSupport {
    try {
        # Verifica se Pandoc può usare XeLaTeX
        $output = & pandoc --list-pdf-engines 2>$null
        return ($output -contains "xelatex")
    }
    catch {
        return $false
    }
}

function Get-ProjectFiles {
    $scriptDir = $PSScriptRoot
    $projectDir = Split-Path -Parent $scriptDir
    
    return @{
        GeneraPDF = Join-Path $projectDir "genera-pdf.ps1"
        SetupDipendenze = Join-Path $scriptDir "setup-dipendenze.ps1"  
        ArtifactsDir = Join-Path $projectDir "artifacts"
        LogsDir = Join-Path $projectDir "logs"
        README = Join-Path $projectDir "README.md"
    }
}

# === MAIN SCRIPT ===

Clear-Host
Write-Host @"

===========================================
  VERIFICA SISTEMA - SCRITTO CALCOLATORI
===========================================
Controllo dipendenze e configurazione per 
generazione PDF degli esercizi

"@ -ForegroundColor Cyan

# === INFORMAZIONI SISTEMA ===
Write-Host "SISTEMA OPERATIVO:" -ForegroundColor Yellow
Write-Host "  OS: $($env:OS)"
Write-Host "  Architettura: $($env:PROCESSOR_ARCHITECTURE)"
Write-Host "  PowerShell: $($PSVersionTable.PSVersion)"

if ($Detailed) {
    Write-Host "  Utente: $($env:USERNAME)"
    Write-Host "  Macchina: $($env:COMPUTERNAME)"
    $pathEntries = $env:PATH -split ';' | Where-Object { $_ -match 'pandoc|pdftk' }
    if ($pathEntries) {
        Write-Host "  PATH relevanti:"
        $pathEntries | ForEach-Object { Write-Host "    $_" }
    }
}

Write-Host ""

# === VERIFICA DIPENDENZE ===
Write-Host "DIPENDENZE PRINCIPALI:" -ForegroundColor Yellow

$pandocInfo = Get-PandocInfo
Write-StatusLine "Pandoc" $pandocInfo.Exists $pandocInfo.Version $pandocInfo.Path

$pdftkInfo = Get-PDFtkInfo  
Write-StatusLine "PDFtk" $pdftkInfo.Exists $pdftkInfo.Version $pdftkInfo.Path

$psInfo = Get-PowerShellInfo
Write-StatusLine "PowerShell" $psInfo.Exists $psInfo.Version $psInfo.Path

# === VERIFICA SUPPORTO LaTeX ===
Write-Host "`nSUPPORTO LaTeX:" -ForegroundColor Yellow

$latexSupport = Test-LaTeXSupport
Write-StatusLine "XeLaTeX Engine" $latexSupport "" "" $(if (!$latexSupport) { "Richiesto per formule matematiche" })

# === VERIFICA FILE PROGETTO ===
Write-Host "`nFILE PROGETTO:" -ForegroundColor Yellow

$projectFiles = Get-ProjectFiles

$files = @(
    @{ Name = "genera-pdf.ps1"; Path = $projectFiles.GeneraPDF },
    @{ Name = "setup-dipendenze.ps1"; Path = $projectFiles.SetupDipendenze },
    @{ Name = "README.md"; Path = $projectFiles.README }
)

foreach ($file in $files) {
    $exists = Test-Path $file.Path
    $existsBool = [bool]$exists
    Write-StatusLine $file.Name $existsBool "" $file.Path
}

# === VERIFICA DIRECTORY ===
Write-Host "`nDIRECTORY PROGETTO:" -ForegroundColor Yellow

$directories = @(
    @{ Name = "artifacts/"; Path = $projectFiles.ArtifactsDir },
    @{ Name = "logs/"; Path = $projectFiles.LogsDir }
)

foreach ($dir in $directories) {
    $exists = Test-Path $dir.Path
    $existsBool = [bool]$exists
    $notes = ""
    if ($exists) {
        $fileCount = (Get-ChildItem $dir.Path -File -ErrorAction SilentlyContinue).Count
        $notes = "$fileCount file(s)"
    }
    Write-StatusLine $dir.Name $existsBool "" $dir.Path $notes
}

# === RIEPILOGO E RACCOMANDAZIONI ===
Write-Host "`n" + "="*50 -ForegroundColor Cyan
Write-Host "RIEPILOGO:" -ForegroundColor Cyan

$allOk = $pandocInfo.Exists -and $pdftkInfo.Exists -and $latexSupport
$warnings = @()

if ($allOk) {
    Write-Host "[OK] Tutte le dipendenze sono installate correttamente!" -ForegroundColor Green
    Write-Host "[OK] Il sistema è pronto per generare PDF" -ForegroundColor Green
} else {
    Write-Host "[!] Alcune dipendenze mancano:" -ForegroundColor Yellow
    
    if (!$pandocInfo.Exists) {
        $warnings += "- Pandoc non installato"
    }
    if (!$pdftkInfo.Exists) {
        $warnings += "- PDFtk non installato"  
    }
    if (!$latexSupport) {
        $warnings += "- Supporto LaTeX (XeLaTeX) non disponibile"
    }
    
    foreach ($warning in $warnings) {
        Write-Host "  $warning" -ForegroundColor Red
    }
}

# === SUGGERIMENTI ===
Write-Host "`nSUGGERIMENTI:" -ForegroundColor Cyan

if (!$pandocInfo.Exists -or !$pdftkInfo.Exists) {
    Write-Host "Setup automatico:" -ForegroundColor White
    Write-Host "   .\tools\setup-dipendenze.ps1" -ForegroundColor Green
}

if ($allOk) {
    Write-Host "Genera i PDF degli esercizi:" -ForegroundColor White
    Write-Host "   .\genera-pdf.ps1" -ForegroundColor Green
    Write-Host "   .\genera-pdf.ps1 -Force -Verbose" -ForegroundColor Green
}

if ($Detailed -and (Test-Path $projectFiles.LogsDir)) {
    Write-Host "`nLog disponibili:" -ForegroundColor White
    Get-ChildItem $projectFiles.LogsDir -Filter "*.log" | Sort-Object LastWriteTime -Descending | Select-Object -First 3 | ForEach-Object {
        Write-Host "   $($_.Name) ($($_.LastWriteTime.ToString('dd/MM HH:mm')))" -ForegroundColor Gray
    }
}

Write-Host ""