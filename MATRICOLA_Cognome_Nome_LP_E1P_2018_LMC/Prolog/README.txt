Al progetto ha partecipato:
-Clark Ezpeleta               837002 
-Sad Rafik                    816920
-Alessio Cottarelli 

Il programma è un simulatore di un computer ad istruzioni.
Il programma viene avviato dando in input un file assembly che verrà decodificato in codice macchina,
e ciò costituirà la memoria di istruzioni che il simulatore dovrà eseguire, dando come output il risultato 
finale dopo aver eseguito tutte le istruzioni.

Predicati aggiunti:

control_el= per controllare se gli elementi del input, output e memoria non superano 999

control_flag= per controllare che ci sia scritto o flag o noflag

update_pc= per incrementare il pc e nel caso supera 100 ritorna a zero

replace_el= per cambiare un solo elemento della lista

head_tail= per individuare il primo elemento e la coda di una lista

memory_control= nel caso il file assembly non abbia dato 100 istruzioni, aggiunge gli 0 finchè non ho 100 elementi

parser= avvia l'analisi del file assembly

delete_comment_line= elimina tutte le righe di solo commento

delete_comment= elimina i commenti affianco le istruzioni

delete= predicato usato in delete_comment

analize_string= analizza l'istruzione in formato assembly e restituisce il codice macchina corrispondente

search_value= trova il valore di una etichetta

type_instruction= identifica che tipo di istruzione è, e restituisce il suo codice

type_instruction_one= identifica che tipo di istruzione è, e restituisce il suo codice





