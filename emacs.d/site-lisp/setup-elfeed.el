(global-set-key (kbd "C-x w") 'fury/elfeed-load-db-and-open)

(use-package elfeed-org
  :ensure t
  :config
  (elfeed-org)
  (setq rmh-elfeed-org-files (list "~/Nextcloud/workflow/org/newsfeed.org")))

(use-package elfeed
  :ensure t
  :bind (:map elfeed-search-mode-map
              ("A" . fury/elfeed-show-all)
              ("E" . fury/elfeed-show-emacs)
              ("D" . fury/elfeed-show-daily)
              ("q" . fury/elfeed-save-db-and-bury)))

;;shortcut functions
(defun fury/elfeed-show-all ()
  (interactive)
  (bookmark-maybe-load-default-file)
  (bookmark-jump "elfeed-all"))

(defun fury/elfeed-show-emacs ()
  (interactive)
  (bookmark-maybe-load-default-file)
  (bookmark-jump "elfeed-emacs"))

(defun fury/elfeed-show-daily ()
  (interactive)
  (bookmark-maybe-load-default-file)
  (bookmark-jump "elfeed-daily"))

(defun fury/elfeed-load-db-and-open ()
  "Wrapper to load the elfeed db from disk before opening"
  (interactive)
  (elfeed-db-load)
  (elfeed)
  (elfeed-search-update--force))

;;write to disk when quiting
(defun fury/elfeed-save-db-and-bury ()
  "Wrapper to save the elfeed db to disk before burying buffer"
  (interactive)
  (elfeed-db-save)
  (quit-window))


(provide 'setup-elfeed)
