
;; Package configs
(require 'package)
(setq package-enable-at-startup nil)
(setq package-archives '(("org"   . "http://orgmode.org/elpa/")
                         ("gnu"   . "http://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))
(package-initialize)
;; Bootstrap `use-package`
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)

(add-to-list 'load-path (expand-file-name "site-lisp" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "plugins" user-emacs-directory))


;; Core Setup
(require 'setup-core)
(require 'setup-elisp)
(require 'setup-appearance)


;; Additional Packages
(require 'setup-evil)
(require 'setup-magit)
(require 'setup-projects)
(require 'setup-org)
(require 'setup-elfeed)
(require 'setup-terraform)
(require 'setup-golang)
(require 'setup-ruby)


;; clojure
;;p((
;;   (
;;p(use-package go-mode :ensure t
;;  :config
;;  (progn
;;    (add-hook 'before-save-hook 'gofmt-before-save)
;;    (add-hook 'go-mode-hook (lambda ()
;;			      (local-set-key (kbd "C-c C-r") 'go-remove-unused-imports)))))
;;
;;(provide 'setup-golang)
;;

(use-package cider)
(use-package clojure-mode)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (org-journal ## cider ag magit use-package terraform-mode projectile go-mode exec-path-from-shell evil elfeed-web elfeed-org doom-themes))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(add-to-list 'load-path
              "~/.emacs.d/plugins/yasnippet")
(require 'yasnippet)
(yas-global-mode 1)
