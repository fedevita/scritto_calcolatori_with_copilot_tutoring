# Esercizio

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