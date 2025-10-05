# Esercizio

Dimostrare, mediante passaggi algebrici, che:
$$
A \cdot \overline{B} \cdot C + A \cdot B \cdot \overline{C} + \overline{A} \cdot B \cdot C \cdot D + A \cdot B \cdot C = A \cdot C + A \cdot B \cdot \overline{C} + \overline{A} \cdot B \cdot C \cdot D
$$
Implementare inoltre la tabella di verità della funzione booleana tramite un multiplexer.

## Check uguaglianza membri
Aggiungo questo check perché copilot ha difficoltà a generare esercizi corretti.

### Tabella di verità di $ A \cdot \overline{B} \cdot C + A \cdot B \cdot \overline{C} + \overline{A} \cdot B \cdot C \cdot D + A \cdot B \cdot C $

| A | B | C | D | $\overline{A}$ | $\overline{B}$ | $\overline{C}$ | $A \cdot \overline{B} \cdot C$ | $A \cdot B \cdot \overline{C}$ | $\overline{A} \cdot B \cdot C \cdot D$ | $A \cdot B \cdot C$ | **Sinistra** |
|---|---|---|---|------------|------------|------------|------------------------------|-------------------------------|-------------------------------------|---------------------|--------------|
| 0 | 0 | 0 | 0 | 1          | 1          | 1          | 0                            | 0                             | 0                                   | 0                   | **0**        |
| 0 | 0 | 0 | 1 | 1          | 1          | 1          | 0                            | 0                             | 0                                   | 0                   | **0**        |
| 0 | 0 | 1 | 0 | 1          | 1          | 0          | 0                            | 0                             | 0                                   | 0                   | **0**        |
| 0 | 0 | 1 | 1 | 1          | 1          | 0          | 0                            | 0                             | 0                                   | 0                   | **0**        |
| 0 | 1 | 0 | 0 | 1          | 0          | 1          | 0                            | 0                             | 0                                   | 0                   | **0**        |
| 0 | 1 | 0 | 1 | 1          | 0          | 1          | 0                            | 0                             | 0                                   | 0                   | **0**        |
| 0 | 1 | 1 | 0 | 1          | 0          | 0          | 0                            | 0                             | 0                                   | 0                   | **0**        |
| 0 | 1 | 1 | 1 | 1          | 0          | 0          | 0                            | 0                             | 1                                   | 0                   | **1**        |
| 1 | 0 | 0 | 0 | 0          | 1          | 1          | 0                            | 0                             | 0                                   | 0                   | **0**        |
| 1 | 0 | 0 | 1 | 0          | 1          | 1          | 0                            | 0                             | 0                                   | 0                   | **0**        |
| 1 | 0 | 1 | 0 | 0          | 1          | 0          | 1                            | 0                             | 0                                   | 0                   | **1**        |
| 1 | 0 | 1 | 1 | 0          | 1          | 0          | 1                            | 0                             | 0                                   | 0                   | **1**        |
| 1 | 1 | 0 | 0 | 0          | 0          | 1          | 0                            | 1                             | 0                                   | 0                   | **1**        |
| 1 | 1 | 0 | 1 | 0          | 0          | 1          | 0                            | 1                             | 0                                   | 0                   | **1**        |
| 1 | 1 | 1 | 0 | 0          | 0          | 0          | 0                            | 0                             | 0                                   | 1                   | **1**        |
| 1 | 1 | 1 | 1 | 0          | 0          | 0          | 0                            | 0                             | 0                                   | 1                   | **1**        |

### Tabella di verità di $ A \cdot C + A \cdot B \cdot \overline{C} + \overline{A} \cdot B \cdot C \cdot D $

| A | B | C | D | $\overline{A}$ | $\overline{C}$ | $A \cdot C$ | $A \cdot B \cdot \overline{C}$ | $\overline{A} \cdot B \cdot C \cdot D$ | **Destra** |
|---|---|---|---|------------|------------|-------------|-------------------------------|-------------------------------------|------------|
| 0 | 0 | 0 | 0 | 1          | 1          | 0           | 0                             | 0                                   | **0**      |
| 0 | 0 | 0 | 1 | 1          | 1          | 0           | 0                             | 0                                   | **0**      |
| 0 | 0 | 1 | 0 | 1          | 0          | 0           | 0                             | 0                                   | **0**      |
| 0 | 0 | 1 | 1 | 1          | 0          | 0           | 0                             | 0                                   | **0**      |
| 0 | 1 | 0 | 0 | 1          | 1          | 0           | 0                             | 0                                   | **0**      |
| 0 | 1 | 0 | 1 | 1          | 1          | 0           | 0                             | 0                                   | **0**      |
| 0 | 1 | 1 | 0 | 1          | 0          | 0           | 0                             | 0                                   | **0**      |
| 0 | 1 | 1 | 1 | 1          | 0          | 0           | 0                             | 1                                   | **1**      |
| 1 | 0 | 0 | 0 | 0          | 1          | 0           | 0                             | 0                                   | **0**      |
| 1 | 0 | 0 | 1 | 0          | 1          | 0           | 0                             | 0                                   | **0**      |
| 1 | 0 | 1 | 0 | 0          | 0          | 1           | 0                             | 0                                   | **1**      |
| 1 | 0 | 1 | 1 | 0          | 0          | 1           | 0                             | 0                                   | **1**      |
| 1 | 1 | 0 | 0 | 0          | 1          | 0           | 1                             | 0                                   | **1**      |
| 1 | 1 | 0 | 1 | 0          | 1          | 0           | 1                             | 0                                   | **1**      |
| 1 | 1 | 1 | 0 | 0          | 0          | 1           | 0                             | 0                                   | **1**      |
| 1 | 1 | 1 | 1 | 0          | 0          | 1           | 0                             | 0                                   | **1**      |

### Confronto risultati

| A | B | C | D | Espressione sinistra | Espressione destra | Uguali? |
|---|---|---|---|---------------------|-------------------|---------|
| 0 | 0 | 0 | 0 | 0 | 0 | ✓ |
| 0 | 0 | 0 | 1 | 0 | 0 | ✓ |
| 0 | 0 | 1 | 0 | 0 | 0 | ✓ |
| 0 | 0 | 1 | 1 | 0 | 0 | ✓ |
| 0 | 1 | 0 | 0 | 0 | 0 | ✓ |
| 0 | 1 | 0 | 1 | 0 | 0 | ✓ |
| 0 | 1 | 1 | 0 | 0 | 0 | ✓ |
| 0 | 1 | 1 | 1 | 1 | 1 | ✓ |
| 1 | 0 | 0 | 0 | 0 | 0 | ✓ |
| 1 | 0 | 0 | 1 | 0 | 0 | ✓ |
| 1 | 0 | 1 | 0 | 1 | 1 | ✓ |
| 1 | 0 | 1 | 1 | 1 | 1 | ✓ |
| 1 | 1 | 0 | 0 | 1 | 1 | ✓ |
| 1 | 1 | 0 | 1 | 1 | 1 | ✓ |
| 1 | 1 | 1 | 0 | 1 | 1 | ✓ |
| 1 | 1 | 1 | 1 | 1 | 1 | ✓ |

**Le due espressioni sono UGUALI.** ✅

## Implementazione Multiplexer

*Da completare: implementazione tramite multiplexer seguendo la tabella di verità.*