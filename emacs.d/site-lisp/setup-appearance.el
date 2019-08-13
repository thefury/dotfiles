
;; Minimal UI
(scroll-bar-mode -1)
(tool-bar-mode   -1)
(tooltip-mode    -1)
(setq-default fill-column 80)

;; Fonts and original window size
					;(add-to-list 'default-frame-alist '(font . "mononoki-16"))

(add-to-list 'default-frame-alist '(font . "DejaVu Sans Mono-14"))

;(set-default-font "Menlo 14")
(add-to-list 'default-frame-alist '(height . 24))
(add-to-list 'default-frame-alist '(width . 80))

;; Theme
(use-package doom-themes
  :ensure t
  :config
  (load-theme 'doom-one t))

;; Fancy titlebar for MacOS
(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
(add-to-list 'default-frame-alist '(ns-appearance . dark))
(setq ns-use-proxy-icon  nil)
(setq frame-title-format nil)

(provide 'setup-appearance)
