
;; remove all byte-compiled files form emacs directory
;; reload init.el
;; add a global for it? or just a name

(defun fury/delete-byte-compiled-files ()
  (interactive))

(defun fury/reload-emacs ()
  (interactive)
  (byte-recompile-directory (expand-file-name "~/.emacs.d") 0)
  (load-file user-init-file))


(provide 'setup-elisp)
