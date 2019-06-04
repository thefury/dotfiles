;; needs to be set ahead of the package require
(setq evil-toggle-key "C-`")

(use-package evil
  :ensure t
  :config
  (evil-mode 1))

(provide 'setup-evil)
