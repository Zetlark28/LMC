(defun one-instruction (state)
  (cond ((null state) nil)
  	((eq (nth 0 state) 'halted-state) nil)
        ((= (which-instruction state) 1) (add state))
        ((= (which-instruction state) 2) (sub state))
        ((= (which-instruction state) 3) (store state))
        ((= (which-instruction state) 5) (load1 state))
        ((= (which-instruction state) 6) (branch state))
        ((= (which-instruction state) 7) (branch-if-zero state))
        ((= (which-instruction state) 8) (branch-if-pos state))
        ((= (which-instruction state) 0) (halt state))
        ((= (nth (nth 4 state) (nth 6 state)) 901) (input state))
        ((= (nth (nth 4 state) (nth 6 state)) 902) (output state))

 (T nil)))
    
(defun incrementa-pc (pc)
  (cond ((< pc 99) (+ pc 1 ))
  (T 0)))
                     
(defun which-instruction (state)
  (floor (nth (nth 4 state) (nth 6 state)) 100))

(defun mem-instruction (state)
  (mod (nth (nth 4 state) (nth 6 state)) 100))


(defun add (state)
	(cond 	((> (+ (nth 2 state) (nth (mem-instruction state) (nth 6 state))) 1000)
				(list 'STATE 
	         		:acc (mod (+ (nth 2 state) (nth (mem-instruction state) (nth 6 state))) 1000)
				:pc (incrementa-pc (nth 4 state))
				:mem (nth 6 state)
				:in (nth 8 state)
				:out (nth 10 state)
				:flag 'flag))

                      (T (list 'STATE 
	                 :acc (+ (nth 2 state) (nth (mem-instruction state) (nth 6 state)))
                         :pc (incrementa-pc (nth 4 state))
                         :mem (nth 6 state)
	                 :in (nth 8 state)
	                 :out (nth 10 state)
	                 :flag 'noflag))))


(defun sub (state)
         (cond ((< (- (nth (mem-instruction state) (nth 6 state)) (nth 2 state)) 0)
               (list 'STATE 
               :acc (+ (- (nth (mem-instruction state) (nth 6 state)) (nth 2 state)) 1000)
               :pc (incrementa-pc (nth 4 state))
               :mem (nth 6 state)
               :in (nth 8 state)
               :out (nth 10 state)
               :flag 'flag ))

         (T (list 'STATE 
            :acc (- (nth (mem-instruction state) (nth 6 state)) (nth 2 state))
            :pc (incrementa-pc (nth 4 state)) 
            :mem (nth 6 state)
            :in (nth 8 state)
            :out (nth 10 state)
            :flag (nth 12 state))))) 

(defun branch (state)
  (list 'STATE
  :acc (nth 2 state)
  :pc  (mem-instruction state)
  :mem (nth 6 state)
  :in (nth 8 state)
  :out (nth 10 state)
  :flag (nth 12 state)))

(defun branch-if-pos (state)
 (cond ((and (>= (nth 2 state) 0) (eq (nth 12 state) 'noflag))(branch state))
     (T(list 'STATE 
     :acc (nth 2 state)
     :pc (incrementa-pc (nth 4 state))
     :mem (nth 6 state)
     :in (nth 8 state)
     :out (nth 10 state)
     :flag (nth 12 state)))))

(defun branch-if-zero (state)
 (cond ((= (nth 2 state) 0) (branch state))
  (T(list 'STATE 
  :acc (nth 2 state)
  :pc (incrementa-pc (nth 4 state))
  :mem (nth 6 state)
  :in (nth 8 state)
  :out (nth 10 state)
  :flag (nth 12 state)))))

(defun halt (state) 
   (list 'HALTED-STATE
   :acc (nth 2 state)
   :pc (incrementa-pc (nth 4 state)) 
   :mem (nth 6 state)
   :in (nth 8 state)
   :out (nth 10 state)
   :flag (nth 12 state)))

(defun store (state) 
   (list 'STATE
   :acc (nth 2 state)
   :pc (incrementa-pc (nth 4 state))
   :mem (replace1 state)
   :in (nth 8 state)
   :out (nth 10 state)
   :flag (nth 12 state)))

(defun replace1 (state)
  (setf (nth (mem-instruction state) (nth 6 state)) (nth 2 state))
  (nth 6 state))
 
(defun load1 (state)
    (list 'STATE 
    :acc (nth (mem-instruction state) (nth 6 state))
    :pc (incrementa-pc (nth 4 state))
    :mem (nth 6 state)
    :in (nth 8 state)
    :out (nth 10 state)
    :flag (nth 12 state)))

(defun input (state)
 (list 'STATE
 :acc (car (nth 8 state))
 :pc (incrementa-pc (nth 4 state))
 :mem (nth 6 state)
 :in  (cdr (nth 8 state))
 :out (nth 10 state)
 :flag (nth 12 state)))

(defun output (state)
  (list 'STATE 
  :acc (nth 2 state)
  :pc (incrementa-pc (nth 4 state))
  :mem (nth 6 state)
  :in (nth 8 state)
  :out (append (nth 10 state) (list (nth 2 state)))
  :flag (nth 12 state)))

(defun execution-loop (state) 
 (cond ((eq (nth 0 state) 'halted-state) (nth 10 state))
       ((null state) nil)
       (T (execution-loop(one-instruction state)))))



(defun lmc-run (Filename In) 
    (execution-loop (list 'STATE
                    :acc 0
                    :pc  0
                    :mem (lmc-load Filename)
                    :in In
                    :out ()
                    :flag 'noflag)))

(defun lmc-load (Filename)
  (let ((nuovamemoria (nuova-lista (lmc-open Filename))))
    (let ((listaetichette (etichette nuovamemoria)))
      (riempi-memoria 
       (istruzione 
        (elimina-etichette nuovamemoria listaetichette) listaetichette)))))

(defun lmc-open (file)
  (with-open-file (in file
                        :direction :input
                        :if-does-not-exist :error)
    (crea-lista in)))

(defun crea-lista (input-stream)
  (let ((e (read-line input-stream nil 'eof)))
    (unless (eq e 'eof)
      (append (list e) (crea-lista input-stream)))))

(defun upper (line)
  (string-upcase
   (string-trim '(#\Space #\Newline #\Tab)
                (elimina-commenti line))))

(defun elimina-commenti (line)
  (subseq line 0 (search "//" line)))

(defun elimina-riga-vuota (lista)
  (cond ((null lista) nil)
        ((equal (car lista) "")
         (elimina-riga-vuota (cdr lista)))
        (T (cons (car lista) (elimina-riga-vuota (cdr lista))))))

(defun nuova-lista (vecchialista)
  (let ((nuovalista (mapcar 'upper vecchialista)))
    (elimina-riga-vuota nuovalista)))

(defun etichette (lista)
  (cond ((null lista) nil)
        ((eql (find (read-from-string(car lista))
                    '(ADD SUB STA LDA BRA BRZ BRP INP OUT HLT DAT)
                    :test #'equal) NIL)
         (cons (read-from-string (car lista)) (etichette (cdr lista))))
        (T (cons 0 (etichette (cdr lista))))))

(defun elimina-etichette (memoria etichetta)
  (cond ((null memoria) nil)
        ((equal (find (read-from-string (car memoria)) etichetta)
              (read-from-string (car memoria)))
         (cons (string-trim '(#\Space #\Newline #\Tab)
                           (subseq (car memoria) (search " " (car memoria))))
               (elimina-etichette (cdr memoria) etichetta)))
        (T (cons (car memoria) (elimina-etichette (cdr memoria) etichetta)))))


(defun etichetta-scelta (string etichetta)
  (if (numberp (read-from-string string))
      (parse-integer string)
    (if (eql (find (read-from-string string) etichetta :test #'equal) NIL)
        (progn) 
      (position (read-from-string string) etichetta))))


(defun riempi-memoria (memoria)
  (append memoria(make-list (- 100 (length memoria)) :initial-element 0)))


(defun istruzione (memoria etichetta)
  (cond ((null memoria) nil)
    
    ((equal (read-from-string (car memoria)) 'ADD)
     (cons (+ 100 (etichetta-scelta (string-trim '(#\Space #\Newline #\Tab)
                        (subseq (car memoria) (search " " (car memoria)))) etichetta))
           (istruzione (cdr memoria) etichetta)))
    
    ((equal (read-from-string (car memoria)) 'SUB)
     (cons (+ 200 (etichetta-scelta (string-trim '(#\Space #\Newline #\Tab)
                        (subseq (car memoria) (search " " (car memoria)))) etichetta))
           (istruzione (cdr memoria) etichetta)))
    
    ((equal (read-from-string (car memoria)) 'STA)
     (cons (+ 300 (etichetta-scelta (string-trim '(#\Space #\Newline #\Tab)
                        (subseq (car memoria) (search " " (car memoria)))) etichetta))
           (istruzione (cdr memoria) etichetta)))
    
    ((equal (read-from-string (car memoria)) 'LDA)
     (cons (+ 500 (etichetta-scelta (string-trim '(#\Space #\Newline #\Tab)
                        (subseq (car memoria) (search " " (car memoria)))) etichetta))
           (istruzione (cdr memoria) etichetta)))
   
    ((equal (read-from-string (car memoria)) 'BRA)
     (cons (+ 600 (etichetta-scelta (string-trim '(#\Space #\Newline #\Tab)
                        (subseq (car memoria) (search " " (car memoria)))) etichetta))
           (istruzione (cdr memoria) etichetta)))
    
    ((equal (read-from-string (car memoria)) 'BRZ)
     (cons (+ 700 (etichetta-scelta (string-trim '(#\Space #\Newline #\Tab)
                        (subseq (car memoria) (search " " (car memoria)))) etichetta))
           (istruzione (cdr memoria) etichetta)))
    
    ((equal (read-from-string (car memoria)) 'BRP)
     (cons (+ 800 (etichetta-scelta (string-trim '(#\Space #\Newline #\Tab)
                        (subseq (car memoria) (search " " (car memoria)))) etichetta))
           (istruzione (cdr memoria) etichetta)))
    
    ((equal (read-from-string (car memoria)) 'INP)
     (cons 901 (istruzione (cdr memoria) etichetta)))
    
    ((equal (read-from-string (car memoria)) 'OUT)
     (cons 902 (istruzione (cdr memoria) etichetta)))
    
    ((equal (read-from-string (car memoria)) 'HLT)
     (cons 000 (istruzione (cdr memoria) etichetta)))
    
    ((equal (read-from-string (car memoria)) 'DAT)
     (if (equal (string-trim '(#\Space #\Newline #\Tab) (car memoria)) "DAT")
       (cons 000 (istruzione (cdr memoria) etichetta))
       (cons (parse-integer (string-trim '(#\Space #\Newline #\Tab)
                          (subseq (car memoria) (search " " (car memoria)))))
             (istruzione (cdr memoria) etichetta))))

    (T (cons (car memoria) (elimina-etichette (cdr memoria) etichetta)))))
