# Script PowerShell per generare PDF di tutti gli esercizi
# Utilizza Pandoc con XeLaTeX per supportare LaTeX e formule matematiche

param(
    [switch]$Force,  # Forza la rigenerazione anche se il PDF esiste gia
    [switch]$Verbose # Output dettagliato
)

# Configurazione logging - Crea la cartella logs se non esiste
$logsDir = "logs"
if (-not (Test-Path $logsDir)) {
    New-Item -ItemType Directory -Path $logsDir | Out-Null
}

# Crea il file di log con timestamp e percorso assoluto
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$absoluteLogsDir = Join-Path (Get-Location) $logsDir
$logFile = Join-Path $absoluteLogsDir "genera-pdf_$timestamp.log"

# Funzione per scrivere sia a console che a log
function Write-Log {
    param(
        [string]$Message,
        [string]$Color = "White",
        [switch]$NoConsole
    )
    
    $timestampMsg = "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $Message"
    
    if (-not $NoConsole) {
        if ($Color -ne "White") {
            Write-Host $Message -ForegroundColor $Color
        } else {
            Write-Host $Message
        }
    }
    
    Add-Content -Path $logFile -Value $timestampMsg -Encoding UTF8
}

Write-Log "Generatore PDF Esercizi Calcolatori" "Cyan"
Write-Log "=======================================" "Cyan"
Write-Log "Avvio generazione PDF - Script con logging completo" "Cyan"
Write-Log "File di log: $logFile" "Gray"

# Verifica che Pandoc sia installato
try {
    $pandocVersion = pandoc --version | Select-Object -First 1
    Write-Log "Pandoc trovato: $pandocVersion" "Green"
} catch {
    Write-Log "ERRORE: Pandoc non trovato! Installazione richiesta." "Red"
    Write-Log "" "White"
    Write-Log "SOLUZIONI:" "Yellow"
    Write-Log "1. Setup automatico: .\tools\setup-dipendenze.ps1" "Green"
    Write-Log "2. Verifica sistema: .\tools\verifica-sistema.ps1" "Green"
    Write-Log "3. Download manuale: https://pandoc.org/" "Gray"
    exit 1
}

# Crea la cartella artifacts se non esiste
$artifactsDir = "artifacts"
if (-not (Test-Path $artifactsDir)) {
    New-Item -ItemType Directory -Path $artifactsDir | Out-Null
    Write-Log "Creata cartella: $artifactsDir" "Green"
}
# Trova tutte le cartelle categoria
$categorieDir = Get-ChildItem -Directory -Filter "categoria-*" | Sort-Object Name

if ($categorieDir.Count -eq 0) {
    Write-Log "Nessuna cartella categoria trovata!" "Yellow"
    Write-Warning "Nessuna cartella categoria trovata!"
    exit 0
}

Write-Log "Trovate $($categorieDir.Count) categorie:" "Yellow"
$categorieDir | ForEach-Object { Write-Log "   - $($_.Name)" "Gray" }
Write-Log ""

$totalProcessed = 0
$totalSkipped = 0
$totalErrors = 0

