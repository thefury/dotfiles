(require 'org)
(require 'org-agenda)

(add-to-list 'org-modules 'org-habit)

(setq org-root-path "~/Nextcloud/workflow/org")
(setq org-refile-file "~/Nextcloud/workflow/org/refile.org")
(setq org-journal-file "~/Nextcloud/workflow/org/journal.org")
(setq org-review-template "~/Nextcloud/wprkflow/org/templates/weekly-review.txt")
(setq org-agenda-window-setup 'only-window)

(setq org-enforce-todo-dependencies t ; can't close without subtasks being done
      org-use-fast-todo-selection t)

(setq org-todo-keywords
      '((sequence "TODO(t)" "STARTED(s)" "|" "DONE(d)")
	(sequence "WAITING(w@/!)" "SOMEDAY(h)" "|" "CANCELLED(c@/!)" "MEETING")))

(setq org-todo-keyword-faces
      '(("TODO" :foreground "red" :weight bold)
	("STARTED" :foreground "forest green" :weight bold)
	("DONE" :foreground "forest green" :weight bold)
	("WAITING" :foreground "orange" :weight bold)
	("SOMEDAY" :foreground "magenta" :weight bold)
	("CANCELLED" :foreground "forest green" :weight bold)
	("MEETING" :foreground "forest green" :weight bold)))

(defun fury/org-file (filename)
  "Create a file name in our org directory"
  (interactive)
  (concat org-root-path "/" filename))

;; Agenda - load all files under this directory
(setq org-agenda-files
      (list org-root-path))

(defvar fury/org-kinetic-files
  '("~/Nextcloud/workflow/org/kinetic.org"
    "~/Nextcloud/workflow/org/routines.org"))

;; Do not dim blocked tasks
(setq org-agenda-dim-blocked-tasks nil)

;; Compact the block agenda view
(setq org-agenda-compact-blocks t)

;; Custom agenda command definitions
(defvar  bh/hide-scheduled-and-waiting-next-tasks t)

;; stuck projects

(setq org-agenda-todo-list-sublevels nil)
(setq org-tags-exclude-from-inheritance '("PROJECT")
      org-stuck-projects '("+PROJECT/-SOMEDAY-DONE"
			   ("TODO") ()))

;; These two funtions scooped from Sacha
(defun fury/org-agenda-done (&optional arg)
  "Mark current TODO as done.
This changes the line at point, all other lines in the agenda referring to
the same tree node, and the headline of the tree node in the Org-mode file."
  (interactive "P")
  (org-agenda-todo "DONE"))
;; Override the key definition for org-exit
(define-key org-agenda-mode-map "x" 'fury/org-agenda-done)

  (defun fury/org-agenda-mark-done-and-add-followup ()
    "Mark the current TODO as done and add another task after it.
Creates it at the same level as the previous task, so it's better to use
this with to-do items than with projects or headings."
    (interactive)
    (org-agenda-todo "DONE")
    (org-agenda-switch-to)
    (org-capture 0 "t"))

;; Override the key definition
(define-key org-agenda-mode-map "X" 'fury/org-agenda-mark-done-and-add-followup)



(defun fury/org-skip-scheduled-tasks ()
  (org-agenda-skip-entry-if 'scheduled 'regexp "PROJECT" 'regexp "RECURRING"))
  
(defun fury/org-skip-unscheduled-tasks ()
  (org-agenda-skip-entry-if 'notscheduled 'regexp "RECURRING" 'regexp "PROJECT"))

(defun fury/org-skip-active-projects ()
  "Skip project trees that are TODO or STARTED"
  (org-agenda-skip-entry-if 'todo '("TODO" "STARTED" "DONE" "SOMEDAY")))

(defun fury/org-skip-stuck-projects ()
  "Skip project trees that are TODO or STARTED"
  (org-agenda-skip-entry-if 'todo '("WAITING" "CANCELLED" "SOMEDAY" "DONE")))

(defun fury/org-skip-incomplete-projects ()
  "Skip project trees that are TODO or STARTED"
  (org-agenda-skip-entry-if 'todo '("TODO" "STARTED" "WAITING" "SOMEDAY")))

(setq org-agenda-custom-commands
      (quote (("N" "Notes" tags "NOTE"
               ((org-agenda-overriding-header "Notes")
                (org-tags-match-list-sublevels t)))
	      ("Q" "Questions" tags "QUESTION"
	       ((org-agenda-overriding-header "Questions")
		(org-tags-match-list-sublevels t )))
	      ("d" "Daily Tasks"
	       ((agenda ""
			((org-agenda-overriding-header "Kinetic Tasks")))
		(tags "PROJECT"
		      ((org-agenda-overriding-header "Current Projects:")
		       (org-agenda-skip-function 'fury/org-skip-stuck-projects)
		       (org-tags-match-list-sublevels nil)))))
	      ("k" "Kinetic"
	       ((agenda ""
			((org-agenda-overriding-header "Kinetic Tasks")
			 (org-agenda-files fury/org-kinetic-files)))
		(tags "PROJECT"
		      ((org-agenda-overriding-header "Current Projects:")
		       (org-agenda-files fury/org-kinetic-files)
		       (org-agenda-skip-function 'fury/org-skip-stuck-projects)
		       (org-tags-match-list-sublevels nil)))))
	      ("w" "Waiting" ((todo "WAITING")))
	      ("u" "Unscheduled Tasks"
	       ((todo "TODO"
		      ((org-agenda-overriding-header "Unscheduled Tasks:")
		       (org-agenda-todo-list-sublevels nil)
		       (org-agenda-skip-function 'fury/org-skip-scheduled-tasks)))))
              (" " "Review"
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
		(todo "WAITING|HOLD"
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

;; Org capture

(setq org-capture-templates
      '(("t" "Todo" entry
	 (file org-refile-file)
	 "* TODO %?")
	("p" "Project" entry
	 (file org-refile-file)
	 "* %? :PROJECT:")
	("r" "Review" entry
	 (file+datetree+prompt org-journal-file)
	 (file "~/Nextcloud/workflow/org/templates/weekly-review.txt"))
	("i" "Interuption" entry
	 (file org-refile-file)
	 "* DONE %? :INTERUPTION:\nSCHEDULED: <%(org-read-date nil nil nil)>" :clock-in :clock-resume)
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


;; Refiling
; Targets include this file and any file contributing to the agenda - up to 9 levels deep
(setq org-refile-targets (quote ((nil :maxlevel . 9)
                                 (org-agenda-files :maxlevel . 9))))

; Use full outline paths for refile targets - we file directly with IDO
(setq org-refile-use-outline-path t)

; Targets complete directly with IDO
(setq org-outline-path-complete-in-steps nil)

; Allow refile to create parent tasks with confirmation
(setq org-refile-allow-creating-parent-nodes (quote confirm))

; Use IDO for both buffer and file completion and ido-everywhere to t
(setq org-completion-use-ido t)
(setq ido-everywhere t)
(setq ido-max-directory-size 100000)
(ido-mode (quote both))
; Use the current window when visiting files and buffers with ido
(setq ido-default-file-method 'selected-window)
(setq ido-default-buffer-method 'selected-window)
; Use the current window for indirect buffer display
(setq org-indirect-buffer-display 'current-window)



;; Org Keybindings
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(define-key global-map "\C-cc" 'org-capture)


;; Org defuns
(defun fury/gtd ()
  (interactive)
  (find-file (fury/org-file "refile.org")))

(defun fury/journal ()
  (interactive)
  (find-file (fury/org-file "journal.org")))

(provide 'setup-org)

