;; useful org files - mainly shared
;; --------------------------------
(defvar org-work-root "~/Nextcloud/kc-share/org")
(defvar org-home-root "~/Nextcloud/org")
(defvar org-refile-file (concat org-work-root "/refile.org"))
(defvar org-journal-file (concat org-work-root "/journal.org"))
(defvar org-review-template (concat org-work-root "/templates/weekly-review.txt"))


(use-package org
  :bind (:map global-map
	      ("C-c l" . org-store-link)
	      ("C-c c" . org-capture))
  
  :init
  (setq org-confirm-babel-evaluate nil
	org-src-fontify-natively t
	org-src-tab-acts-natively t
	org-refile-targets (quote ((nil :maxlevel . 9)
				   (org-agenda-files :maxlevel . 9)))
	org-refile-use-outline-path t
	org-outline-path-complete-in-steps nil
	org-refile-allow-creating-parent-nodes (quote confirm)
	org-todo-keyword-faces
	'(("TODO" :foreground "red" :weight bold)
	  ("DONE" :foreground "forest green" :weight bold)
	  ("WAIT" :foreground "orange" :weight bold)
	  ("SOMEDAY" :foreground "magenta" :weight bold)
	  ("CANCELLED" :foreground "forest green" :weight bold)
	  ("MEETING" :foreground "forest green" :weight bold))
	org-capture-templates
	'(("t" "Todo" entry
	   (file org-refile-file)
	   "* TODO %?")
	  ("p" "Project" entry
	   (file org-refile-file)
	   "* %? :PROJECT:")
	  ("r" "Review" entry
	   (file+datetree+prompt org-journal-file)
	   (file org-review-template))
	  ("i" "Interuption" entry
	   (file org-refile-file)
	   "* DONE %? <%(org-read-date nil nil nil)> :INTERUPTION:" :clock-in :clock-resume)
	  ("n" "Note" entry
	   (file org-refile-file)
	   "* %? :NOTE:")
	  ("Q" "Question" entry
	   (file org-refile-file)
	   "* %? :QUESTION:")
	  ("m" "Meeting" entry
	   (file org-refile-file)
	   "* MEETING with %? :MEETING:")
	  ("j" "Journal Entry" entry
	   (file+datetree+prompt org-journal-file)
	   "* %?" :empty-lines 1)))
  )

