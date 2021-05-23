(require 'subr-x)
(require 'cl)
(let ((self-path (or load-file-name buffer-file-name)))
  (message "self-path is %s" self-path)
  (load (concat (file-name-directory self-path) "../lua-mode.el")))

(defun indentation-keeps-p (contents)
  (with-temp-buffer
    (let ((lua-mode-hook '()))
      (insert contents)
      (lua-mode)
      (set-buffer-modified-p nil)
      (indent-region (point-min) (point-max))
      (not (buffer-modified-p)))))

(ert-deftest indents-continued-line ()
  (should
   (indentation-keeps-p
    (string-join
     '("local a = "
       "   1 + 2"
       "this_is_new_line"
       ) "\n")))
  )

(ert-deftest block-opener-at-the-end ()
  (should
   (indentation-keeps-p
    (string-join
     '("local a = function ()"
       "   1 + 2"
       "end"
       "this_is_new_line"
       ) "\n")))
  )

(ert-deftest multiple-blocks ()
  (should
   (indentation-keeps-p
    (string-join
     '("local a = ("
       "   1 + 2"
       ") + ("
       "   3 + 4"
       ") + {"
       "   5 + 6"
       "} + ("
       "   7 + 8"
       ")"
       "this_is_new_line"
       ) "\n")))
  )

(ert-deftest multiple-blocks ()
  (should
   (indentation-keeps-p
    (string-join
     '("local a = ("
       "   1 + 2"
       ") + {"
       "   3 + 4"
       "} + ("
       "   5 + 6"
       ")"
       "this_is_new_line"
       ) "\n")))
  )

(ert-deftest multiple-blocks-after-continuing-statement ()
  (should
   (indentation-keeps-p
    (string-join
     '("local a ="
       "   ("
       "      1 + 2"
       "   ) + {"
       "      3 + 4"
       "   }"
       "   + ("
       "      5 + 6"
       "   )"
       "this_is_new_line"
       ) "\n")))
  )
