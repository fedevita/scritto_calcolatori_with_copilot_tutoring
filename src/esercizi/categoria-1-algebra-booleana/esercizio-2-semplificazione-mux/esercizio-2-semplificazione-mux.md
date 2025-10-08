# Esercizio

Dimostrare, mediante passaggi algebrici, che:
$$
(A + \overline{B} \cdot C) \cdot (\overline{A} + B \cdot C) + A \cdot \overline{B} \cdot \overline{C} = \overline{A} \cdot \overline{B} \cdot C + A \cdot \overline{B} \cdot \overline{C} + A \cdot B \cdot C
$$
Implementare inoltre la tabella di verità della funzione booleana tramite un multiplexer.

---

# Svolgimento

## Dimostrazione algebrica

**Passaggio 1** - **T8 Distributiva**: $(A + \overline{B} \cdot C) \cdot (\overline{A} + B \cdot C)$
$$
(A + \overline{B} \cdot C) \cdot (\overline{A} + B \cdot C) = A(\overline{A} + B \cdot C) + \overline{B} \cdot C(\overline{A} + B \cdot C)
$$
$$
= A\overline{A} + ABC + \overline{A}\overline{B}C + \overline{B}BC^2
$$

**Passaggio 2** - **T5 Complementi**: $A\overline{A} = 0$ e $\overline{B}B = 0$, **T4 Idempotenza**: $C^2 = C$
$$
= 0 + ABC + \overline{A}\overline{B}C + 0 \cdot C
$$
$$
= ABC + \overline{A}\overline{B}C
$$

**Passaggio 3** - Aggiungo il termine $A \cdot \overline{B} \cdot \overline{C}$
$$
(A + \overline{B} \cdot C) \cdot (\overline{A} + B \cdot C) + A \cdot \overline{B} \cdot \overline{C} = ABC + \overline{A}\overline{B}C + A\overline{B}\overline{C}
$$

**Passaggio 4** - Riordino i termini per chiarezza
$$
= \overline{A}\overline{B}C + A\overline{B}\overline{C} + ABC
$$

**QED** (dimostrato)

---

## Tabella di verità e implementazione MUX

| A | B | C | $(A+\overline{B} \cdot C)(\overline{A}+B \cdot C)+A\overline{B}\overline{C}$ | $\overline{A}\overline{B}C + A\overline{B}\overline{C} + ABC$ |
|---|---|---|----------------------------------------------------------------------|---------------------------------------------------------------|
| 0 | 0 | 0 | 0                                                                    | 0                                                             |
| 0 | 0 | 1 | 1                                                                    | 1                                                             |
| 0 | 1 | 0 | 0                                                                    | 0                                                             |
| 0 | 1 | 1 | 0                                                                    | 0                                                             |
| 1 | 0 | 0 | 1                                                                    | 1                                                             |
| 1 | 0 | 1 | 0                                                                    | 0                                                             |
| 1 | 1 | 0 | 0                                                                    | 0                                                             |
| 1 | 1 | 1 | 1                                                                    | 1                                                             |

**Implementazione con MUX 8:1**
- **Selezioni**: $S_2 = A$, $S_1 = B$, $S_0 = C$
- **Ingressi**: $I_0 = 0$, $I_1 = 1$, $I_2 = 0$, $I_3 = 0$, $I_4 = 1$, $I_5 = 0$, $I_6 = 0$, $I_7 = 1$

La funzione vale 1 solo per le combinazioni: 001, 100, 111 (righe 1, 4, 7 della tabella).

## Schema circuitale MUX 8:1

![Schema MUX 8:1](esercizio-2-semplificazione-mux-schema-mux.jpg)

**Configurazione per la funzione $\overline{A}\overline{B}C + A\overline{B}\overline{C} + ABC$:**
- **Selezioni**: $S_2 = A$, $S_1 = B$, $S_0 = C$  
- **Ingressi**: $I_0 = 0$, $I_1 = 1$, $I_2 = 0$, $I_3 = 0$, $I_4 = 1$, $I_5 = 0$, $I_6 = 0$, $I_7 = 1$

**Funzionamento:**
- ABC = 001 → seleziona $I_1 = 1$ → Y = 1 (corretto)
- ABC = 100 → seleziona $I_4 = 1$ → Y = 1 (corretto)
- ABC = 111 → seleziona $I_7 = 1$ → Y = 1 (corretto)
- Tutte le altre combinazioni → Y = 0