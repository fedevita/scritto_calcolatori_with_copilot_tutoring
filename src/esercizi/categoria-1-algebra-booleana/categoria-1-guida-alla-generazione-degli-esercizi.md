# Categoria 1 - Guida alla Generazione degli Esercizi

## 📋 Protocollo per GitHub Copilot

Questa guida definisce il **protocollo standardizzato** per la generazione e verifica degli esercizi di algebra booleana nella categoria 1.

---

## 🎯 Obiettivo del Protocollo

- **Consistenza**: Tutti gli esercizi devono seguire la stessa struttura
- **Verificabilità**: Ogni espressione deve essere validata con tabelle di verità
- **Qualità**: Evitare errori matematici e uguaglianze false
- **Didattica**: Fornire esempi chiari e progressivi di complessità

---

## 📐 Struttura Standard dell'Esercizio

### Template Obbligatorio

```markdown
# Esercizio

Dimostrare, mediante passaggi algebrici, che:
$$
[ESPRESSIONE_SINISTRA] = [ESPRESSIONE_DESTRA]
$$
Implementare inoltre la tabella di verità della funzione booleana tramite un multiplexer.

## Check uguaglianza membri
Aggiungo questo check perché copilot ha difficoltà a generare esercizi corretti.

### Tabella di verità di $ [ESPRESSIONE_SINISTRA] $

[TABELLA_COMPLETA_CON_PASSAGGI_INTERMEDI]

### Tabella di verità di $ [ESPRESSIONE_DESTRA] $

[TABELLA_SEMPLIFICATA]

### Confronto risultati

[TABELLA_CONFRONTO_RIGA_PER_RIGA]

**CONCLUSIONE**: L'uguaglianza è **[VERA/FALSA]** [✅/❌]
- [DESCRIZIONE_RISULTATO]
- [MINTERMINI_SE_APPLICABILE]
```

---

## 🔧 Regole di Notazione

### Operatori Matematici
- **AND**: `\cdot` (sempre esplicito)
- **OR**: `+` 
- **NOT**: `\overline{X}`
- **Parentesi**: Usare sempre per chiarezza

### Esempi Corretti
- ✅ `A \cdot B + C`
- ✅ `(A + B) \cdot \overline{C}`
- ✅ `\overline{A} \cdot \overline{B} \cdot C`

### Struttura Standard degli Esercizi

**⚠️ IMPORTANTE**: Tutti gli esercizi devono seguire esattamente la stessa struttura:

1. **Titolo**: Sempre e solo `# Esercizio`
2. **Traccia**: Formula matematica + frase sul multiplexer
3. **Check uguaglianza**: Sezione obbligatoria con nota su Copilot
4. **Tabelle di verità**: Una per l'espressione sinistra, una per la destra
5. **Confronto risultati**: Tabella con colonna "Uguali?"
6. **Conclusione**: Formato standard con ✅/✗
7. **Implementazione Multiplexer**: Sezione da completare

**NO titoli personalizzati, NO metadata aggiuntiva, NO sezioni extra**

---

## 📊 Protocollo di Verifica

### Processo Standard:

1. **Espressione di Sinistra → Tabella di Verità**
   - Calcolare tutti i passaggi intermedi
   - Identificare mintermini attivi (righe con risultato = 1)

2. **Mintermini → Mappa di Karnaugh**
   - Inserire 1 nelle celle corrispondenti ai mintermini
   - Identificare raggruppamenti di potenze di 2 (1, 2, 4, 8...)
   - Ogni raggruppamento elimina una variabile

3. **K-map → Espressione Minimizzata**
   - Tradurre ogni raggruppamento in termine prodotto
   - Sommare tutti i termini per ottenere espressione di destra

4. **Verifica Finale**
   - Calcolare tabella di verità dell'espressione di destra
   - Confrontare con quella di sinistra riga per riga
   - **OBBLIGATORIO**: Devono essere identiche

### Regole K-map:
- **Raggruppamenti validi**: 1, 2, 4, 8, 16 celle
- **Forma**: Rettangolari o quadrati
- **Adiacenza**: Include wrapping (bordi opposti si toccano)
- **Obiettivo**: Coprire tutti gli 1 con minimo numero di raggruppamenti

---

