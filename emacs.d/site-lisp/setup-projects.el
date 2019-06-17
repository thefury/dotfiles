(use-package projectile
  :ensure t
  :init
  :config
  (projectile-global-mode)
  (setq projectile-project-search-path '("~/dev"))
  (define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map))

(provide 'setup-projects)
