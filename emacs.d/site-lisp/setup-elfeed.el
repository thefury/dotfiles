(use-package elfeed
  :defer t
  :ensure t
  :config
  (setq elfeed-feeds
	'("http://nullprogram.com/feed"
	  "http://planet.emacsen.org/atom.xml"))
  :commands (elfeed))

;; (global-set-key (kbd "C-x w") 'elfeed)
(use-package elfeed-org
  :ensure t
  :config
  (elfeed-org)
  (setq rmh-elfeed-org-files (list "~/Nextcloud/workflow/org/newsfeed.org")))

(provide 'setup-elfeed)
