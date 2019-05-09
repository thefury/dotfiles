(require 'org)

(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)

(setq org-enforce-todo-dependencies t ; can't close without subtasks being done
      org-use-fast-todo-selection t)

(setq org-default-gtd-file "~/Nextcloud/workflow/notes/gtd.org")
(setq org-agenda-files
      (list "~/Nextcloud/workflow/notes/gtd.org"))
(setq org-agenda-custom-commands
      '(("w" todo "WAITING" nil) 
	("n" todo "NEXT" nil)
	("d" "Agenda + Next Actions" ((agenda) (todo "NEXT")))))


(setq org-capture-templates
      '(("t" "Todo" entry (file+headline org-default-gtd-file "Tasks")
	 "* TODO %?" :prepend t)))

(setq org-todo-keywords
      '((sequence "TODO" "NEXT" "WAITING" "|" "DONE" "DELEGATED"))) 


(defun gtd ()
  (interactive)
  (find-file org-default-gtd-file))

(provide 'setup-org)

