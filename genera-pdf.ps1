# Script PowerShell per generare PDF di tutti gli esercizi
# Utilizza Pandoc con XeLaTeX per supportare LaTeX e formule matematiche

param(
    [switch]$Force,  # Forza la rigenerazione anche se il PDF esiste gia
    [switch]$Verbose # Output dettagliato
)

Write-Host "Generatore PDF Esercizi Calcolatori" -ForegroundColor Cyan
Write-Host "=======================================" -ForegroundColor Cyan

# Verifica che Pandoc sia installato
try {
    $pandocVersion = pandoc --version | Select-Object -First 1
    Write-Host "Pandoc trovato: $pandocVersion" -ForegroundColor Green
} catch {
    Write-Error "Pandoc non trovato! Installa Pandoc prima di eseguire questo script."
    exit 1
}

# Crea la cartella artifacts se non esiste
$artifactsDir = "artifacts"
if (-not (Test-Path $artifactsDir)) {
    New-Item -ItemType Directory -Path $artifactsDir | Out-Null
    Write-Host "Creata cartella: $artifactsDir" -ForegroundColor Green
}

# Trova tutte le cartelle categoria
$categorieDir = Get-ChildItem -Directory -Filter "categoria-*" | Sort-Object Name

if ($categorieDir.Count -eq 0) {
    Write-Warning "Nessuna cartella categoria trovata!"
    exit 0
}

Write-Host "Trovate $($categorieDir.Count) categorie:" -ForegroundColor Yellow
$categorieDir | ForEach-Object { Write-Host "   - $($_.Name)" -ForegroundColor Gray }
Write-Host ""

$totalProcessed = 0
$totalSkipped = 0
$totalErrors = 0

