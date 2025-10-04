# Esame Calcolatori - 05/09/2025
## Compito d'Esempio per Allenamento

---

## Esercizio 1 - Algebra Booleana e Multiplexer
**Categoria**: Algebra Booleana e Multiplexer

Dimostrare, mediante passaggi algebrici, che:
$$
(A + B)(A + \overline{C})(\overline{A} + C) = AC + \overline{A}B\overline{C}
$$
Implementare inoltre la tabella di verità della funzione booleana tramite un multiplexer.

---

## Esercizio 2 - Reti Combinatorie
**Categoria**: Reti Combinatorie

Progettare una rete combinatoria con **3 ingressi** ($x_2$, $x_1$, $x_0$) e un'unica **uscita** `Y`, tale che:

- `Y = 1` se il numero binario rappresentato dagli ingressi è **un numero primo** (tra 0 e 7).
- `Y = 0` altrimenti.

Richiesto:
1. Determinare la tabella di verità.
2. Scrivere la funzione nella forma canonica **SOP**.
3. Semplificare con mappa di **Karnaugh**.
4. Disegnare lo schema circuitale risultante.

---

## Esercizio 3 - FSM Mealy
**Categoria**: Macchine a Stati Finiti - Mealy

Sintetizzare una **macchina a stati finiti di Mealy** con:

- Ingresso binario: `X`
- Uscita binaria: `Y`

La macchina deve riconoscere la sequenza `1010`.

- L'uscita è alta (`Y = 1`) solo nel momento in cui in ingresso si presenta la sequenza completa `1010`.

Richiesto:
1. Grafo degli stati (**STG**)
2. Tabella di transizione (**STT**)
3. Tabella di transizione codificata
4. Struttura circuitale del sistema completo, semplificando le funzioni.

---

## Esercizio 4 - FSM Moore
**Categoria**: Macchine a Stati Finiti - Moore

Sintetizzare una **macchina a stati finiti di Moore** che implementi un **contatore modulo 6** con le seguenti caratteristiche:

- Ingresso `X`: linea di abilitazione (`enable = 1`, `hold = 0`).
- Uscita: 3 linee che rappresentano il valore del contatore.
- Ad ogni impulso di clock:
  - Se `X = 1`, il contatore incrementa il proprio stato.
  - Se `X = 0`, il contatore rimane nello stato corrente.

Richiesto:
1. STG
2. STT
3. STT codificata
4. Struttura circuitale del sistema

---

## Esercizio 5 - Assembly ARM Programmi
**Categoria**: Assembly ARM - Programmi Base

Scrivere un programma in **Assembly ARM** che, nella sezione `.data`, contenga in memoria **un array di 10 numeri interi positivi**.

Il programma deve calcolare **la somma dei numeri pari** presenti nell'array e restituire il risultato nel registro `r0`.

---

## Esercizio 6 - Assembly ARM Procedure
**Categoria**: Assembly ARM - Procedure

Scrivere una **procedura in Assembly ARM** che, dato un vettore di interi, copi nel secondo vettore soltanto **gli elementi maggiori di zero e moltiplicati per 2**.

In ingresso la procedura riceve:
- `R0`: indirizzo base del primo vettore
- `R1`: indirizzo base del secondo vettore
- `R2`: numero di elementi del vettore

Il secondo vettore dovrà contenere in sequenza gli elementi filtrati e trasformati.

---

## Note per l'Allenamento

Questo compito d'esempio rappresenta la tipologia e difficoltà degli esercizi che si possono trovare all'esame di Calcolatori. 

Ogni categoria ha le sue caratteristiche specifiche:
- **Cat. 1-2**: Logica digitale e circuiti
- **Cat. 3-4**: Macchine a stati finiti
- **Cat. 5-6**: Programmazione Assembly ARM

Utilizza questo come riferimento per valutare il tuo livello di preparazione su ogni argomento.