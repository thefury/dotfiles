(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(package-initialize)

(require 'evil)
(evil-mode 1)

;; org mode for GTD

;; load all files in the GTD folder
;;(setq org-agenda-files
;;      (directory-files
;;       (expand-file-name "~/Google Drive/GTD/") nil "org$"))

(setq org-agenda-files '("~/Google Drive/GTD"))


(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)

;; GTD stuck projects
(setq org-stuck-projects
      '("+PROJECT/-MAYBE-DONE" ("NEXT" "TODO") ("@SHOP")
	"\\<IGNORE\\>"))

;; GTD helper functions
(defun inbox ()
  (interactive)
  (find-file "~/Google Drive/GTD/inbox.org"))

(defun tasks ()
  (interactive)
  (find-file "~/Google Drive/GTD/tasks.org"))

(defun journal ()
  (interactive)
  (find-file "~/Google Drive/GTD/journal.org"))

(defun meetings ()
  (interactive)
  (find-file "~/Google Drive/GTD/meetings.org"))

(define-key global-map "\C-cc" 'org-capture)

(setq org-capture-templates
      '(("t" "Todo" entry (file+headline "~/Google Drive/GTD/inbox.org" "Tasks")
	 "* NEXT %?\n  %i\n  %a")
	("j" "Journal" entry (file+datetree "~/Google Drive/GTD/journal.org" "Journal")
	 "* %?\nEntered on %U\n  %i\n")))
