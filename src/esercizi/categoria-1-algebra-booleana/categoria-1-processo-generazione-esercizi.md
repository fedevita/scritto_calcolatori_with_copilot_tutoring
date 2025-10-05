# Processo di Generazione Esercizi Algebra Booleana

## **Metodologia Standard**

Per garantire che gli esercizi di algebra booleana siano sempre corretti e verificabili, seguiamo questo processo sistematico:

### **Passo 1: Genera espressione semplice (secondo membro)**
- Scegli un'espressione booleana semplice e pulita
- Esempi efficaci:
  - 2 variabili: `A + B`, `A ⋅ B`, `A ⊕ B`
  - 3 variabili: `A + B ⋅ C`, `A ⋅ B + C`, `A ⋅ (B + C)`
  - 4 variabili: `A ⋅ B`, `A + B ⋅ C ⋅ D`

### **Passo 2: Complica usando teoremi algebra booleana**
Applica trasformazioni algebriche per espandere l'espressione:

#### **Tecniche di espansione:**
- **Distributiva**: `A + BC = (A + B)(A + C)`
- **Espansione per variabile mancante**: `A = A(B + B̄) = AB + AB̄`
- **Moltiplicazione per 1**: `A = A ⋅ 1 = A(C + C̄)`
- **Somma con 0**: `A = A + 0 = A + BC̄⋅⋅D` (termini impossibili)
- **Duplicazione di termini**: `A + A = A` → aggiungi termini ridondanti

#### **Strategie per complicare:**
1. **Espansione completa in mintermini**
2. **Aggiunta di termini assorbiti**
3. **Uso della forma distributiva inversa**
4. **Combinazione di più tecniche**

### **Passo 3: Scrivi l'uguaglianza completa**
```
(espressione complicata) = (espressione semplice)
```

### **Passo 4: Calcola le tabelle di verità**

#### **Per il primo membro (complicato):**
- Suddividi in termini elementari
- Calcola ogni termine per ogni riga
- Somma (OR) tutti i risultati

#### **Per il secondo membro (semplice):**
- Calcola direttamente l'espressione semplificata

### **Passo 5: Confronta e valida**
- Se tutte le righe corrispondono → **Esercizio valido** ✅
- Se ci sono discrepanze → **Torna al Passo 2** e correggi

## **Template Standard Esercizio**

```markdown
# Esercizio

[Descrizione del tipo di operazione]:
$$
[espressione_complicata] = [espressione_semplice]
$$
```

### **Varianti di descrizione:**
- "Semplificare la seguente funzione booleana utilizzando le leggi dell'algebra booleana:"
- "Dimostrare che la seguente uguaglianza è vera utilizzando le tabelle di verità:"
- "Minimizzare la seguente funzione booleana utilizzando le mappe di Karnaugh:"

## **Esempi di Successo**

### **Esercizio Tipo 1 - Distributiva (3 var)**
```
(A + B) ⋅ (A + C) = A + B ⋅ C
```

### **Esercizio Tipo 2 - Fattorizzazione (3 var)**
```
Ā⋅B⋅C + Ā⋅B⋅C̄ + A⋅B⋅C̄ + A⋅B̄⋅C̄ = Ā⋅B + A⋅C̄
```

### **Esercizio Tipo 3 - Assorbimento (4 var)**
```
A⋅B⋅C̄⋅D̄ + A⋅B⋅C̄⋅D + A⋅B⋅C⋅D̄ + A⋅B⋅C⋅D = A⋅B
```

## **Livelli di Complessità**

### **Livello 1 - Base (2-3 variabili)**
- Leggi elementari: assorbimento, distributiva
- 4-8 righe di tabella di verità
- Semplificazione evidente

### **Livello 2 - Intermedio (3-4 variabili)**
- Combinazione di più leggi
- 8-16 righe di tabella di verità
- Richiede ragionamento

### **Livello 3 - Avanzato (4+ variabili)**
- Espressioni molto complesse
- Mappe di Karnaugh necessarie
- Semplificazioni non ovvie

## **Controllo Qualità**

### **Checklist di validazione:**
- [ ] Espressione semplice scelta appropriata
- [ ] Trasformazioni algebriche corrette
- [ ] Tabelle di verità calcolate per entrambi i membri
- [ ] Tutte le righe corrispondono
- [ ] Livello di difficoltà appropriato
- [ ] Template standard rispettato

### **Errori comuni da evitare:**
- ❌ Trasformazioni algebriche errate
- ❌ Errori di calcolo nelle tabelle
- ❌ Espressioni troppo banali o troppo complesse
- ❌ Mancanza di verifica finale

## **Note per il Futuro**

Questo processo garantisce:
1. **Correttezza matematica** - sempre verificata
2. **Gradualità difficoltà** - controllabile
3. **Diversità esercizi** - infinite variazioni possibili
4. **Efficienza creazione** - processo sistematico

**Ultimo aggiornamento**: 2025-10-05