(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(package-initialize)

(require 'evil)
(evil-mode 1)

;; org mode for GTD
(setq org-agenda-files (list "~/Google Drive/GTD/inbox.org"
                             "~/Google Drive/GTD/meetings.org"
                             "~/Google Drive/GTD/journal.org"
                             "~/Google Drive/GTD/someday.org"))

(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)

;; GTD helper functions
(defun gtd ()
  (interactive)
  (find-file "~/Google Drive/GTD/inbox.org"))

(defun journal ()
  (interactive)
  (find-file "~/Google Drive/GTD/journal.org"))


(defun meetings ()
  (interactive)
  (find-file "~/Google Drive/GTD/meetings.org"))
