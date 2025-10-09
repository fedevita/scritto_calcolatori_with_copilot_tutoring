# ARM Assembly - Cheat Sheet Personale

## 🎯 ARM Assembly: Le Origini

ARM nasce nel 1985 da Acorn Computers come processore RISC a 32 bit per personal computer. Il nome originale "Acorn RISC Machine" diventa poi "Advanced RISC Machine" quando ARM diventa azienda indipendente nel 1990. ARM si distingue per il design RISC puro: istruzioni semplici e uniformi, architettura load/store, e soprattutto l'innovativa esecuzione condizionale che permette di evitare molti salti. Oggi ARM domina il mercato mobile e embedded grazie al basso consumo energetico e all'efficienza del codice. Il linguaggio assembly ARM riflette questa filosofia: sintassi pulita, registri uniformi, e caratteristiche uniche come il barrel shifter integrato.

---

## RISC vs CISC

**RISC (Reduced Instruction Set Computer)** usa istruzioni semplici e uniformi. Ogni istruzione esegue un'operazione elementare in un ciclo di clock. Il processore è veloce ma serve più codice per task complessi. La memoria contiene molte istruzioni semplici. I registri sono numerosi e uniformi.

**CISC (Complex Instruction Set Computer)** usa istruzioni complesse e variabili. Una singola istruzione può eseguire operazioni multiple. Il processore è più lento ma serve meno codice. La memoria contiene poche istruzioni potenti. I registri sono specializzati per funzioni specifiche.

**ARM è RISC puro:** tutte le istruzioni sono 32 bit, eseguono un'operazione per volta, solo load/store toccano la memoria. Il vantaggio è l'efficienza energetica e la velocità di esecuzione. Lo svantaggio è il codice più lungo rispetto a CISC.

---

## architettura load/store

**Separazione netta:** solo le istruzioni `ldr` (load) e `str` (store) accedono alla memoria. Tutte le altre operazioni lavorano esclusivamente sui registri. Non esistono istruzioni come "add memoria, registro" tipiche di CISC.

**Workflow obbligatorio:** per elaborare dati in memoria devi prima caricarli nei registri con `ldr`, eseguire i calcoli sui registri, poi salvare il risultato con `str`. Esempio: `ldr r0, [r1]` → `add r0, r0, #1` → `str r0, [r1]` per incrementare un valore in memoria.

**Vantaggi:** il processore è più semplice e veloce perché separa logicamente accesso memoria e calcoli. La pipeline è più efficiente. I compilatori ottimizzano meglio tenendo i dati nei registri.

**Svantaggio:** serve più codice per operazioni semplici sulla memoria. In CISC basterebbe `inc [memoria]`, in ARM servono tre istruzioni separate.

---

## registri

**ARM ha 16 registri (r0-r15)** tutti da 32 bit. I primi 13 sono general-purpose, gli ultimi 3 hanno funzioni speciali. Tutti i registri sono uniformi e intercambiabili per calcoli.

**r0-r3:** parametri e valori di ritorno delle funzioni. `r0` primo parametro e primo valore di ritorno, `r1` secondo parametro o secondo valore di ritorno, e così via.

**r4-r11:** variabili locali e dati temporanei. Devi salvarli sullo stack se li modifichi in una funzione. Sono i registri "callee-saved" secondo le convenzioni ARM.

**r12 (ip):** registro temporaneo. Il linker può usarlo per chiamate inter-procedurali. Non garantisce che mantenga il valore tra chiamate di funzione.

**r13 (sp):** stack pointer. Punta sempre alla cima dello stack. Cresce verso il basso (indirizzi decrescenti). Usato per push/pop automatici.

**r14 (lr):** link register. Salva automaticamente l'indirizzo di ritorno quando chiami una funzione con `bl`. Usi `bx lr` per tornare al chiamante.

**r15 (pc):** program counter. Contiene l'indirizzo dell'istruzione corrente + 8 (pipeline ARM). Modificarlo causa un salto immediato.

---

## Commenti

**Simbolo @:** in ARM Assembly usi `@` per iniziare un commento. Tutto quello che segue sulla stessa riga viene ignorato dall'assembler. È l'unico modo per commentare.

**Commento inline:** `mov r0, #5    @ Carica il valore 5 nel registro r0`

**Commento a riga intera:** 
```assembly
@ Questa è una funzione che calcola la somma
@ Parametri: r0 = primo numero, r1 = secondo numero
@ Ritorna: r0 = somma dei due numeri
```

**Buone pratiche:** commenta sempre il significato dei registri, spiega algoritmi complessi, documenta le convenzioni di chiamata. I commenti sono essenziali in assembly perché il codice è molto cryptico.

---

## Struttura di un programma

**Sezioni obbligatorie:** ogni programma ARM inizia con `.text` per il codice, `.data` per variabili inizializzate, `.bss` per variabili non inizializzate. La sezione `.global _start` rende visibile il punto di ingresso.

**Punto di ingresso:** `_start:` è l'etichetta dove inizia l'esecuzione. Equivale al `main()` in C. L'assembler cerca questa etichetta per sapere da dove partire.

**Convenzioni etichette:** i nomi devono iniziare con lettera o underscore, possono contenere numeri. Terminano sempre con `:` quando definisci una posizione. Esempi: `loop:`, `_start:`, `calcola_somma:`.

**Allineamento:** usa `.align 2` per allineare il codice a 4 byte (2^2). ARM richiede che le istruzioni siano allineate a 32 bit per efficienza.

**Terminazione:** chiudi sempre con `mov r7, #1` seguito da `swi 0` per exit system call, oppure usa `bx lr` se stai tornando da una funzione chiamata.

**Esempio base:**
```assembly
.text
.global _start
_start:
    mov r0, #42    @ valore di ritorno
    mov r7, #1     @ exit system call
    swi 0          @ chiama kernel
```

--- 

## Equivalente del return

