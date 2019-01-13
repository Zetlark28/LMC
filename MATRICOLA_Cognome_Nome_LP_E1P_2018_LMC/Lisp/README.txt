Al progetto ha partecipato:
-Clark Ezpeleta               837002 
-Sad Rafik                    816920
-Alessio Cottarelli 

Il programma è un simulatore di un computer ad istruzioni.
Il programma viene avviato dando in input un file assembly che verrà decodificato in codice macchina,
e ciò costituirà la memoria di istruzioni che il simulatore dovrà eseguire, dando come output il risultato 
finale dopo aver eseguito tutte le istruzioni.

Funzioni aggiunte:

incrementa-pc = aggiorna il pc incrementandolo di uno,  quando arriva a 100 il pc vale 0

wich-instruction= serve ad identificare il tipo di istruzione

mem-instruction= serve ad identificare il valore all'interno dell'istruzione

replace1 =serve a cambiare un elemento di una lista



Metodi utilizzati nel parser:

open-file: serve per aprire il file

crea-lista: legge il file, e ne crea una lista

nuova-lista: prende come argomento la lista creata, con il metodo "maiuscolo" traforma tutte le stringhe in maiuscolo. Il metodo                        "maiuscolo" inoltre elimina le righe identificate da "//" come commenti e che non andranno lette. Infine è presente un ultimo              metodo chiamato "elimina-riga-vuota" che serve per l'appunto ad eliminare le righe che non contengono stringhe.

etichette: riconosce le keywords del file

riempi-memoria: riempe la memoria con degli zeri se essa è composta da meno di 100 elementi

istruzione: fa corrispondere ad ogni etichetta, la relativa istruzione

