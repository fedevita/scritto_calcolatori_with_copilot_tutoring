# Esercizio

Dimostrare, mediante passaggi algebrici, che:
$$
(A + \overline{B} \cdot C) \cdot (\overline{A} + B \cdot C) + A \cdot \overline{B} \cdot \overline{C} = \overline{A} \cdot \overline{B} \cdot C + A \cdot \overline{B} \cdot \overline{C} + A \cdot B \cdot C
$$
Implementare inoltre la tabella di verità della funzione booleana tramite un multiplexer.

## Check uguaglianza membri
Aggiungo questo check perchè copilot ha difficoltà a generare esercizi corretti.

### Tabella di verità di $ (A + \overline{B} \cdot C) \cdot (\overline{A} + B \cdot C) + A \cdot \overline{B} \cdot \overline{C} $

| A | B | C | $\overline{B}$ | $\overline{C}$ | $\overline{A}$ | $\overline{B} \cdot C$ | $B \cdot C$ | $A + \overline{B} \cdot C$ | $\overline{A} + B \cdot C$ | $(A + \overline{B} \cdot C) \cdot (\overline{A} + B \cdot C)$ | $A \cdot \overline{B} \cdot \overline{C}$ | **Risultato** |
|---|---|---|------------|------------|------------|-------------------|-------------|--------------------------|--------------------------|-----------------------------------------------------------|----------------------------------|---------------|
| 0 | 0 | 0 | 1          | 1          | 1          | 0                 | 0           | 0                        | 1                        | 0                                                         | 0                                | **0**         |
| 0 | 0 | 1 | 1          | 0          | 1          | 1                 | 0           | 1                        | 1                        | 1                                                         | 0                                | **1**         |
| 0 | 1 | 0 | 0          | 1          | 1          | 0                 | 0           | 0                        | 1                        | 0                                                         | 0                                | **0**         |
| 0 | 1 | 1 | 0          | 0          | 1          | 0                 | 1           | 0                        | 1                        | 0                                                         | 0                                | **0**         |
| 1 | 0 | 0 | 1          | 1          | 0          | 0                 | 0           | 1                        | 0                        | 0                                                         | 1                                | **1**         |
| 1 | 0 | 1 | 1          | 0          | 0          | 1                 | 0           | 1                        | 0                        | 0                                                         | 0                                | **0**         |
| 1 | 1 | 0 | 0          | 1          | 0          | 0                 | 0           | 1                        | 0                        | 0                                                         | 0                                | **0**         |
| 1 | 1 | 1 | 0          | 0          | 0          | 0                 | 1           | 1                        | 1                        | 1                                                         | 0                                | **1**         |

### Tabella di verità di $ \overline{A} \cdot \overline{B} \cdot C + A \cdot \overline{B} \cdot \overline{C} + A \cdot B \cdot C $

| A | B | C | $\overline{A}$ | $\overline{B}$ | $\overline{C}$ | $\overline{A} \cdot \overline{B} \cdot C$ | $A \cdot \overline{B} \cdot \overline{C}$ | $A \cdot B \cdot C$ | **Risultato** |
|---|---|---|------------|------------|------------|----------------------------------|----------------------------------|---------------------|---------------|
| 0 | 0 | 0 | 1          | 1          | 1          | 0                                | 0                                | 0                   | **0**         |
| 0 | 0 | 1 | 1          | 1          | 0          | 1                                | 0                                | 0                   | **1**         |
| 0 | 1 | 0 | 1          | 0          | 1          | 0                                | 0                                | 0                   | **0**         |
| 0 | 1 | 1 | 1          | 0          | 0          | 0                                | 0                                | 0                   | **0**         |
| 1 | 0 | 0 | 0          | 1          | 1          | 0                                | 1                                | 0                   | **1**         |
| 1 | 0 | 1 | 0          | 1          | 0          | 0                                | 0                                | 0                   | **0**         |
| 1 | 1 | 0 | 0          | 0          | 1          | 0                                | 0                                | 0                   | **0**         |
| 1 | 1 | 1 | 0          | 0          | 0          | 0                                | 0                                | 1                   | **1**         |

### Confronto risultati CORRETTI

| A | B | C | Espressione sinistra | Espressione destra (CORRETTA) | Uguali? |
|---|---|---|---------------------|--------------------------------|---------| 
| 0 | 0 | 0 | **0**               | **0**                          | ✓       |
| 0 | 0 | 1 | **1**               | **1**                          | ✓       |
| 0 | 1 | 0 | **0**               | **0**                          | ✓       |
| 0 | 1 | 1 | **0**               | **0**                          | ✓       |
| 1 | 0 | 0 | **1**               | **1**                          | ✓       |
| 1 | 0 | 1 | **0**               | **0**                          | ✓       |
| 1 | 1 | 0 | **0**               | **0**                          | ✓       |
| 1 | 1 | 1 | **1**               | **1**                          | ✓       |

**CONCLUSIONE**: L'uguaglianza è ora **VERA** ✅
- Le espressioni sono identiche in tutte le 8 righe
- I mintermini sono: $m_1 + m_4 + m_7$ (001, 100, 111)

