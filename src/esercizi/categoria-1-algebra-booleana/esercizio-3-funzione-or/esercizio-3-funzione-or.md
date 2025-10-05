# Esercizio

Dimostrare, mediante passaggi algebrici, che:
$$
A \cdot \overline{B} + \overline{A} \cdot B + A \cdot B = A + B
$$
Implementare inoltre la tabella di verità della funzione booleana tramite un multiplexer.

## Check uguaglianza membri
Aggiungo questo check perchè copilot ha difficoltà a generare esercizi corretti.

### Tabella di verità di $ A \cdot \overline{B} + \overline{A} \cdot B + A \cdot B $

| A | B | $\overline{A}$ | $\overline{B}$ | $A \cdot \overline{B}$ | $\overline{A} \cdot B$ | $A \cdot B$ | **Risultato** |
|---|---|------------|------------|---------------------|---------------------|-------------|---------------|
| 0 | 0 | 1          | 1          | 0                   | 0                   | 0           | **0**         |
| 0 | 1 | 1          | 0          | 0                   | 1                   | 0           | **1**         |
| 1 | 0 | 0          | 1          | 1                   | 0                   | 0           | **1**         |
| 1 | 1 | 0          | 0          | 0                   | 0                   | 1           | **1**         |

### Tabella di verità di $ A + B $

| A | B | **Risultato** |
|---|---|---------------|
| 0 | 0 | **0**         |
| 0 | 1 | **1**         |
| 1 | 0 | **1**         |
| 1 | 1 | **1**         |

### Confronto risultati

| A | B | Espressione sinistra | Espressione destra | Uguali? |
|---|---|---------------------|--------------------|---------| 
| 0 | 0 | **0**               | **0**              | ✓       |
| 0 | 1 | **1**               | **1**              | ✓       |
| 1 | 0 | **1**               | **1**              | ✓       |
| 1 | 1 | **1**               | **1**              | ✓       |

**CONCLUSIONE**: L'uguaglianza è **VERA** ✅
- Le espressioni sono identiche in tutte le 4 righe
- L'espressione di sinistra rappresenta tutti i casi in cui almeno una delle due variabili è 1 (OR logico)