**Return da funzione:** usa `bx lr` per tornare al chiamante. Il registro `lr` contiene automaticamente l'indirizzo di ritorno salvato da `bl`. È l'equivalente di `return` in C.

**Exit dal programma principale:** usa la system call exit con `mov r7, #1` seguito da `swi 0`. Il valore in `r0` diventa il codice di uscita del programma (0 = successo, diverso da 0 = errore). ARM Linux usa `r7` per il numero della system call per convenzione ABI standard.

**Return con valore:** metti il valore di ritorno in `r0` prima di `bx lr`. Per valori multipli usa `r0`, `r1`, `r2`, `r3` nell'ordine. Esempio: `mov r0, #42` poi `bx lr` per restituire 42.

**Gestione stack nelle funzioni:** se modifichi `r4-r11` devi salvarli con `push {r4, r5, lr}` all'inizio e ripristinarli con `pop {r4, r5, pc}` alla fine. Il `pc` in pop causa automaticamente il ritorno.

**Chiamata e ritorno completi:**
```assembly
.text
.global _start
_start:
    bl mia_funzione    @ chiama funzione (lr = indirizzo ritorno)
    mov r7, #1         @ exit system call
    swi 0              @ termina programma

mia_funzione:
    mov r0, #100     @ prepara valore di ritorno
    bx lr              @ torna al chiamante
```

---

## System Call

**Meccanismo:** usa `r7` per il numero della system call, `r0-r6` per i parametri, poi `swi 0` per invocare il kernel. Il valore di ritorno arriva in `r0`.

**System call principali:** `exit(1)` termina programma, `write(4)` scrive su file/stdout, `read(3)` legge da file/stdin, `open(5)` apre file. I numeri tra parentesi vanno in `r7`.

**Esempio write completo:**
```assembly
.text
.global _start

.data
messaggio: .ascii "Hello"       @ stringa da stampare (5 caratteri)
lunghezza: .word 5              @ lunghezza stringa (4 byte)

_start:
    @ System call write() per stampare su stdout
    mov r7, #4                  @ numero system call write()
    mov r0, #1                  @ file descriptor 1 = stdout
    ldr r1, =messaggio          @ indirizzo della stringa
    ldr r2, =lunghezza          @ carica indirizzo lunghezza
    ldr r2, [r2]               @ carica valore lunghezza (5)
    swi 0                      @ invoca il kernel
    
    @ System call exit() per terminare
    mov r7, #1               @ numero system call exit()
    mov r0, #0               @ exit code 0 = successo
    swi 0                    @ termina programma
```

**Questo programma stampa la stringa "Hello" su stdout e termina con exit code 0. È un esempio completo di come combinare dati in memoria, system call write() per output e system call exit() per terminazione pulita.**

**Convenzioni:** se `r0` è negativo dopo `swi 0` c'è stato un errore. Valore 0 o positivo indica successo. Usa sempre `r7` prima di ogni system call.

--- 

## Assegnazioni di Variabili

**Costanti immediate:** usa `mov` con `#` per assegnare valori fissi ai registri. Esempio: `mov r0, #42` carica il numero 42 in r0. Le costanti devono essere nel range 0-255 o ruotabili.
```assembly
.text
.global _start
_start:
    mov r0, #42
    mov r7, #1
    swi 0
```

**Copia tra registri:** usa `mov` senza `#` per copiare il contenuto di un registro in un altro. Esempio: `mov r1, r0` copia il valore di r0 in r1. Non modifica r0.
```assembly
.text
.global _start
_start:
    mov r0, #42
    mov r1, r0
    mov r7, #1
    swi 0
```

**Variabili in memoria:** prima definisci con `.word` nella sezione `.data`, poi usa `ldr` per caricare e `str` per salvare. Esempio: `ldr r0, =variabile` carica l'indirizzo, `ldr r0, [r0]` carica il valore.
```assembly
.data
numero: .word 10        @ definisce variabile = 10

.text
_start:
    ldr r0, =numero     @ r0 = indirizzo di numero
    ldr r1, [r0]        @ r1 = valore di numero (10)
    mov r2, #5          @ r2 = costante 5
    add r1, r1, r2      @ r1 = 10 + 5 = 15
    str r1, [r0]        @ numero = 15 (salva in memoria)
```

**Pattern comune:** carica valore → modifica nei registri → salva risultato. ARM non può fare operazioni dirette sulla memoria, sempre attraverso registri intermedi.

--- 

## Operatori

### Operatori Aritmetici:

#### Addizione (add)