foreach ($categoria in $categorieDir) {
    Write-Host "Processando categoria: $($categoria.Name)" -ForegroundColor Blue
    
    # Trova tutte le cartelle esercizio nella categoria
    $eserciziDir = Get-ChildItem -Path $categoria.FullName -Directory -Filter "esercizio-*" | Sort-Object Name
    
    if ($eserciziDir.Count -eq 0) {
        Write-Host "   Nessun esercizio trovato in $($categoria.Name)" -ForegroundColor Yellow
        continue
    }
    
    foreach ($esercizio in $eserciziDir) {
        $esercizioPath = $esercizio.FullName
        $esercizioName = $esercizio.Name
        
        # Cerca il file markdown principale
        $markdownFile = Get-ChildItem -Path $esercizioPath -Filter "*.md" | Select-Object -First 1
        
        if (-not $markdownFile) {
            Write-Host "   Nessun file .md trovato in $esercizioName" -ForegroundColor Red
            $totalErrors++
            continue
        }
        
        $outputFile = Join-Path $esercizioPath ($markdownFile.BaseName + ".pdf")
        $artifactFile = Join-Path $artifactsDir ("$($categoria.Name)_$($esercizioName).pdf")
        
        # Verifica se il PDF esiste gia nella cartella artifacts e se Force non e specificato
        if ((Test-Path $artifactFile) -and (-not $Force)) {
            if ($Verbose) {
                Write-Host "   PDF gia esistente per $esercizioName (usa -Force per sovrascrivere)" -ForegroundColor Gray
            }
            $totalSkipped++
            continue
        }
        
        Write-Host "   Generando PDF per: $esercizioName" -ForegroundColor Green
        
        try {
            # Comando Pandoc con XeLaTeX per supporto LaTeX completo
            # Cambio nella directory dell'esercizio per risolvere i percorsi relativi delle immagini
            $currentDir = Get-Location
            Set-Location $esercizioPath
            
            $pandocArgs = @(
                $markdownFile.Name
                "-o", ($markdownFile.BaseName + ".pdf")
                "--pdf-engine=xelatex"
                "--standalone"
                "--mathml"
                "--from=markdown"
                "--to=pdf"
            )
            
            if ($Verbose) {
                Write-Host "   Comando: pandoc $($pandocArgs -join ' ') (dalla directory $esercizioPath)" -ForegroundColor Gray
            }
            
            $process = Start-Process -FilePath "pandoc" -ArgumentList $pandocArgs -NoNewWindow -Wait -PassThru -RedirectStandardError "pandoc_error.tmp"
            
            # Torna alla directory originale
            Set-Location $currentDir
            
            # Gestione del file di errore
            $errorMsg = ""
            $hasErrors = $false
            if (Test-Path (Join-Path $esercizioPath "pandoc_error.tmp")) {
                $errorContent = Get-Content (Join-Path $esercizioPath "pandoc_error.tmp") -Raw -ErrorAction SilentlyContinue
                if ($errorContent -and $errorContent.Trim() -ne "") {
                    $errorMsg = $errorContent
                    # Controlla se sono errori gravi o solo warning
                    $hasErrors = $errorContent -match "Error|Fatal|failed" -and -not ($errorContent -match "Missing character.*font.*warning" -or $errorContent -match "WARNING")
                }
                # Rimuovi sempre il file temporaneo di errore
                Remove-Item (Join-Path $esercizioPath "pandoc_error.tmp") -ErrorAction SilentlyContinue
            }
            
            if ($process.ExitCode -eq 0 -and -not $hasErrors) {
                # Copia il PDF nella cartella artifacts con nome categoria_esercizio
                Copy-Item $outputFile $artifactFile -Force
                Write-Host "   PDF generato: $($artifactFile)" -ForegroundColor Green
                if ($Verbose) {
                    Write-Host "      File locale: $($outputFile)" -ForegroundColor Gray
                }
                if ($Verbose -and $errorMsg -and $errorMsg.Trim() -ne "") {
                    Write-Host "      Note/Warning: $($errorMsg.Trim())" -ForegroundColor Yellow
                }
                $totalProcessed++
            } else {
                Write-Host "   Errore nella generazione PDF per $esercizioName" -ForegroundColor Red
                if ($Verbose -and $errorMsg) {
                    Write-Host "      Dettagli: $errorMsg" -ForegroundColor Red
                }
                $totalErrors++
            }
        } catch {
            # Assicurati di tornare alla directory originale anche in caso di eccezione
            Set-Location $currentDir
            Write-Host "   Eccezione durante la generazione per $esercizioName : $($_.Exception.Message)" -ForegroundColor Red
            $totalErrors++
        }
    }
    
    Write-Host ""
}

# Riepilogo finale
Write-Host "RIEPILOGO GENERAZIONE PDF" -ForegroundColor Cyan
Write-Host "============================" -ForegroundColor Cyan
Write-Host "PDF generati: $totalProcessed" -ForegroundColor Green
Write-Host "PDF saltati: $totalSkipped" -ForegroundColor Yellow
Write-Host "Errori: $totalErrors" -ForegroundColor Red
if ($totalProcessed -gt 0) {
    Write-Host "Cartella output: .\artifacts\" -ForegroundColor Cyan
}
Write-Host ""

if ($totalProcessed -gt 0) {
    Write-Host "Generazione PDF completata con successo!" -ForegroundColor Green
} elseif ($totalSkipped -gt 0 -and $totalErrors -eq 0) {
    Write-Host "Tutti i PDF sono gia aggiornati. Usa -Force per rigenerare." -ForegroundColor Blue
} else {
    Write-Host "Controlla gli errori sopra riportati." -ForegroundColor Yellow
}

# Esempio di utilizzo
Write-Host ""
Write-Host "ESEMPI DI UTILIZZO:" -ForegroundColor Cyan
Write-Host "   .\genera-pdf.ps1                 # Genera solo i PDF mancanti"
Write-Host "   .\genera-pdf.ps1 -Force          # Rigenera tutti i PDF"
Write-Host "   .\genera-pdf.ps1 -Verbose        # Output dettagliato"
Write-Host "   .\genera-pdf.ps1 -Force -Verbose # Rigenera tutto con dettagli"