(use-package org-agenda
  :bind (:map org-agenda-mode-map
	      ("x" . fury/org-agenda-done)
	 :map global-map
	 ("C-c a" . org-agenda))

  :init
  (setq org-agenda-files (list org-work-root org-home-root)
	org-agenda-window-setup 'only-window
	org-agenda-dim-agenda-tasks nil
	org-agenda-compact-blocks 1
	org-agenda-todo-list-sublevels nil
	org-tags-exclude-from-inheritance '("PROJECT")
	org-stuck-projects '("+PROJECT/-SOMEDAY-WAIT-DONE-CANCELLED" ("TODO") nil "")
	org-agenda-custom-commands (quote (("N" "Notes" tags "NOTE"
					    ((org-agenda-overriding-header "Notes")
					     (org-tags-match-list-sublevels t)))
					   
					   (" " "All Tasks"
					    ((agenda "" ((org-agenda-span 1)))
					     (tags "REFILE"
						   ((org-agenda-overriding-header "Refile")))

					     (tags "-RECURRING+TODO=\"TODO\""
						   ((org-agenda-overriding-header "Next Actions")
						    (org-agenda-skip-function 'fury/org-skip-scheduled-tasks)))

					     (tags "+PROJECT/-SOMEDAY-WAIT-DONE"
						   ((org-agenda-overriding-header "Current Projects")
						    (org-agenda-skip-function 'fury/org-skip-stuck-projects)))
					     
					     (org-agenda-list-stuck-projects)
					     
					     (tags "+PROJECT/+DONE"
						   ((org-agenda-overriding-header "Completed Projects")
						    (org-agenda-skip-function 'fury/org-skip-non-stuck-projects)))

					     (todo "WAIT"
						   ((org-agenda-overriding-header "Waiting On")))))


					   
					   ("r" "Review"
					    ((tags "REFILE"
						   ((org-agenda-overriding-header "Tasks to Refile:")
						    (org-tags-match-list-sublevels nil)))
					     (tags "PROJECT"
						   ((org-agenda-overriding-header "Current Projects:")
						    (org-agenda-skip-function 'fury/org-skip-stuck-projects)
						    (org-tags-match-list-sublevels nil)))
					     (tags "PROJECT"
						   ((org-agenda-overriding-header "Stuck Projects:")
						    (org-agenda-todo-list-sublevels nil)
						    (org-agenda-skip-function 'fury/org-skip-active-projects)))
					     (tags "PROJECT"
						   ((org-agenda-overriding-header "Completed Projects:")
						    (org-agenda-skip-function 'fury/org-skip-incomplete-projects)
						    (org-agenda-todo-list-sublevels nil)))
					     ;; (org-agenda-list-stuck-projects)
					     (todo "TODO"
						   ((org-agenda-overriding-header "Scheduled Tasks:")
						    (org-agenda-skip-function 'fury/org-skip-unscheduled-tasks)
						    (org-tags-match-list-sublevels nil)))
					     (tags "RECURRING"
						   ((org-agenda-overriding-header "Recurring Tasks:")
						    (org-agenda-match-list-sublevels nil)))
					     (todo "TODO"
						   ((org-agenda-overriding-header "Unscheduled Tasks:")
						    (org-agenda-skip-function 'fury/org-skip-scheduled-tasks)
						    (org-tags-match-list-sublevels nil)))
					     (todo "WAIT|HOLD"
						   ((org-agenda-overriding-header "Waiting and Postponed Tasks:")
						    (org-tags-match-list-sublevels nil)))
					     (todo "SOMEDAY"
						   ((org-agenda-overriding-header "Someday/Maybe Tasks:")
						    (org-tags-match-list-sublevels nil)))
					     (todo "DONE"
						   ((org-agenda-overriding-header "Possibly Archive:")
						    (org-tags-match-list-sublevels nil)))
					     ;; tasks to Archive
					     )))))

  
  :config

  (defun fury/org-agenda-done (&optional arg)
    "Mark current TODO as done.
This changes the line at point, all other lines in the agenda referring to
the same tree node, and the headline of the tree node in the Org-mode file."

    (interactive "P")
    (org-agenda-todo "DONE"))

  (defun fury/org-skip-scheduled-tasks ()
    (org-agenda-skip-entry-if
     'scheduled
     'regexp "PROJECT"
     'regexp "RECURRING"))

  (defun fury/org-skip-unscheduled-tasks ()
    (org-agenda-skip-entry-if 'notscheduled 'regexp "RECURRING" 'regexp "PROJECT"))

  (defun fury/org-skip-active-projects ()
    "Skip project trees that are TODO"
    (org-agenda-skip-entry-if 'todo '("TODO" "DONE" "SOMEDAY")))

  (defun fury/org-skip-stuck-projects ()
    "Skip project trees that are TODO"
    (org-agenda-skip-entry-if 'todo '("WAIT" "CANCELLED" "SOMEDAY" "DONE")))

  (defun fury/org-skip-incomplete-projects ()
    "Skip project trees that are TODO"
    (org-agenda-skip-entry-if 'todo '("TODO" "WAIT" "SOMEDAY"))))

(use-package org-bullets
  :after (org org-agenda)
  :ensure t
  :init
  (add-hook 'org-mode-hook 'org-bullets-mode))

(use-package org-journal
  :after (org)
  :ensure t
  :init
  (setq org-journal-dir (concat org-work-root "/journal"))
  :config)

;; Babel

(require 'ob-go)
(org-babel-do-load-languages 
 'org-babel-load-languages
 '((shell      . t)
   (js         . t)
   (emacs-lisp . t)
   (clojure    . t)
   (python     . t)
   (ruby       . t)
   (go         . t)
   (css        . t)))

;; Babel
;; Org defuns
(defun fury/gtd ()
  (interactive)
  (find-file (fury/org-file "refile.org")))

(defun journal ()
  (interactive)
  (find-file (fury/org-file "journal.org")))

(provide 'setup-org)