foreach ($categoria in $categorieDir) {
    Write-Log "Processando categoria: $($categoria.Name)" "Blue"
    
    # Trova tutte le cartelle esercizio nella categoria
    $eserciziDir = Get-ChildItem -Path $categoria.FullName -Directory -Filter "esercizio-*" | Sort-Object Name
    
    if ($eserciziDir.Count -eq 0) {
        Write-Log "   Nessun esercizio trovato in $($categoria.Name)" "Yellow"
        continue
    }
    
    foreach ($esercizio in $eserciziDir) {
        $esercizioPath = $esercizio.FullName
        $esercizioName = $esercizio.Name
        
        # Cerca il file markdown principale
        $markdownFile = Get-ChildItem -Path $esercizioPath -Filter "*.md" | Select-Object -First 1
        
        if (-not $markdownFile) {
            Write-Log "   Nessun file .md trovato in $esercizioName" "Red"
            $totalErrors++
            continue
        }
        
        $artifactFile = Join-Path $artifactsDir ("$($categoria.Name)_$($esercizioName).pdf")
        
        # Verifica se il PDF esiste gia nella cartella artifacts e se Force non e specificato
        if ((Test-Path $artifactFile) -and (-not $Force)) {
            if ($Verbose) {
                Write-Log "   PDF gia esistente per $esercizioName (usa -Force per sovrascrivere)" "Gray"
            }
            $totalSkipped++
            continue
        }
        
        Write-Log "   Generando PDF per: $esercizioName" "Green"
        
        try {
            # Comando Pandoc con XeLaTeX per supporto LaTeX completo
            # Eseguiamo Pandoc dalla directory dell'esercizio per accesso alle immagini
            $currentDir = Get-Location
            $esercizioDir = $markdownFile.DirectoryName
            $absoluteArtifactFile = Join-Path $currentDir $artifactFile
            $markdownFileName = $markdownFile.Name
            
            # Cambia nella directory dell'esercizio per accedere alle immagini
            Set-Location $esercizioDir
            
            $pandocArgs = @(
                $markdownFileName  # Nome relativo del file markdown
                "-o", $absoluteArtifactFile  # Percorso assoluto per il PDF di output
                "--pdf-engine=xelatex"
                "--standalone"
                "--mathml"
                "--from=markdown"
                "--to=pdf"
                "-V", "pagestyle=empty"  # Rimuove header e footer inclusi i numeri di pagina
                "-V", "geometry:margin=2cm"  # Margini standardizzati
                "--dpi=300"  # Alta risoluzione per le immagini
            )
            
            if ($Verbose) {
                Write-Log "   Comando: pandoc $($pandocArgs -join ' ')" "Gray"
            }
            
            # Crea un file temporaneo per gli errori nella directory logs (percorso assoluto)
            $errorFile = Join-Path $absoluteLogsDir "pandoc_error_${categoria.Name}_${esercizioName}_$timestamp.tmp"
            $process = Start-Process -FilePath "pandoc" -ArgumentList $pandocArgs -NoNewWindow -Wait -PassThru -RedirectStandardError $errorFile
            
            # Gestione del file di errore
            $errorMsg = ""
            $hasErrors = $false
            $keepErrorFile = $false
            
            if (Test-Path $errorFile) {
                $errorContent = Get-Content $errorFile -Raw -ErrorAction SilentlyContinue
                if ($errorContent -and $errorContent.Trim() -ne "") {
                    $errorMsg = $errorContent
                    # Controlla se sono errori gravi o solo warning
                    $hasErrors = $errorContent -match "Error|Fatal|failed" -and -not ($errorContent -match "Missing character.*font.*warning" -or $errorContent -match "WARNING")
                    
                    # Mantieni il file se contiene informazioni rilevanti (errori o warning significativi)
                    $keepErrorFile = $hasErrors -or ($errorContent -match "WARNING" -and $errorContent.Length -gt 50)
                    
                    if ($keepErrorFile) {
                        Write-Log "   File di errore salvato: $errorFile" "Yellow" -NoConsole
                    }
                }
                
                # Rimuovi il file temporaneo se non contiene informazioni rilevanti
                if (-not $keepErrorFile) {
                    Remove-Item $errorFile -ErrorAction SilentlyContinue
                }
            }
            
            if ($process.ExitCode -eq 0 -and -not $hasErrors) {
                Write-Log "   PDF generato: $($artifactFile)" "Green"
                if ($Verbose -and $errorMsg -and $errorMsg.Trim() -ne "") {
                    Write-Log "      Note/Warning: $($errorMsg.Trim())" "Yellow"
                }
                $totalProcessed++
            } else {
                Write-Log "   Errore nella generazione PDF per $esercizioName" "Red"
                if ($Verbose -and $errorMsg) {
                    Write-Log "      Dettagli: $errorMsg" "Red"
                }
                $totalErrors++
            }
            
            # Torna sempre alla directory originale dopo l'esecuzione di Pandoc
            Set-Location $currentDir
        } catch {
            # Assicurati di tornare alla directory originale anche in caso di eccezione
            Set-Location $currentDir
            Write-Log "   Eccezione durante la generazione per $esercizioName : $($_.Exception.Message)" "Red"
            $totalErrors++
        }
    }
    
    Write-Log ""
}

# Riepilogo finale
Write-Log "RIEPILOGO GENERAZIONE PDF" "Cyan"
Write-Log "============================" "Cyan"
Write-Log "PDF generati: $totalProcessed" "Green"
Write-Log "PDF saltati: $totalSkipped" "Yellow"
Write-Log "Errori: $totalErrors" "Red"
if ($totalProcessed -gt 0) {
    Write-Log "Cartella output: .\artifacts\" "Cyan"
}
Write-Log ""