## ⚠️ Controlli di Qualità

### Errori Comuni da Evitare
1. **Matematici**:
   - Calcoli errati nelle tabelle
   - Negazioni sbagliate: `\overline{A \cdot B} ≠ \overline{A} \cdot \overline{B}`
   - Distributive errate

2. **Formativi**:
   - Uguaglianze false presentate come vere
   - Tabelle incomplete o imprecise
   - Salti logici nei passaggi

3. **Strutturali**:
   - Mancanza sezione "Check uguaglianza"
   - Notazione inconsistente
   - Assenza tabella di confronto

### Validazione Finale
- [ ] Espressione di sinistra calcolata correttamente
- [ ] Espressione di destra minimizzata appropriatamente  
- [ ] Tabelle di verità complete e accurate
- [ ] Confronto esplicito riga per riga
- [ ] Conclusione matematicamente corretta
- [ ] Notazione uniforme con `\cdot`
- [ ] Struttura conforme al template

---

## 🎓 Esempi di Riferimento

### Esercizio Semplice (2 variabili)
```
A \cdot \overline{B} + \overline{A} \cdot B + A \cdot B = A + B
```

### Esercizio Intermedio (3 variabili)  
```
(A + \overline{B} \cdot C) \cdot (\overline{A} + B \cdot C) + A \cdot \overline{B} \cdot \overline{C} = \overline{A} \cdot \overline{B} \cdot C + A \cdot \overline{B} \cdot \overline{C} + A \cdot B \cdot C
```

### Esercizio Complesso (3+ variabili)
```
(A + B \cdot C) \cdot (\overline{A} + \overline{B}) \cdot (A + \overline{C}) + A \cdot B \cdot \overline{C} + \overline{A} \cdot \overline{B} \cdot C = A \cdot \overline{C} + \overline{B} \cdot C
```

---

## 📝 Checklist Pre-Pubblicazione

Prima di finalizzare un esercizio, verificare:

- [ ] **Struttura**: Template seguito completamente
- [ ] **Notazione**: `\cdot` usato consistentemente  
- [ ] **Matematica**: Tutti i calcoli verificati manualmente
- [ ] **Tabelle**: Complete con passaggi intermedi
- [ ] **Confronto**: Riga per riga esplicito
- [ ] **Conclusione**: Corretta e motivata
- [ ] **Complessità**: Appropriata per il numero di esercizio
- [ ] **Didattica**: Chiara e progressiva

---

## 🚀 Workflow di Generazione

### Protocollo in 5 Passi:

1. **Generare espressione di sinistra**
   - Creare espressione complessa interessante
   - Rispettare complessità progressiva per numero esercizio

2. **Minimizzare con Mappa di Karnaugh**
   - Calcolare tabella di verità dell'espressione di sinistra
   - Costruire mappa K appropriata (2×2, 2×4, 4×4)
   - Identificare raggruppamenti ottimali
   - Ottenere espressione minimizzata

3. **Ricavare espressione di destra**
   - L'espressione di destra = risultato minimizzazione K-map
   - Verificare che sia effettivamente più semplice

4. **Verificare congruenza**
   - Calcolare tabelle di verità separate per entrambe le espressioni
   - Confrontare riga per riga
   - Assicurarsi che siano identiche

5. **Produrre esercizio finale**
   - Applicare template standardizzato
   - Includere tutte le tabelle di verifica
   - Aggiungere conclusione con validazione

### Esempio Pratico:

**Passo 1 - Espressione di sinistra:**
```
(A + B \cdot C) \cdot (\overline{A} + \overline{B}) \cdot (A + \overline{C}) + A \cdot B \cdot \overline{C} + \overline{A} \cdot \overline{B} \cdot C
```

**Passo 2 - K-map:**
```
    BC  00  01  11  10
A   
0       0   1   0   0
1       1   1   0   1
```

**Passo 3 - Minimizzazione:**
```
A \cdot \overline{C} + \overline{B} \cdot C
```

**Passo 4 - Verifica:** Tabelle di verità identiche ✅

**Passo 5 - Esercizio completo** con template standard

---

**🎯 Obiettivo**: Esercizi matematicamente corretti, didatticamente utili e strutturalmente uniformi per un apprendimento efficace dell'algebra booleana.