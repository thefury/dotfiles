
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
(require 'setup-projects)
(require 'setup-org)
(require 'setup-terraform)
(require 'setup-golang)
(require 'setup-ruby)




(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (terraform-mode use-package projectile exec-path-from-shell evil doom-themes))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