# Generazione dispensa unificata
if ($totalProcessed -gt 0 -or $Force) {
    Write-Log "GENERAZIONE DISPENSA UNIFICATA" "Cyan"
    Write-Log "===============================" "Cyan"
    
    try {
        # Verifica che pdftk sia installato
        $pdftkAvailable = $false
        try {
            $pdftkVersion = pdftk --version 2>$null
            $pdftkAvailable = $true
            Write-Log "PDFtk trovato: $(($pdftkVersion -split "`n")[0])" "Green"
        } catch {
            Write-Log "PDFtk non trovato! Installare PDFtk per generare la dispensa unificata." "Yellow"
            Write-Log "" "White"
            Write-Log "SOLUZIONI:" "Yellow"
            Write-Log "1. Setup automatico: .\tools\setup-dipendenze.ps1" "Green"
            Write-Log "2. Verifica sistema: .\tools\verifica-sistema.ps1" "Green"
            Write-Log "3. Download manuale: https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/" "Gray"
        }
        
        if ($pdftkAvailable) {
            $dispensaPdf = Join-Path $artifactsDir "dispensa-completa-esercizi.pdf"
            $dispensaTempPdf = Join-Path $artifactsDir "dispensa-temp-merge.pdf"
            
            Write-Log "Unendo tutti i PDF in una dispensa unica..." "Yellow"
            
            # Raccoglie tutti i PDF degli esercizi ordinati per categoria e nome
            $allPdfs = @()
            foreach ($categoria in $categorieDir) {
                $categoryPdfs = Get-ChildItem -Path $artifactsDir -Filter "$($categoria.Name)_*.pdf" | Sort-Object Name
                $allPdfs += $categoryPdfs
            }
            
            if ($allPdfs.Count -gt 0) {
                # Crea l'elenco dei file PDF per pdftk
                $pdfList = ($allPdfs | ForEach-Object { "`"$($_.FullName)`"" }) -join " "
                
                # Primo passaggio: unisci i PDF in un file temporaneo
                $pdftkMergeCommand = "pdftk $pdfList cat output `"$dispensaTempPdf`""
                
                if ($Verbose) {
                    Write-Log "   Comando pdftk (merge): $pdftkMergeCommand" "Gray"
                    Write-Log "   PDF da unire: $($allPdfs.Count)" "Gray"
                    foreach ($pdf in $allPdfs) {
                        Write-Log "      - $($pdf.Name)" "Gray"
                    }
                }
                
                # Esegui pdftk per il merge
                $pdftkMergeProcess = Start-Process -FilePath "cmd" -ArgumentList "/c", $pdftkMergeCommand -NoNewWindow -Wait -PassThru
                
                if ($pdftkMergeProcess.ExitCode -eq 0 -and (Test-Path $dispensaTempPdf)) {
                    Write-Log "   Merge completato, processando numerazione pagine..." "Yellow"
                    
                    # Secondo passaggio: aggiorna i metadati, crea segnalibri e normalizza
                    # Crea un file di metadati temporaneo
                    $metadataFile = Join-Path $absoluteLogsDir "dispensa_metadata_$timestamp.txt"
                    $metadataContent = @"
InfoBegin
InfoKey: Title
InfoValue: Dispensa Completa - Esercizi di Calcolatori
InfoBegin
InfoKey: Author
InfoValue: Preparazione Esame Calcolatori
InfoBegin
InfoKey: Subject
InfoValue: Raccolta completa di esercizi per l'esame di Calcolatori
InfoBegin
InfoKey: Creator
InfoValue: genera-pdf.ps1 script
InfoBegin
InfoKey: Producer
InfoValue: PDFtk + Pandoc
InfoBegin
InfoKey: CreationDate
InfoValue: D:$(Get-Date -Format 'yyyyMMddHHmmss')+01'00'
"@
                    Set-Content -Path $metadataFile -Value $metadataContent -Encoding UTF8
                    
                    # Crea file di segnalibri per una migliore navigazione
                    $bookmarksFile = Join-Path $absoluteLogsDir "dispensa_bookmarks_$timestamp.txt"
                    $bookmarkContent = @()
                    $currentPage = 1
                    
                    foreach ($categoria in $categorieDir) {
                        $categoryPdfs = Get-ChildItem -Path $artifactsDir -Filter "$($categoria.Name)_*.pdf" | Sort-Object Name
                        if ($categoryPdfs.Count -gt 0) {
                            $categoriaTitle = $categoria.Name -replace "categoria-(\d+)-", "Categoria `$1 - " -replace "-", " "
                            $categoriaTitle = (Get-Culture).TextInfo.ToTitleCase($categoriaTitle.ToLower())
                            
                            $bookmarkContent += "BookmarkBegin"
                            $bookmarkContent += "BookmarkTitle: $categoriaTitle"
                            $bookmarkContent += "BookmarkLevel: 1"
                            $bookmarkContent += "BookmarkPageNumber: $currentPage"
                            
                            foreach ($pdf in $categoryPdfs) {
                                $esercizioName = $pdf.BaseName -replace "^$($categoria.Name)_", "" -replace "esercizio-(\d+)-", "Esercizio `$1 - " -replace "-", " "
                                $esercizioTitle = (Get-Culture).TextInfo.ToTitleCase($esercizioName.ToLower())
                                
                                $bookmarkContent += "BookmarkBegin"
                                $bookmarkContent += "BookmarkTitle: $esercizioTitle"
                                $bookmarkContent += "BookmarkLevel: 2"
                                $bookmarkContent += "BookmarkPageNumber: $currentPage"
                                
                                # Stima approssimativa delle pagine (basata sulla dimensione del file)
                                $estimatedPages = [math]::Max(1, [math]::Round($pdf.Length / 60KB))
                                $currentPage += $estimatedPages
                            }
                        }
                    }
                    
                    Set-Content -Path $bookmarksFile -Value ($bookmarkContent -join "`n") -Encoding UTF8
                    
                    # Comando per aggiornare metadati senza compressione
                    $pdftkUpdateCommand = "pdftk `"$dispensaTempPdf`" update_info `"$metadataFile`" output `"$dispensaPdf`""
                    
                    if ($Verbose) {
                        Write-Log "   Comando pdftk (update): $pdftkUpdateCommand" "Gray"
                        Write-Log "   Segnalibri creati: $($bookmarkContent | Where-Object { $_ -match "BookmarkTitle" } | Measure-Object).Count" "Gray"
                    }
                    
                    $pdftkUpdateProcess = Start-Process -FilePath "cmd" -ArgumentList "/c", $pdftkUpdateCommand -NoNewWindow -Wait -PassThru
                    
                    if ($pdftkUpdateProcess.ExitCode -eq 0 -and (Test-Path $dispensaPdf)) {
                        Write-Log "   Dispensa unificata generata: dispensa-completa-esercizi.pdf" "Green"
                        Write-Log "   Dimensione: $([math]::Round((Get-Item $dispensaPdf).Length / 1KB, 1)) KB" "Gray"
                        Write-Log "   PDF uniti: $($allPdfs.Count) esercizi" "Gray"
                        Write-Log "   Metadati aggiornati e PDF compresso" "Gray"
                        
                        # Pulisci file temporanei
                        if (Test-Path $dispensaTempPdf) {
                            Remove-Item $dispensaTempPdf -ErrorAction SilentlyContinue
                        }
                        if (Test-Path $metadataFile) {
                            Remove-Item $metadataFile -ErrorAction SilentlyContinue
                        }
                        if (Test-Path $bookmarksFile) {
                            Remove-Item $bookmarksFile -ErrorAction SilentlyContinue
                        }
                    } else {
                        Write-Log "   Errore durante l'aggiornamento metadati" "Red"
                        Write-Log "   Exit Code: $($pdftkUpdateProcess.ExitCode)" "Red"
                        
                        # Se l'aggiornamento fallisce, usa il file temporaneo come risultato finale
                        if (Test-Path $dispensaTempPdf) {
                            Move-Item $dispensaTempPdf $dispensaPdf -Force
                            Write-Log "   Utilizzato PDF senza aggiornamento metadati" "Yellow"
                        }
                    }
                } else {
                    Write-Log "   Errore durante l'unione dei PDF con pdftk" "Red"
                    Write-Log "   Exit Code: $($pdftkMergeProcess.ExitCode)" "Red"
                }
            } else {
                Write-Log "   Nessun PDF degli esercizi trovato per l'unione" "Yellow"
            }
        }
        
    } catch {
        Write-Log "   Eccezione durante la generazione della dispensa: $($_.Exception.Message)" "Red"
    }
    
    Write-Log ""
}

if ($totalProcessed -gt 0) {
    Write-Log "Generazione PDF completata con successo!" "Green"
} elseif ($totalSkipped -gt 0 -and $totalErrors -eq 0) {
    Write-Log "Tutti i PDF sono gia aggiornati. Usa -Force per rigenerare." "Blue"
} else {
    Write-Log "Controlla gli errori sopra riportati." "Yellow"
}

# Esempio di utilizzo
Write-Log ""
Write-Log "ESEMPI DI UTILIZZO:" "Cyan"
Write-Log "   .\genera-pdf.ps1                 # Genera solo i PDF mancanti"
Write-Log "   .\genera-pdf.ps1 -Force          # Rigenera tutti i PDF"
Write-Log "   .\genera-pdf.ps1 -Verbose        # Output dettagliato"
Write-Log "   .\genera-pdf.ps1 -Force -Verbose # Rigenera tutto con dettagli"