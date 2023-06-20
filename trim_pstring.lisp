#!/usr/bin/sbcl --script

#|
Intellectual property information START

Copyright (c) 2023 Ivan Bityutskiy

Permission to use, copy, modify, and distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

Intellectual property information END

Description START

The script trims the input string to a desirable length.
Modify *default-output-string-length* variable to change desirable output string length.

Usage:
clisp trim_pstring.lisp
sbcl --script trim_pstring.lisp
ccl64 -l trim_pstring.lisp -e '(quit)'

Description END
|#

(defparameter *default-output-string-length* 124)

(format t "~%Output string length (1..=~d): " *default-output-string-length*)
(finish-output)

(defparameter *output-string-length*
  (parse-integer (read-line) :junk-allowed t)
) ; defparameter *output-string-length* END

(and
  (or
    (null *output-string-length*)
    (< *output-string-length* 1)
    (> *output-string-length* *default-output-string-length*)
  ) ; or END
  (setf *output-string-length* *default-output-string-length*)
) ; and END

(format t "Input string:~%")
(loop
  repeat *output-string-length*
  do (princ #\Z)
) ; loop END
(terpri)
(finish-output)

(defparameter *the-input-string*
  (read-line)
) ; defparameter *the-input-string* END

(setf *output-string-length*
  (min
    *output-string-length*
    (length *the-input-string*)
  ) ; min END
) ; setf END

(format
  t
  "~%~a~%~%"
  (subseq
    *the-input-string*
    0
    *output-string-length*
  ) ; subseq END
) ; format END

