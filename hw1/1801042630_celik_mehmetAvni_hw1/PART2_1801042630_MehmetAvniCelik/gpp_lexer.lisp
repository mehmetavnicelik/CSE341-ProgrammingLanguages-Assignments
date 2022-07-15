;1801042630
;Mehmet Avni Celik

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun read-file (filename)
	(concatenate 'string 
		(with-open-file (stream filename)
			(loop for line = (read-char stream nil)
				while line
				collect line
			)
		)
	)
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun is-it-operator (op) 
	(setf op_list 
		(list 
			"+" 
			"-" 
			"/" 
			"(" 
			"*" 
			")" 
			"**"
		)
	)
	(reduce #'(lambda (x y) (or x (equal op y))) op_list :initial-value nil)
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun is-it-keyword (key) 
	(setf keywords (list "and" "or" "not" "less" "nil" "list" 
			"equal" "append" "concat" "load"
			"set" "deffun" "for" "disp" "true" "false"
			"if" "exit")
	)
	(reduce #'(lambda (x y) (or x (equal key y))) keywords :initial-value nil)
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun is-it-integer (integer)

	(setq letters "0123456789-.")
	(setq result t)

	(if (< 0 (length integer))
		(loop for c across integer do
			(if (not (position c letters))
				(setq result nil)
			)
		)
		(setq result nil)
	)
	result
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun is-it-id (identifiers)
	(setq letters "abcdefghijklmnopqrstuvwxyz
			ABCDEFGHIJKLMNOPRSTUVWXYZQ"
	)
	(setq outcome  t)
	(if (< 0 (length identifiers))
		(loop for c across identifiers do
			(if (not (position c letters))
				(setq outcome nil)
			)
		)
		(setq outcome nil)
	)
	outcome
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun DFA (dfa-input)
	(cond
		((equal "**" dfa-input) "OP_DBLMULT")
		((equal "-" dfa-input)  "OP_MINUS")
		((equal "+" dfa-input)  "OP_PLUS")
		((equal "*" dfa-input)  "OP_MULT")
		((equal "/" dfa-input)  "OP_DIV")
		((equal "(" dfa-input)  "OP_OP")
		((equal ")" dfa-input)  "OP_CP")
		((equal "," dfa-input)  "OP_COMMA")
		((equal "\"" dfa-input) "OP_OC")
		((is-it-keyword dfa-input)  (concatenate 'string "KW_" (string-upcase dfa-input)) )
		((is-it-id dfa-input)  "IDENTIFIER")
		((is-it-integer dfa-input)  "VALUE" )
		;((not (is-it-id dfa-input)) "SYNTAX_ERROR")  ------->>SYNTAX_ERROR liste cannot be tokenized
		(t nil)
	)
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun gppinterpreter (codes)
	(defvar temp "")
	(defvar token nil)
	(defvar instruction "")
	(defvar inst1 nil)
	(defvar inst2 nil)

	(loop for c across codes do
		(cond ((or (equal inst1 T)(char= #\; c ))
				(setq inst1 T)
				(cond  ((or (equal inst2 T)(char= #\; c ))
						(setq inst2 T)
						(cond ((not(char= c #\Newline)) ;takes until EOL
							(setq instruction (concatenate 'string instruction (string c))))
							(t (setq inst1 nil)(setq inst2 nil)
							(setq token (append token '("COMMENT"))))))))
		)
		(if (and (is-it-operator (string c)) (not(equal inst1 T)))
				(cond ((DFA temp)
					(setq token (append token (list (DFA temp)))) 
					(setq temp "")))
		)
		(if (and (not (or (char= c #\Space) (char= c #\Newline) (char= c #\Tab)))(not(equal inst1 T)))
			(setq temp (concatenate 'string temp (string c)))
		)
		(if (and (or (is-it-operator (string c)) (char= c #\Space) (char= c #\Newline) (char= c #\Tab)) (not(equal inst1 T)))
			(cond ((DFA temp)
				(setq token (append token (list (DFA temp))))
				(setq temp ""))
			)
		)	
	)
	(if (< 0 (length temp))
		(cond ((DFA temp)
			(setq token (append token (list (DFA temp)))))
		)
	)
	(with-open-file (out_file "lispResult.txt" :direction :output)
		(format out_file (write-to-string token))
	)
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun reply ()
	(loop
		(print "$> ")
		(setq line (read-line))
		(if (not (string= line ""))
			(mapcar 'write-line (gppinterpreter line))
		)
		(when (string= line "")(return 0))
	)
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun begin ()
	(defvar filename NIL)
	(if (= 1 (length *args*))
		(setq filename (nth 0 *args*))
	)
	(if (not filename)
		(reply)
		(mapcar 'write-line (gppinterpreter  (read-file filename)))
	)
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun end ()
	(format t "CHECK OUT THE 'lispResult.txt' FILE")
	(terpri)
	(format t "END OF THE PROGRAM,")
	(format t "THANK YOU!")
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(begin)
(end)
