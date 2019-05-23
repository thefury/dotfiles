(use-package projectile
  :ensure t
  :init
  (setq projectile-require-project-root nil)
  :config
  (projectile-mode 1)
  (setq projectile-project-search-path '("~/dev")))

(provide 'setup-projects)
