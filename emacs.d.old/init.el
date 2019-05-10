(setq package-enable-at-startup nil)
(setq package-archives '(
                         ("org"       . "http://orgmode.org/elpa/")
			 ("gnu"       . "http://elpa.gnu.org/packages/")
			 ("melpa"     . "https://melpa.org/packages/")))
(package-initialize)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)

(add-to-list 'load-path (expand-file-name "site-lisp" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "plugins" user-emacs-directory))
;;(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
;; '(package-selected-packages
;;   (quote
;;    (helm-dash helm-swoop helm-css-scss helm-ag helm projectile time-ext spaceline rainbow-mode rainbow-delimiters kaolin-themes evil-exchange evil-args expand-region evil-lisp-state evil-surround evil-numbers evil exec-path-from-shell s ;;restart-emacs diminish hydra use-package))))
;;(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
;; )


;; Core Stuff
(require 'setup-core)
(require 'setup-os)
(require 'setup-evil)
(require 'setup-appearance)

;; More stuff
(require 'setup-projects)
(require 'setup-helm)
(require 'setup-helm-dash)
(require 'setup-org)
(require 'setup-files)
(require 'defuns-org)
(require 'setup-hashicorp)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (helm-dash helm-swoop helm-css-scss helm-ag helm projectile use-package time-ext terraform-mode spaceline restart-emacs rainbow-mode rainbow-delimiters popup pkg-info kaolin-themes hydra helm-core expand-region exec-path-from-shell evil-surround evil-numbers evil-lisp-state evil-exchange evil-args diminish))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
