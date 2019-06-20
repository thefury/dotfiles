(use-package go-mode :ensure t
  :config
  (progn
    (add-hook 'before-save-hook 'gofmt-before-save)
    (add-hook 'go-mode-hook (lambda ()
			      (local-set-key (kbd "C-c C-r") 'go-remove-unused-imports)))))

(provide 'setup-golang)