**Sintassi:** `add destinazione, operando1, operando2` dove destinazione = operando1 + operando2. Può usare registri o costanti immediate (precedute da #).

**Caratteristiche:** supporta il barrel shifter integrato di ARM, permettendo di sommare un valore shiftato in una sola istruzione. Può essere condizionale aggiungendo suffissi come `addeq` (addizione solo se uguale).

```assembly
.text
_start:
    mov r1, #10        @ r1 = 10
    mov r2, #5         @ r2 = 5
    add r0, r1, r2     @ r0 = r1 + r2 = 15
    add r3, r1, #20    @ r3 = r1 + 20 = 30
```

#### Sottrazione (sub)

**Sintassi:** `sub destinazione, operando1, operando2` dove destinazione = operando1 - operando2. Può usare registri o costanti immediate (precedute da #).

**Caratteristiche:** supporta il barrel shifter integrato di ARM, permettendo di sottrarre un valore shiftato in una sola istruzione. Può essere condizionale aggiungendo suffissi come `subne` (sottrazione solo se diverso).

```assembly
.text
_start:
    mov r1, #20        @ r1 = 20
    mov r2, #8         @ r2 = 8
    sub r0, r1, r2     @ r0 = r1 - r2 = 12
    sub r3, r1, #5     @ r3 = r1 - 5 = 15
```

#### Sottrazione Inversa (rsb)

**Sintassi:** `rsb destinazione, operando1, operando2` dove destinazione = operando2 - operando1. Inverte l'ordine dei parametri rispetto a `sub`.

**Caratteristiche:** utile quando vuoi sottrarre da una costante o quando l'ordine naturale degli operandi è invertito. Supporta barrel shifter e modificatori condizionali come `rsbeq`.

```assembly
.text
_start:
    mov r1, #5         @ r1 = 5
    mov r2, #20        @ r2 = 20
    rsb r0, r1, r2     @ r0 = r2 - r1 = 20 - 5 = 15
    rsb r3, r1, #100   @ r3 = 100 - r1 = 100 - 5 = 95
```

#### Moltiplicazione (mul)

**Sintassi:** `mul destinazione, operando1, operando2` dove destinazione = operando1 × operando2. Solo due operandi perché il risultato va sempre nel primo registro.

**Caratteristiche:** ARM non ha moltiplicazione con costante immediata, serve sempre un registro. Il risultato è a 32 bit, per operazioni a 64 bit usa `umull` o `smull`.

```assembly
.text
_start:
    mov r1, #6         @ r1 = 6
    mov r2, #7         @ r2 = 7
    mul r0, r1, r2     @ r0 = r1 × r2 = 42
    mov r3, #3         @ r3 = 3
    mul r4, r0, r3     @ r4 = r0 × r3 = 126
```

#### Moltiplicazione e Addizione (mla)

**Sintassi:** `mla destinazione, operando1, operando2, operando3` dove destinazione = (operando1 × operando2) + operando3. Combina moltiplicazione e addizione in una istruzione.

**Caratteristiche:** ottimizzazione hardware comune nei processori DSP. Utile per calcoli matematici complessi e algoritmi che richiedono accumulo di prodotti.

```assembly
.text
_start:
    mov r1, #3         @ r1 = 3
    mov r2, #4         @ r2 = 4
    mov r3, #10        @ r3 = 10
    mla r0, r1, r2, r3 @ r0 = (r1 × r2) + r3 = 12 + 10 = 22
```

#### Moltiplicazione 64-bit Senza Segno (umull)

**Sintassi:** `umull rdLo, rdHi, rm, rs` dove il risultato 64-bit viene automaticamente diviso in rdLo (32 bit bassi) e rdHi (32 bit alti).

**Come funziona lo split:** ARM prende il risultato e lo divide automaticamente - i primi 32 bit vanno in rdLo, i successivi 32 bit in rdHi. Per ricomporre: `risultato_completo = rdHi × 2^32 + rdLo`.

```assembly
.text
_start:
    @ ESEMPIO 1: Moltiplicazione che supera 32-bit
    ldr r1, =3000000000    @ r1 = 3.000.000.000
    mov r2, #2             @ r2 = 2
    umull r0, r3, r1, r2   @ Moltiplicazione: 3.000.000.000 × 2
    
    @ RISULTATO AUTOMATICO:
    @ r0 = 1705032704 (parte bassa - primi 32 bit)
    @ r3 = 1 (parte alta - secondi 32 bit)
    @ Per ricomporre: 1 × 4.294.967.296 + 1.705.032.704 = 6.000.000.000
    
    @ ESEMPIO 2: Moltiplicazione che sta in 32-bit
    mov r4, #65535         @ r4 = 65.535
    mov r5, #2             @ r5 = 2
    umull r6, r7, r4, r5   @ Moltiplicazione: 65.535 × 2 = 131.070
    
    @ RISULTATO AUTOMATICO:
    @ r6 = 131070 (parte bassa - tutto il risultato)
    @ r7 = 0 (parte alta - vuota perché il risultato sta in 32-bit)
```

#### Moltiplicazione 64-bit Con Segno (smull)

**Sintassi:** `smull rdLo, rdHi, rm, rs` dove il risultato 64-bit viene automaticamente diviso in rdLo (32 bit bassi) e rdHi (32 bit alti). Gestisce correttamente i numeri negativi.

**Come gestisce il segno:** ARM estende automaticamente il segno nei bit alti quando il risultato è negativo. Per ricomporre: `risultato_completo = rdHi × 2^32 + rdLo` (interpretando come numeri con segno).

```assembly
.text
_start:
    @ ESEMPIO 1: Moltiplicazione con numero negativo
    mov r1, #-100          @ r1 = -100 (numero negativo)
    mov r2, #200           @ r2 = 200 (numero positivo)
    smull r0, r3, r1, r2   @ Moltiplicazione: -100 × 200 = -20.000
    
    @ RISULTATO AUTOMATICO:
    @ r0 = 4294947296 (parte bassa - rappresentazione complemento a 2)
    @ r3 = -1 (parte alta - estensione del segno negativo)
    @ Per ricomporre: -1 × 4.294.967.296 + 4.294.947.296 = -20.000
    
    @ ESEMPIO 2: Moltiplicazione positiva (stesso comportamento di umull)
    mov r4, #50            @ r4 = 50 (positivo)
    mov r5, #30            @ r5 = 30 (positivo)
    smull r6, r7, r4, r5   @ Moltiplicazione: 50 × 30 = 1.500
    
    @ RISULTATO AUTOMATICO:
    @ r6 = 1500 (parte bassa - tutto il risultato)
    @ r7 = 0 (parte alta - vuota perché positivo e piccolo)
```

### Operatori Logici:

#### AND bit-a-bit (and)

**Sintassi:** `and destinazione, operando1, operando2` dove destinazione = operando1 & operando2. Esegue AND logico bit per bit tra i due operandi.

**Caratteristiche:** utile per mascherare bit specifici (mettere a 0 bit selezionati). Supporta barrel shifter e esecuzione condizionale. Comunemente usato per estrarre campi di bit.

```assembly
.text
_start:
    mov r1, #0b11110000    @ r1 = 240 (binario: 11110000)
    mov r2, #0b10101010    @ r2 = 170 (binario: 10101010)
    and r0, r1, r2         @ r0 = 160 (binario: 10100000)
    and r3, r1, #0x0F      @ r3 = 0 (maschera per isolare 4 bit bassi)
```

#### OR bit-a-bit (orr)

**Sintassi:** `orr destinazione, operando1, operando2` dove destinazione = operando1 | operando2. Esegue OR logico bit per bit tra i due operandi.

**Caratteristiche:** utile per impostare bit specifici (mettere a 1 bit selezionati) senza modificare gli altri. Supporta barrel shifter e condizioni.

```assembly
.text
_start:
    mov r1, #0b11110000    @ r1 = 240 (binario: 11110000)
    mov r2, #0b00001111    @ r2 = 15 (binario: 00001111)
    orr r0, r1, r2         @ r0 = 255 (binario: 11111111)
    orr r3, r1, #0x08      @ r3 = 248 (imposta bit 3 a 1)
```

#### XOR bit-a-bit (eor)

**Sintassi:** `eor destinazione, operando1, operando2` dove destinazione = operando1 ^ operando2. Esegue XOR (OR esclusivo) bit per bit.

**Caratteristiche:** utile per invertire bit specifici e per operazioni crittografiche. XOR con se stesso dà sempre 0. Supporta barrel shifter e condizioni.

```assembly
.text
_start:
    mov r1, #0b11110000    @ r1 = 240 (binario: 11110000)
    mov r2, #0b10101010    @ r2 = 170 (binario: 10101010)
    eor r0, r1, r2         @ r0 = 90 (binario: 01011010)
    eor r3, r1, r1         @ r3 = 0 (qualsiasi numero XOR se stesso = 0)
```

#### Bit Clear (bic)

**Sintassi:** `bic destinazione, operando1, operando2` dove destinazione = operando1 & ~operando2. Azzera i bit di operando1 dove operando2 ha bit a 1.

**Caratteristiche:** operazione unica di ARM per cancellare bit specifici in modo efficiente. Equivale a AND con il complemento del secondo operando.

```assembly
.text
_start:
    mov r1, #0b11111111    @ r1 = 255 (tutti bit a 1)
    mov r2, #0b00001111    @ r2 = 15 (maschera per bit 0-3)
    bic r0, r1, r2         @ r0 = 240 (cancella bit 0-3, mantiene 4-7)
    bic r3, r1, #0x80      @ r3 = 127 (cancella bit 7, mantiene altri)
```

#### NOT bit-a-bit (mvn)

**Sintassi:** `mvn destinazione, operando` dove destinazione = ~operando. Inverte tutti i bit dell'operando (complemento a 1).

**Caratteristiche:** può essere usato anche per caricare costanti negative o grandi. Supporta barrel shifter. È l'unico operatore logico con un solo operando.

```assembly
.text
_start:
    mov r1, #0b11110000    @ r1 = 240 (binario: 11110000)
    mvn r0, r1             @ r0 = 4294967055 (binario: 11111111111111111111111100001111)
    mvn r2, #0             @ r2 = -1 (tutti bit a 1)
    mvn r3, #0xFF          @ r3 = 4294967040 (modo per caricare ~255)
```

### Operatori di Confronto:

#### Confronto (cmp)

**Sintassi:** `cmp operando1, operando2` esegue operando1 - operando2 ma scarta il risultato, aggiorna solo i flag di stato. Non modifica registri.

**Caratteristiche:** imposta flag Z (zero), N (negativo), C (carry), V (overflow) per confronti successivi. Essenziale per istruzioni condizionali e salti.

```assembly
.text
_start:
    mov r1, #10            @ r1 = 10
    mov r2, #5             @ r2 = 5
    cmp r1, r2             @ confronta 10 - 5, imposta flag
    bgt maggiore           @ salta se r1 > r2 (flag impostati da cmp)
    mov r0, #0             @ r1 non è maggiore
    b fine
maggiore:
    mov r0, #1             @ r1 è maggiore
fine:
```

#### Confronto Negativo (cmn)

**Sintassi:** `cmn operando1, operando2` esegue operando1 + operando2 ma scarta il risultato, aggiorna solo i flag. Equivale a `cmp operando1, -operando2`.

**Caratteristiche:** utile per confrontare con valori negativi senza dover caricare il negativo in un registro. Più efficiente di `cmp` con costanti negative.

```assembly
.text
_start:
    mov r1, #-10           @ r1 = -10
    cmn r1, #10            @ confronta -10 + 10 = 0, imposta flag Z
    beq uguale_zero        @ salta se risultato è zero
    mov r0, #1             @ non zero
    b fine
uguale_zero:
    mov r0, #0             @ è zero
fine:
```

#### Test bit-a-bit (tst)

**Sintassi:** `tst operando1, operando2` esegue operando1 & operando2 ma scarta il risultato, aggiorna solo i flag. Testa se bit specifici sono impostati.

**Caratteristiche:** imposta flag Z se il risultato AND è zero (nessun bit in comune). Usato per verificare flag, maschere di bit, o condizioni multiple.

```assembly
.text
_start:
    mov r1, #0b11110000    @ r1 = 240
    tst r1, #0b00001111    @ testa se ci sono bit comuni
    beq nessun_bit_comune  @ salta se AND = 0 (flag Z impostato)
    mov r0, #1             @ ci sono bit comuni
    b fine
nessun_bit_comune:
    mov r0, #0             @ nessun bit comune
fine:
```

#### Test Uguaglianza (teq)

**Sintassi:** `teq operando1, operando2` esegue operando1 ^ operando2 ma scarta il risultato, aggiorna solo i flag. Testa se i valori sono identici.

**Caratteristiche:** imposta flag Z se XOR è zero (valori identici). Più efficiente di `cmp` quando serve solo testare uguaglianza esatta.

```assembly
.text
_start:
    mov r1, #42            @ r1 = 42
    mov r2, #42            @ r2 = 42
    teq r1, r2             @ testa se r1 == r2 via XOR
    beq sono_uguali        @ salta se XOR = 0 (flag Z impostato)
    mov r0, #0             @ diversi
    b fine
sono_uguali:
    mov r0, #1             @ uguali
fine:
```

### Operatori di Shift:

#### Logical Shift Left (lsl)

**Sintassi:** `mov destinazione, operando, lsl #valore` shifta operando a sinistra di valore posizioni, riempiendo con 0. Equivale a moltiplicazione per 2^valore.

**Caratteristiche:** può essere usato inline con altre istruzioni grazie al barrel shifter ARM. Shift di 1 = ×2, shift di 2 = ×4, etc.

```assembly
.text
_start:
    mov r1, #5             @ r1 = 5
    mov r0, r1, lsl #2     @ r0 = 5 << 2 = 20 (5 × 4)
    add r2, r1, r1, lsl #1 @ r2 = r1 + (r1 << 1) = 5 + 10 = 15
    lsl r3, r1, #3         @ r3 = 5 << 3 = 40 (forma esplicita)
```

#### Logical Shift Right (lsr)

**Sintassi:** `mov destinazione, operando, lsr #valore` shifta operando a destra di valore posizioni, riempiendo con 0. Equivale a divisione per 2^valore (senza segno).

**Caratteristiche:** divisione efficiente per potenze di 2. I bit che escono a destra vengono persi. Solo per numeri senza segno.

```assembly
.text
_start:
    mov r1, #20            @ r1 = 20
    mov r0, r1, lsr #2     @ r0 = 20 >> 2 = 5 (20 ÷ 4)
    lsr r2, r1, #1         @ r2 = 20 >> 1 = 10 (forma esplicita)
    add r3, r1, r1, lsr #3 @ r3 = r1 + (r1 >> 3) = 20 + 2 = 22
```

#### Arithmetic Shift Right (asr)

**Sintassi:** `mov destinazione, operando, asr #valore` shifta a destra mantenendo il bit di segno. Per divisione con numeri con segno.

**Caratteristiche:** estende il bit di segno (MSB) durante lo shift. Mantiene correttamente il segno per numeri negativi in complemento a 2.

```assembly
.text
_start:
    mov r1, #-20           @ r1 = -20 (numero negativo)
    mov r0, r1, asr #2     @ r0 = -20 >> 2 = -5 (divisione con segno)
    mov r2, #20            @ r2 = 20 (positivo)
    asr r3, r2, #2         @ r3 = 20 >> 2 = 5 (stesso risultato di lsr per positivi)
```

#### Rotate Right (ror)

**Sintassi:** `mov destinazione, operando, ror #valore` ruota operando a destra di valore posizioni. I bit che escono rientrano dall'altra parte.

**Caratteristiche:** nessun bit viene perso, solo riorganizzato. Utile per algoritmi crittografici e manipolazione circolare di bit.

```assembly
.text
_start:
    mov r1, #0x12345678    @ r1 = valore esempio
    mov r0, r1, ror #8     @ r0 = ruota di 8 bit = 0x78123456
    ror r2, r1, #16        @ r2 = ruota di 16 bit = 0x56781234
    add r3, r1, r1, ror #4 @ r3 = r1 + (r1 ruotato di 4)
```

#### Rotate Right Extended (rrx)

**Sintassi:** `mov destinazione, operando, rrx` ruota di 1 bit attraverso il carry flag. Il carry diventa MSB, LSB diventa carry.

**Caratteristiche:** rotazione a 33 bit (32 del registro + 1 carry). Utile per algoritmi che richiedono precisione estesa o shift multipli.

```assembly
.text
_start:
    mov r1, #0x80000001    @ r1 = bit 31 e 0 impostati
    adds r2, r1, r1        @ somma che imposta carry flag
    mov r0, r1, rrx        @ ruota attraverso carry
    @ Se carry era 1: MSB di r0 = 1, nuovo carry = LSB di r1
```

### Operatori di Trasferimento:

#### Muovi (mov)

**Sintassi:** `mov destinazione, operando` copia operando in destinazione. L'operazione più basilare per spostare dati tra registri.

**Caratteristiche:** può usare costanti immediate (#valore), registri, o registri con shift. Non modifica l'operando sorgente.

```assembly
.text
_start:
    mov r0, #42            @ carica costante immediata
    mov r1, r0             @ copia da registro a registro
    mov r2, r0, lsl #1     @ copia con shift (r2 = r0 × 2)
    mov r3, #0xFF00        @ carica maschera esadecimale
```

#### Muovi Negato (mvn)

**Sintassi:** `mvn destinazione, operando` copia il complemento a 1 di operando in destinazione. Inverte tutti i bit.

**Caratteristiche:** utile per creare maschere inverse o caricare costanti grandi. Può combinare con shift per operazioni complesse.

```assembly
.text
_start:
    mov r1, #0x0F          @ r1 = 15 (0000...00001111)
    mvn r0, r1             @ r0 = ~15 = -16 (1111...11110000)
    mvn r2, #0             @ r2 = ~0 = -1 (tutti bit a 1)
    mvn r3, r1, lsl #4     @ r3 = ~(r1 << 4) = complemento di 240
```

### Operatori di Memoria:

#### Load Register (ldr)

**Sintassi:** `ldr destinazione, [indirizzo]` carica un valore a 32-bit dalla memoria nel registro destinazione.

**Caratteristiche:** può usare indirizzamento immediato, registro base + offset, pre/post incremento. Fondamentale nell'architettura load/store di ARM.

```assembly
.data
numero: .word 42

.text
_start:
    ldr r0, =numero        @ carica indirizzo di numero
    ldr r1, [r0]           @ carica valore da indirizzo (42)
    ldr r2, [r0, #4]       @ carica da offset +4 bytes
    ldr r3, [r0], #4       @ carica e incrementa r0 di 4 (post-increment)
```

#### Store Register (str)

**Sintassi:** `str sorgente, [indirizzo]` salva il valore a 32-bit del registro sorgente nella memoria all'indirizzo specificato.

**Caratteristiche:** supporta gli stessi modi di indirizzamento di `ldr`. Essenziale per salvare risultati calcolati nei registri.

```assembly
.data
risultato: .word 0

.text
_start:
    mov r1, #100           @ valore da salvare
    ldr r0, =risultato     @ indirizzo di destinazione
    str r1, [r0]           @ salva 100 in memoria
    str r1, [r0, #4]       @ salva in offset +4
    str r1, [r0], #4       @ salva e incrementa indirizzo
```

#### Load Multiple (ldm)

**Sintassi:** `ldm registro_base{!}, {lista_registri}` carica multipli registri consecutivi dalla memoria in una sola istruzione.

**Caratteristiche:** molto efficiente per caricare molti valori. Il `!` aggiorna il registro base. Usato per restore di stack e trasferimenti bulk.

```assembly
.data
array: .word 10, 20, 30, 40

.text
_start:
    ldr r0, =array         @ punta all'array
    ldm r0, {r1, r2, r3, r4}  @ carica 4 valori consecutivi
    ldm r0!, {r5, r6}      @ carica 2 valori e aggiorna r0
```

#### Store Multiple (stm)

**Sintassi:** `stm registro_base{!}, {lista_registri}` salva multipli registri nella memoria consecutivamente in una sola istruzione.

**Caratteristiche:** complementare a `ldm`. Efficiente per salvare contesto, implementare stack, o trasferimenti bulk di dati.

```assembly
.data
buffer: .space 16          @ riserva 16 bytes

.text
_start:
    mov r1, #10            @ valori da salvare
    mov r2, #20
    mov r3, #30
    mov r4, #40
    ldr r0, =buffer        @ indirizzo di destinazione
    stm r0, {r1, r2, r3, r4}  @ salva 4 registri consecutivamente
```

#### Push (push)

**Sintassi:** `push {lista_registri}` inserisce registri nello stack. Equivale a `stm sp!, {lista_registri}` ma più leggibile.

**Caratteristiche:** automaticamente decrementa stack pointer e salva. Ordine di salvataggio: registro con numero più alto prima.

```assembly
.text
_start:
    mov r1, #10
    mov r2, #20
    push {r1, r2}          @ salva r1 e r2 nello stack
    push {r0-r3, lr}       @ salva range di registri + link register
    @ stack cresce verso il basso, sp aggiornato automaticamente
```

#### Pop (pop)

**Sintassi:** `pop {lista_registri}` estrae registri dallo stack. Equivale a `ldm sp!, {lista_registri}` ma più leggibile.

**Caratteristiche:** automaticamente ripristina e incrementa stack pointer. Deve corrispondere all'ordine di push per funzionare correttamente.

```assembly
.text
funzione:
    push {r4, r5, lr}      @ salva registri all'inizio
    @ ... codice della funzione ...
    pop {r4, r5, pc}       @ ripristina registri e ritorna (pc = lr)
    @ pop di pc causa automaticamente il return
```

### Operatori di Controllo:

#### Branch (b)

**Sintassi:** `b etichetta` salto incondizionato all'etichetta specificata. Cambia il program counter (PC) per continuare l'esecuzione altrove.

**Caratteristiche:** può essere condizionale aggiungendo suffissi (beq, bne, etc.). Range limitato di ±32MB dal punto corrente.

```assembly
.text
_start:
    mov r0, #10
    b fine                 @ salta sempre a 'fine'
    mov r0, #20            @ questa riga non viene mai eseguita
fine:
    mov r7, #1
    swi 0
```

#### Branch with Link (bl)

**Sintassi:** `bl etichetta` chiamata di funzione. Salva indirizzo di ritorno in lr (r14) e salta all'etichetta.

**Caratteristiche:** meccanismo per chiamate di funzione. Il registro lr contiene l'indirizzo per tornare al chiamante con `bx lr`.

```assembly
.text
_start:
    bl mia_funzione        @ chiama funzione, lr = indirizzo di ritorno
    mov r7, #1             @ continua qui dopo il return
    swi 0

mia_funzione:
    mov r0, #42            @ codice della funzione
    bx lr                  @ ritorna al chiamante
```

#### Branch eXchange (bx)

**Sintassi:** `bx registro` salta all'indirizzo contenuto nel registro. Può cambiare instruction set (ARM/Thumb) basato sul bit 0.

**Caratteristiche:** usato principalmente per return da funzioni (`bx lr`) o salti indiretti. Supporta cambio instruction set.

```assembly
.text
funzione:
    @ ... codice ...
    bx lr                  @ return standard usando link register
    
altra_funzione:
    ldr r0, =indirizzo_dinamico
    bx r0                  @ salto indiretto tramite registro
```

#### Branch Link eXchange (blx)

**Sintassi:** `blx registro` combina `bl` e `bx`. Salva indirizzo di ritorno in lr e salta all'indirizzo nel registro.

**Caratteristiche:** per chiamate di funzione indirette o inter-working tra ARM e Thumb. Meno comune di `bl` e `bx` separati.

```assembly
.text
_start:
    ldr r0, =funzione_dinamica  @ carica indirizzo funzione
    blx r0                      @ chiama funzione indirettamente
    @ continua qui dopo return

funzione_dinamica:
    mov r0, #100
    bx lr                       @ ritorna normalmente
```

### Modificatori Condizionali:

**Sintassi:** Suffissi che si aggiungono a qualsiasi istruzione ARM per esecuzione condizionale basata sui flag di stato. Caratteristica unica di ARM che evita molti salti.

**Come funzionano:** Ogni istruzione può essere condizionale aggiungendo un suffisso a 2 lettere. L'istruzione viene eseguita solo se la condizione è vera, altrimenti viene ignorata (NOP).

#### Equal (eq)

**Condizione:** esegue solo se flag Z = 1 (risultato zero). Usato dopo `cmp`, `tst`, operazioni aritmetiche.

```assembly
.text
_start:
    mov r1, #10
    mov r2, #10
    cmp r1, r2             @ confronta r1 con r2
    moveq r0, #1           @ esegue solo se r1 == r2
    movne r0, #0           @ esegue solo se r1 != r2
```

#### Not Equal (ne)

**Condizione:** esegue solo se flag Z = 0 (risultato non zero). Complementare a `eq`.

```assembly
.text
_start:
    mov r1, #5
    tst r1, #1             @ testa se r1 è dispari
    movne r0, #1           @ esegue se bit 0 è impostato (dispari)
    moveq r0, #0           @ esegue se bit 0 è zero (pari)
```

#### Greater Than (gt)

**Condizione:** per numeri con segno, esegue se operando1 > operando2. Usa flag N, Z, V.

```assembly
.text
_start:
    mov r1, #10
    mov r2, #5
    cmp r1, r2             @ confronta 10 con 5
    movgt r0, #1           @ esegue se r1 > r2 (con segno)
    movle r0, #0           @ esegue se r1 <= r2
```

#### Less Than (lt)

**Condizione:** per numeri con segno, esegue se operando1 < operando2. Usa flag N, V.

```assembly
.text
_start:
    mov r1, #-5
    mov r2, #10
    cmp r1, r2             @ confronta -5 con 10
    movlt r0, #1           @ esegue se r1 < r2 (con segno)
    movge r0, #0           @ esegue se r1 >= r2
```

#### Greater or Equal (ge)

**Condizione:** per numeri con segno, esegue se operando1 >= operando2. Complementare a `lt`.

```assembly
.text
_start:
    mov r1, #0
    cmp r1, #0             @ confronta con zero
    movge r0, #1           @ esegue se r1 >= 0 (positivo o zero)
    movlt r0, #0           @ esegue se r1 < 0 (negativo)
```

#### Less or Equal (le)

**Condizione:** per numeri con segno, esegue se operando1 <= operando2. Complementare a `gt`.

```assembly
.text
_start:
    mov r1, #10
    mov r2, #10
    cmp r1, r2             @ confronta valori uguali
    movle r0, #1           @ esegue se r1 <= r2
    movgt r0, #0           @ esegue se r1 > r2
```

#### Carry Set/Higher or Same (cs/hs)

**Condizione:** per numeri senza segno, esegue se carry flag = 1. `hs` significa "higher or same" (>=) per unsigned.

```assembly
.text
_start:
    mov r1, #0xFFFFFFFF    @ valore massimo unsigned
    adds r0, r1, #1        @ addizione che causa overflow
    movcs r2, #1           @ esegue se c'è stato carry (overflow unsigned)
    movcc r2, #0           @ esegue se non c'è stato carry
```

#### Carry Clear/Lower (cc/lo)

**Condizione:** per numeri senza segno, esegue se carry flag = 0. `lo` significa "lower" (<) per unsigned.

```assembly
.text
_start:
    mov r1, #5
    mov r2, #10
    cmp r1, r2             @ confronta 5 con 10 (unsigned)
    movlo r0, #1           @ esegue se r1 < r2 (unsigned)
    movhs r0, #0           @ esegue se r1 >= r2 (unsigned)
```

## Espressioni condizionali

**Filosofia ARM:** ARM permette di rendere condizionale qualsiasi istruzione aggiungendo suffissi di 2 lettere. Questo elimina molti salti condizionali, rendendo il codice più efficiente e lineare.

**Meccanismo:** ogni istruzione controlla i flag di stato (Z, N, C, V) impostati da operazioni precedenti. Se la condizione è falsa, l'istruzione diventa NOP (no operation) senza perdere cicli di clock.

**Flag di stato:** ARM usa 4 flag principali nel registro CPSR. **Z (Zero)** si attiva quando il risultato è zero. **N (Negative)** indica risultato negativo (bit 31 = 1). **C (Carry)** segnala overflow in operazioni unsigned. **V (Overflow)** rileva overflow in operazioni signed. Questi flag vengono impostati automaticamente da istruzioni di confronto (`cmp`, `tst`) e operazioni aritmetiche con suffisso 'S' (`adds`, `subs`).

### If-Then semplice

**Pattern classico:** confronto + istruzione condizionale. Sostituisce `if (condizione) azione;` del C.

```assembly
.text
_start:
    mov r1, #10            @ valore da testare
    cmp r1, #5             @ confronta con 5
    movgt r0, #1           @ se r1 > 5 allora r0 = 1
    movle r0, #0           @ se r1 <= 5 allora r0 = 0
    @ Risultato: r0 = 1 perché 10 > 5
```

### If-Then-Else

**Doppia condizione:** usa condizioni complementari per coprire entrambi i casi.

```assembly
.text
_start:
    mov r1, #3             @ numero da classificare
    tst r1, #1             @ testa se bit 0 è impostato (dispari)
    movne r0, #1           @ se dispari: r0 = 1
    moveq r0, #0           @ se pari: r0 = 0
    @ Risultato: r0 = 1 perché 3 è dispari
```

### Condizioni Multiple (AND logico)

**Tecnica:** combina più confronti dove tutti devono essere veri. Usa flag accumulati.

```assembly
.text
_start:
    mov r1, #15            @ valore da testare
    @ Verifica se r1 è tra 10 e 20 (10 <= r1 <= 20)
    cmp r1, #10            @ confronta con limite inferiore
    cmpge r1, #20          @ se >= 10, confronta anche con limite superiore
    movle r0, #1           @ se entrambe vere: r0 = 1 (nel range)
    movgt r0, #0           @ se seconda falsa: r0 = 0 (fuori range)
    @ Risultato: r0 = 1 perché 10 <= 15 <= 20
```

### Condizioni Multiple (OR logico)

**Tecnica:** verifica condizioni separate, qualsiasi può essere vera.

```assembly
.text
_start:
    mov r1, #25            @ valore da testare
    @ Verifica se r1 < 10 OR r1 > 20
    cmp r1, #10
    movlt r0, #1           @ se < 10: r0 = 1
    cmp r1, #20            @ secondo confronto indipendente
    movgt r0, #1           @ se > 20: r0 = 1 (sovrascrive eventuale 0)
    @ Se nessuna condizione: r0 mantiene valore precedente
    @ Risultato: r0 = 1 perché 25 > 20
```

### Switch-Case con Tabella di Salto

**Pattern avanzato:** usa tabella di indirizzi per switch multiway. Molto efficiente per molti casi.

```assembly
.data
jump_table:
    .word caso_0, caso_1, caso_2, caso_default

.text
_start:
    mov r1, #1             @ valore dello switch
    cmp r1, #3             @ verifica range valido
    bge default            @ se >= 3, vai al default
    ldr r0, =jump_table    @ carica indirizzo tabella
    ldr r0, [r0, r1, lsl #2]  @ carica indirizzo caso (r1 × 4)
    bx r0                  @ salta al caso appropriato

caso_0:
    mov r0, #100           @ azione per caso 0
    b fine
caso_1:
    mov r0, #200           @ azione per caso 1
    b fine
caso_2:
    mov r0, #300           @ azione per caso 2
    b fine
default:
    mov r0, #0             @ azione default
fine:
    @ r0 contiene il risultato del switch
```

### Loop con Condizione (While)

**Pattern:** combina decremento e test in una istruzione per loop efficienti.

```assembly
.text
_start:
    mov r1, #5             @ contatore loop
    mov r0, #0             @ accumulatore
loop:
    add r0, r0, r1         @ somma contatore ad accumulatore
    subs r1, r1, #1        @ decrementa e imposta flag
    bne loop               @ continua se r1 != 0
    @ Risultato: r0 = 5+4+3+2+1 = 15
```

### Condizione con Funzione Complessa

**Esempio realistico:** implementa `max(a, b, c)` usando solo istruzioni condizionali.

```assembly
.text
trova_massimo:
    @ Parametri: r0=a, r1=b, r2=c
    @ Ritorna: r0=max(a,b,c)
    
    cmp r0, r1             @ confronta a con b
    movlt r0, r1           @ se a < b: r0 = b (nuovo candidato max)
    
    cmp r0, r2             @ confronta candidato con c
    movlt r0, r2           @ se candidato < c: r0 = c (nuovo max)
    
    bx lr                  @ ritorna con massimo in r0

_start:
    mov r0, #15            @ a = 15
    mov r1, #8             @ b = 8  
    mov r2, #23            @ c = 23
    bl trova_massimo       @ chiama funzione
    @ Risultato: r0 = 23 (il massimo)
```

**Vantaggi delle espressioni condizionali ARM:**
- **Efficienza:** elimina salti che interrompono la pipeline
- **Compattezza:** codice più denso e leggibile
- **Flessibilità:** qualsiasi istruzione può essere condizionale
- **Performance:** meno branch prediction failures

## Cicli

Questa sezione mostra i pattern più usati per implementare loop in ARM: while, for-like, do-while e iterazioni su array. ARM non ha istruzioni high-level per i cicli: si combinano decrementi/confronti e branch condizionali per ottenere loop efficienti.

### While (condizione in testa)

Pattern classico: compara prima e salta fuori dal loop se la condizione è falsa.

```assembly
.text
_start:
    mov r1, #5       @ contatore
    mov r0, #0       @ accumulatore
while_loop:
    cmp r1, #0
    beq end_while    @ esci se r1 == 0
    add r0, r0, r1   @ corpo del loop
    sub r1, r1, #1   @ decrementa
    b while_loop
end_while:
    @ r0 = 5+4+3+2+1 = 15
```

### For-like (contatore up)

Usa `cmp` + `bge` per limitare il range; più leggibile quando si incrementa.

```assembly
.text
_start:
    mov r0, #0       @ i = 0
    mov r1, #10      @ limite (esclusivo)
for_loop:
    cmp r0, r1
    bge end_for
    @ corpo: ad esempio somma i
    add r2, r2, r0
    add r0, r0, #1   @ i++
    b for_loop
end_for:
    @ r2 contiene la somma 0..9
```

### Do-While (condizione in coda)

Esegui il corpo e poi controlla la condizione alla fine.

```assembly
.text
_start:
    mov r1, #3
    mov r0, #0
do_loop:
    add r0, r0, #1   @ corpo
    subs r1, r1, #1  @ decrementa e imposta flag
    bne do_loop      @ ripeti se r1 != 0
    @ r0 = 3
```

Nota: `subs` è spesso preferito perché combina sottrazione e aggiornamento flag in un'unica istruzione.

### Iterare su un array

Esempio: somma N elementi usando indirizzamento post-incremento.

```assembly
.data
array: .word 5,10,15,20
N:     .word 4

.text
_start:
    ldr r0, =array    @ r0 = indirizzo base
    ldr r1, =N
    ldr r1, [r1]      @ r1 = N
    mov r2, #0        @ somma
loop_arr:
    cmp r1, #0
    beq end_arr
    ldr r3, [r0], #4  @ carica e post-incrementa indirizzo
    add r2, r2, r3
    subs r1, r1, #1
    bne loop_arr
end_arr:
    @ r2 = somma degli elementi
```

### Loop annidati e performance

- Preferisci `subs`/`adds` quando possibile per aggiornare il contatore e i flag in un'unica istruzione.
- Evita branch condizionali costosi dentro il corpo del loop; cerca di spostare le condizioni alla testa o in coda.
- Quando iteri molti dati, usa `ldm`/`stm` per trasferimenti bulk se l'allineamento e l'ordine lo permettono.
