
(require 'org)

(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(define-key global-map "\C-cc" 'org-capture)

(setq org-enforce-todo-dependencies t ; can't close without subtasks being done
      org-use-fast-todo-selection t)

(setq org-default-gtd-file "~/Nextcloud/workflow/notes/gtd.org")
(setq org-default-journal-file "~/Nextcloud/workflow/notes/journal.org")
(setq org-agenda-files
      (list "~/Nextcloud/workflow/notes/gtd.org"))
(setq org-agenda-custom-commands
      '(("w" todo "WAITING" nil) 
	("n" todo "NEXT" nil)
	("d" "Agenda + Next Actions" ((agenda) (todo "NEXT")))))


(setq org-capture-templates
      '(("t" "Todo"
	 entry (file+headline org-default-gtd-file "Tasks")
	 "* TODO %?"
	 :prepend t)
	("j" "Journal Entry"
	 entry (file+datetree+prompt org-default-journal-file)
	 "* %?"
	 :empty-lines 1)))

(setq org-todo-keywords
      '((sequence "TODO" "NEXT" "WAITING" "|" "DONE" "DELEGATED"))) 


(defun gtd ()
  (interactive)
  (find-file org-default-gtd-file))

(defun jrnl ()
  (interactive)
  (find-file org-default-journal-file))

(provide 'setup-org)

