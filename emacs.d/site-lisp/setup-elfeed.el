(use-package elfeed-org
  :ensure t
  :config
  (elfeed-org)
  (setq rmh-elfeed-org-files (list "~/Nextcloud/workflow/org/newsfeed.org")))

(use-package elfeed
  :ensure t
  :config
  (setq elfeed-feeds
	'("http://nullprogram.com/feed"
	  "http://planet.emacsen.org/atom.xml"))
  :commands (elfeed))

;; (global-set-key (kbd "C-x w") 'elfeed)
(provide 'setup-elfeed)
