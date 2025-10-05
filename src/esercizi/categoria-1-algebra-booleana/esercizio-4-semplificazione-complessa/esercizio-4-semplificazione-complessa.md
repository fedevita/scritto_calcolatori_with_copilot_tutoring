# Esercizio

Dimostrare, mediante passaggi algebrici, che:
$$
(A + B \cdot C) \cdot (\overline{A} + \overline{B}) \cdot (A + \overline{C}) + A \cdot B \cdot \overline{C} + \overline{A} \cdot \overline{B} \cdot C = A \cdot \overline{C} + \overline{B} \cdot C
$$
Implementare inoltre la tabella di verità della funzione booleana tramite un multiplexer.

## Check uguaglianza membri
Aggiungo questo check perchè copilot ha difficoltà a generare esercizi corretti.

### Tabella di verità di $ (A + B \cdot C) \cdot (\overline{A} + \overline{B}) \cdot (A + \overline{C}) + A \cdot B \cdot \overline{C} + \overline{A} \cdot \overline{B} \cdot C $

| A | B | C | $\overline{A}$ | $\overline{B}$ | $\overline{C}$ | $B \cdot C$ | $A + B \cdot C$ | $\overline{A} + \overline{B}$ | $A + \overline{C}$ | $(A + B \cdot C) \cdot (\overline{A} + \overline{B}) \cdot (A + \overline{C})$ | $A \cdot B \cdot \overline{C}$ | $\overline{A} \cdot \overline{B} \cdot C$ | **Risultato** |
|---|---|---|------------|------------|------------|----------|----------------|----------------------------|-------------------|--------------------------------------------------------------------------|-------------------------------|---------------------------------------|---------------|
| 0 | 0 | 0 | 1          | 1          | 1          | 0        | 0              | 1                          | 1                 | 0                                                                        | 0                             | 0                                     | **0**         |
| 0 | 0 | 1 | 1          | 1          | 0          | 0        | 0              | 1                          | 0                 | 0                                                                        | 0                             | 1                                     | **1**         |
| 0 | 1 | 0 | 1          | 0          | 1          | 0        | 0              | 1                          | 1                 | 0                                                                        | 0                             | 0                                     | **0**         |
| 0 | 1 | 1 | 1          | 0          | 0          | 1        | 1              | 1                          | 0                 | 0                                                                        | 0                             | 0                                     | **0**         |
| 1 | 0 | 0 | 0          | 1          | 1          | 0        | 1              | 1                          | 1                 | 1                                                                        | 0                             | 0                                     | **1**         |
| 1 | 0 | 1 | 0          | 1          | 0          | 0        | 1              | 1                          | 1                 | 1                                                                        | 0                             | 0                                     | **1**         |
| 1 | 1 | 0 | 0          | 0          | 1          | 0        | 1              | 0                          | 1                 | 0                                                                        | 1                             | 0                                     | **1**         |
| 1 | 1 | 1 | 0          | 0          | 0          | 1        | 1              | 0                          | 1                 | 0                                                                        | 0                             | 0                                     | **0**         |

### Tabella di verità di $ A \cdot \overline{C} + \overline{B} \cdot C $

| A | B | C | $\overline{B}$ | $\overline{C}$ | $A \cdot \overline{C}$ | $\overline{B} \cdot C$ | **Risultato** |
|---|---|---|------------|------------|---------------------|-------------------|---------------|
| 0 | 0 | 0 | 1          | 1          | 0                   | 0                 | **0**         |
| 0 | 0 | 1 | 1          | 0          | 0                   | 1                 | **1**         |
| 0 | 1 | 0 | 0          | 1          | 0                   | 0                 | **0**         |
| 0 | 1 | 1 | 0          | 0          | 0                   | 0                 | **0**         |
| 1 | 0 | 0 | 1          | 1          | 1                   | 0                 | **1**         |
| 1 | 0 | 1 | 1          | 0          | 0                   | 1                 | **1**         |
| 1 | 1 | 0 | 0          | 1          | 1                   | 0                 | **1**         |
| 1 | 1 | 1 | 0          | 0          | 0                   | 0                 | **0**         |

### Confronto risultati

| A | B | C | Espressione sinistra | Espressione destra | Uguali? |
|---|---|---|---------------------|--------------------|---------| 
| 0 | 0 | 0 | **0**               | **0**              | ✓       |
| 0 | 0 | 1 | **1**               | **1**              | ✓       |
| 0 | 1 | 0 | **0**               | **0**              | ✓       |
| 0 | 1 | 1 | **0**               | **0**              | ✓       |
| 1 | 0 | 0 | **1**               | **1**              | ✓       |
| 1 | 0 | 1 | **1**               | **1**              | ✓       |
| 1 | 1 | 0 | **1**               | **1**              | ✓       |
| 1 | 1 | 1 | **0**               | **0**              | ✓       |

**CONCLUSIONE**: L'uguaglianza è **VERA** ✅
- Le espressioni sono identiche in tutte le 8 righe
- I mintermini sono: $m_1 + m_4 + m_5 + m_6$ (001, 100, 101, 110)