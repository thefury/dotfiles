(use-package go-mode :ensure t
  :config
  (defun fury-go-mode-hook ()
    (add-hook 'before-save-hook 'gofmt-before-save)
    (setq gofmt-command "goimports")
    (setq indent-tabs-mode t)
    (setq tab-width 4))
  (progn
    (add-hook 'go-mode-hook 'fury-go-mode-hook)))

(provide 'setup-golang)
