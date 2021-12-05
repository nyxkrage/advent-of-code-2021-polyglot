(defun occurrences (list &aux result)
  (mapc (lambda (item &aux (pair (assoc item result)))
          (if pair
              (incf (cdr pair))
            (push (cons item 1) result)))
        list)
  (sort result #'> :key #'cdr))

(defun oxygen-prio (result)
  (if (equal (length result) 1)
      result
      (if (and (equal (cdr (elt result 0)) (cdr (elt result 1))) (equal (car (elt result 0)) #\0))
          (reverse result)
          result)))


(defun get-file (filename)
  (with-open-file (stream filename)
    (loop for line = (read-line stream nil)
          while line
          collect line)))

(defun get-string-chars (input index)
    (loop for element in input
        collect (char element index)))

(defun invert-bits(n)
  (if (> n 0)
      (logxor (1- (expt 2 (integer-length n))) n)
      0))

(defvar input (get-file "input"))

(defun part1 ()
  (let ((gamma
          (let ((num-size (length (nth 0 input))))
            (parse-integer
             (concatenate
              'string
              (loop for index from 0 below num-size
                    collect (car
                             (elt
                              (occurrences (get-string-chars input index))
                              0))))
             :radix 2))))
    (format t "~d~%" (* gamma (invert-bits gamma)))))

(defun remove-oxygen (input depth)
  (if (equal (length input) 1)
      input
      (remove-oxygen (remove-if-not (lambda (x) (equal (car (elt (oxygen-prio (occurrences (get-string-chars input depth))) 0)) (char x depth))) input) (+ depth 1))
    ))

(defun remove-co2 (input depth)
  (if (equal (length input) 1)
      input
      (remove-co2 (remove-if (lambda (x) (equal (car (elt (oxygen-prio (occurrences (get-string-chars input depth))) 0)) (char x depth))) input) (+ depth 1))
    ))

(format t "~A~%" (* (parse-integer (car (remove-oxygen input 0)) :radix 2) (parse-integer (car (remove-co2 input 0)) :radix 2)))
