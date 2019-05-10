(defvar fury/is-mac (equal system-type 'darwin))
(defvar fury/is-linux (equal system-type 'gnu/linux))

(use-package exec-path-from-shell :ensure t
  :commands (exec-path-from-shell-initialize)
  :init
  (when (memq window-system '(mac ns))
    (exec-path-from-shell-initialize)))

(setq show-paren-delay 0)
(show-paren-mode 1)

(let ((path (shell-command-to-string ". ~/.bashrc; echo -n $PATH")))
  (setenv "PATH" path)
  (setq exec-path
        (append
         (split-string-and-unquote path ":")
         exec-path)))


(provide 'setup-core)
