# Generazione PDF

## 🎯 Panoramica

Il sistema di generazione PDF converte automaticamente tutti gli esercizi Markdown in PDF di alta qualità con supporto LaTeX per formule matematiche.

## 📝 Utilizzo Base

### Generazione Standard
```powershell
# Genera solo i PDF mancanti
.\genera-pdf.ps1
```

### Rigenerazione Completa
```powershell
# Rigenera tutti i PDF anche se esistenti
.\genera-pdf.ps1 -Force
```

### Output Dettagliato
```powershell
# Mostra informazioni dettagliate durante la generazione
.\genera-pdf.ps1 -Verbose
```

### Combinazioni
```powershell
# Rigenera tutto con output dettagliato
.\genera-pdf.ps1 -Force -Verbose
```

## 📂 Output Generato

### PDF Individuali
- **Posizione**: `output\pdf\`
- **Formato**: `categoria-X-nome_esercizio-Y-nome.pdf`
- **Esempio**: `categoria-1-algebra-booleana_esercizio-1-dimostrazione-algebrica.pdf`

### Dispensa Unificata
- **Nome**: `dispensa-completa-esercizi.pdf`
- **Contenuto**: Tutti i PDF uniti in ordine logico
- **Metadati**: Titolo, autore, data di creazione
- **Segnalibri**: Navigazione per categoria ed esercizio

## 🔧 Caratteristiche Tecniche

### Engine PDF
- **Motore**: XeLaTeX via Pandoc
- **Font**: Supporto Unicode completo
- **Formule**: Rendering LaTeX nativo
- **Immagini**: Alta risoluzione (300 DPI)

### Ottimizzazioni
- **Margini**: 2cm standardizzati
- **Pagine**: Senza header/footer
- **Compressione**: Ottimizzata per dimensioni
- **Compatibilità**: Standard PDF/A

## 📊 Monitoraggio

### Log Dettagliati
- **Posizione**: `output\logs\`
- **Formato**: `genera-pdf_YYYY-MM-DD_HH-mm-ss.log`
- **Contenuto**: Ogni operazione con timestamp

### Statistiche
Il sistema mostra un riepilogo completo:
```
RIEPILOGO GENERAZIONE PDF
============================
PDF generati: 8
PDF saltati: 0
Errori: 0
Cartella output: .\output\pdf\
```

## 🐛 Gestione Errori

### Errori Pandoc
- **File temporanei**: Salvati in `output\logs\` per debug
- **Warning**: Distingue tra errori gravi e avvertimenti
- **Recovery**: Continua con altri esercizi anche in caso di errore

### Validazione Input
- **Markdown**: Verifica esistenza file .md
- **Immagini**: Gestione percorsi relativi
- **Dipendenze**: Controllo Pandoc/PDFtk prima dell'esecuzione

## 📐 Personalizzazione

### Modifica Parametri Pandoc
Nel file `build\genera-pdf.ps1`, sezione `$pandocArgs`:

```powershell
$pandocArgs = @(
    $markdownFileName
    "-o", $absoluteArtifactFile
    "--pdf-engine=xelatex"
    "--standalone"
    "--mathml"
    "--from=markdown"
    "--to=pdf"
    "-V", "pagestyle=empty"
    "-V", "geometry:margin=2cm"  # Modifica margini
    "--dpi=300"                  # Modifica risoluzione
)
```

### Template Personalizzati
Per utilizzare template custom:
1. Aggiungi il template nella directory del progetto
2. Modifica il comando Pandoc: `--template=nome-template.tex`

## 🔄 Workflow Automatico

### Integrazione Development
```powershell
# Dopo aver modificato un esercizio
git add .
git commit -m "Aggiorna esercizio X"
.\genera-pdf.ps1 -Force  # Rigenera PDF
```

### Batch Processing
Il sistema processa automaticamente:
1. Tutte le categorie in ordine
2. Tutti gli esercizi per categoria
3. Generazione dispensa unificata
4. Pulizia file temporanei

## 📋 Checklist Pre-Generazione

- [ ] Verifica che Pandoc sia installato: `pandoc --version`
- [ ] Verifica che PDFtk sia installato: `pdftk --version`
- [ ] Controlla che i file .md esistano negli esercizi
- [ ] Verifica che le immagini siano nel percorso corretto
- [ ] Esegui da directory root del progetto