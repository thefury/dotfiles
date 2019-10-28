;; useful org files - mainly shared
;; --------------------------------
(defvar org-work-root "~/Nextcloud/kc-share/org")
(defvar org-refile-file (concat org-work-root "/refile.org"))
(defvar org-review-template (concat org-work-root "/templates/weekly-review.txt"))

(require 'org-crypt)

(use-package org
  :bind (("C-c d" . org-decrypt-entry)
	 :map global-map
	 ("C-c l" . org-store-link)
	 ("C-c c" . org-capture))
  
  :init
  (org-crypt-use-before-save-magic)
  (setq org-modules (quote (org-crypt org-habit))
	org-crypt-key nil
	org-confirm-babel-evaluate nil
	org-src-fontify-natively t
	org-src-tab-acts-natively t
	org-refile-targets (quote ((nil :maxlevel . 9)
				   (org-agenda-files :maxlevel . 9)))
	org-refile-use-outline-path t
	org-outline-path-complete-in-steps nil
	org-refile-allow-creating-parent-nodes (quote confirm)
	org-tags-exclude-from-inheritance '("project" "crypt")
	org-todo-keywords '((sequence "TODO(t)" "NEXT(n)" "|" "CANCELLED(x@)" "DONE(d!)")
			    (sequence "WAIT(w)" "HOLD(h)" "|" "CANCELLED(x@/!)" "MEETING"))

	org-highest-priority ?A
	org-lowest-priority ?C
	org-default-priority ?C

	org-stuck-projects '("+project/-HOLD-WAIT-DONE-CANCELLED" ("TODO") nil "")

	org-columns-default-format "%50ITEM(Task) %10CLOCKSUM %16TIMESTAMP_IA"
	
	org-todo-keyword-faces
	'(("TODO" :foreground "red" :weight bold)
	  ("NEXT" :foreground "blue" :weight bold)
	  ("DONE" :foreground "forest green" :weight bold)
	  ("WAIT" :foreground "orange" :weight bold)
	  ("HOLD" :foreground "magenta" :weight bold)
	  ("CANCELLED" :foreground "forest green" :weight bold)
	  ("MEETING" :foreground "forest green" :weight bold))

	org-capture-templates
	'(("t" "Todo" entry
	   (file org-refile-file)
	   "* TODO %?")
	  ("p" "Project" entry
	   (file org-refile-file)
	   "* %? :project:")
	  ("i" "Interuption" entry
	   (file org-refile-file)
	   "* DONE %? <%(org-read-date nil nil nil)> :INTERUPTION:" :clock-in :clock-resume)
	  ("n" "Note" entry
	   (file org-refile-file)
	   "* %? :NOTE:")
	  ("r" "Read" entry
	   (file org-refile-file)
	   "* READ %?")
	  ("Q" "Question" entry
	   (file org-refile-file)
	   "* %? :QUESTION:")
	  ("m" "Meeting" entry
	   (file org-refile-file)
	   "* MEETING with %? :MEETING:")))
  )

(use-package org-agenda
  :bind (:map org-agenda-mode-map
	      ("x" . fury/org-agenda-done)
	      :map global-map
	      ("C-c a" . org-agenda))

  :init
  ;; Allow .org.gpg files in agenda
  (unless (string-match-p "\\.gpg" org-agenda-file-regexp)
    (setq org-agenda-file-regexp
	  (replace-regexp-in-string "\\\\\\.org" "\\\\.org\\\\(\\\\.gpg\\\\)?"
				    org-agenda-file-regexp)))


  ;; adding some functions to see if they work
  (defun bh/is-project-p ()
    "Any task with a todo keyword subtask"
    (save-restriction
      (widen)
      (let ((has-subtask)
	    (subtree-end (save-excursion (org-end-of-subtree t)))
	    (is-a-task (member (nth 2 (org-heading-components)) org-todo-keywords-1)))
	(save-excursion
	  (forward-line 1)
	  (while (and (not has-subtask)
		      (< (point) subtree-end)
		      (re-search-forward "^\*+ " subtree-end t))
	    (when (member (org-get-todo-state) org-todo-keywords-1)
	      (setq has-subtask t))))
	(and is-a-task has-subtask))))

  (defun bh/find-project-task ()
    "Move point to the parent (project) task if any"
    (save-restriction
      (widen)
      (let ((parent-task (save-excursion (org-back-to-heading 'invisible-ok) (point))))
	(while (org-up-heading-safe)
	  (when (member (nth 2 (org-heading-components)) org-todo-keywords-1)
	    (setq parent-task (point))))
	(goto-char parent-task)
	parent-task)))

  (defun bh/is-project-subtree-p ()
    "Any task with a todo keyword that is in a project subtree.
Callers of this function already widen the buffer view."
    (let ((task (save-excursion (org-back-to-heading 'invisible-ok)
				(point))))
      (save-excursion
	(bh/find-project-task)
	(if (equal (point) task)
	    nil
	  t))))

  (defun bh/is-task-p ()
    "Any task with a todo keyword and no subtask"
    (save-restriction
      (widen)
      (let ((has-subtask)
	    (subtree-end (save-excursion (org-end-of-subtree t)))
	    (is-a-task (member (nth 2 (org-heading-components)) org-todo-keywords-1)))
	(save-excursion
	  (forward-line 1)
	  (while (and (not has-subtask)
		      (< (point) subtree-end)
		      (re-search-forward "^\*+ " subtree-end t))
	    (when (member (org-get-todo-state) org-todo-keywords-1)
	      (setq has-subtask t))))
	(and is-a-task (not has-subtask)))))

  (defun bh/is-subproject-p ()
    "Any task which is a subtask of another project"
    (let ((is-subproject)
	  (is-a-task (member (nth 2 (org-heading-components)) org-todo-keywords-1)))
      (save-excursion
	(while (and (not is-subproject) (org-up-heading-safe))
	  (when (member (nth 2 (org-heading-components)) org-todo-keywords-1)
	    (setq is-subproject t))))
      (and is-a-task is-subproject)))

  (defun bh/list-sublevels-for-projects-indented ()
    "Set org-tags-match-list-sublevels so when restricted to a subtree we list all subtasks.
  This is normally used by skipping functions where this variable is already local to the agenda."
    (if (marker-buffer org-agenda-restrict-begin)
	(setq org-tags-match-list-sublevels 'indented)
      (setq org-tags-match-list-sublevels nil))
    nil)

  (defun bh/list-sublevels-for-projects ()
    "Set org-tags-match-list-sublevels so when restricted to a subtree we list all subtasks.
  This is normally used by skipping functions where this variable is already local to the agenda."
    (if (marker-buffer org-agenda-restrict-begin)
	(setq org-tags-match-list-sublevels t)
      (setq org-tags-match-list-sublevels nil))
    nil)

  (defvar bh/hide-scheduled-and-waiting-next-tasks t)

  (defun bh/toggle-next-task-display ()
    (interactive)
    (setq bh/hide-scheduled-and-waiting-next-tasks (not bh/hide-scheduled-and-waiting-next-tasks))
    (when  (equal major-mode 'org-agenda-mode)
      (org-agenda-redo))
    (message "%s WAITING and SCHEDULED NEXT Tasks" (if bh/hide-scheduled-and-waiting-next-tasks "Hide" "Show")))

  (defun bh/skip-stuck-projects ()
    "Skip trees that are not stuck projects"
    (save-restriction
      (widen)
      (let ((next-headline (save-excursion (or (outline-next-heading) (point-max)))))
	(if (bh/is-project-p)
	    (let* ((subtree-end (save-excursion (org-end-of-subtree t)))
		   (has-next ))
	      (save-excursion
		(forward-line 1)
		(while (and (not has-next) (< (point) subtree-end) (re-search-forward "^\\*+ NEXT " subtree-end t))
		  (unless (member "WAITING" (org-get-tags-at))
		    (setq has-next t))))
	      (if has-next
		  nil
		next-headline)) ; a stuck project, has subtasks but no next task
	  nil))))

  (defun bh/skip-non-stuck-projects ()
    "Skip trees that are not stuck projects"
    ;; (bh/list-sublevels-for-projects-indented)
    (save-restriction
      (widen)
      (let ((next-headline (save-excursion (or (outline-next-heading) (point-max)))))
	(if (bh/is-project-p)
	    (let* ((subtree-end (save-excursion (org-end-of-subtree t)))
		   (has-next ))
	      (save-excursion
		(forward-line 1)
		(while (and (not has-next) (< (point) subtree-end) (re-search-forward "^\\*+ NEXT " subtree-end t))
		  (unless (member "WAITING" (org-get-tags-at))
		    (setq has-next t))))
	      (if has-next
		  next-headline
		nil)) ; a stuck project, has subtasks but no next task
	  next-headline))))

  (defun bh/skip-non-projects ()
    "Skip trees that are not projects"
    ;; (bh/list-sublevels-for-projects-indented)
    (if (save-excursion (bh/skip-non-stuck-projects))
	(save-restriction
	  (widen)
	  (let ((subtree-end (save-excursion (org-end-of-subtree t))))
	    (cond
	     ((bh/is-project-p)
	      nil)
	     ((and (bh/is-project-subtree-p) (not (bh/is-task-p)))
	      nil)
	     (t
	      subtree-end))))
      (save-excursion (org-end-of-subtree t))))

  (defun bh/skip-non-tasks ()
    "Show non-project tasks.
Skip project and sub-project tasks, habits, and project related tasks."
    (save-restriction
      (widen)
      (let ((next-headline (save-excursion (or (outline-next-heading) (point-max)))))
	(cond
	 ((bh/is-task-p)
	  nil)
	 (t
	  next-headline)))))

  (defun bh/skip-project-trees-and-habits ()
    "Skip trees that are projects"
    (save-restriction
      (widen)
      (let ((subtree-end (save-excursion (org-end-of-subtree t))))
	(cond
	 ((bh/is-project-p)
	  subtree-end)
	 ((org-is-habit-p)
	  subtree-end)
	 (t
	  nil)))))

  (defun bh/skip-projects-and-habits-and-single-tasks ()
    "Skip trees that are projects, tasks that are habits, single non-project tasks"
    (save-restriction
      (widen)
      (let ((next-headline (save-excursion (or (outline-next-heading) (point-max)))))
	(cond
	 ((org-is-habit-p)
	  next-headline)
	 ((and bh/hide-scheduled-and-waiting-next-tasks
	       (member "WAITING" (org-get-tags-at)))
	  next-headline)
	 ((bh/is-project-p)
	  next-headline)
	 ((and (bh/is-task-p) (not (bh/is-project-subtree-p)))
	  next-headline)
	 (t
	  nil)))))

  (defun bh/skip-project-tasks-maybe ()
    "Show tasks related to the current restriction.
When restricted to a project, skip project and sub project tasks, habits, NEXT tasks, and loose tasks.
When not restricted, skip project and sub-project tasks, habits, and project related tasks."
    (save-restriction
      (widen)
      (let* ((subtree-end (save-excursion (org-end-of-subtree t)))
	     (next-headline (save-excursion (or (outline-next-heading) (point-max))))
	     (limit-to-project (marker-buffer org-agenda-restrict-begin)))
	(cond
	 ((bh/is-project-p)
	  next-headline)
	 ((org-is-habit-p)
	  subtree-end)
	 ((and (not limit-to-project)
	       (bh/is-project-subtree-p))
	  subtree-end)
	 ((and limit-to-project
	       (bh/is-project-subtree-p)
	       (member (org-get-todo-state) (list "NEXT")))
	  subtree-end)
	 (t
	  nil)))))

  (defun bh/skip-project-tasks ()
    "Show non-project tasks.
Skip project and sub-project tasks, habits, and project related tasks."
    (save-restriction
      (widen)
      (let* ((subtree-end (save-excursion (org-end-of-subtree t))))
	(cond
	 ((bh/is-project-p)
	  subtree-end)
	 ((org-is-habit-p)
	  subtree-end)
	 ((bh/is-project-subtree-p)
	  subtree-end)
	 (t
	  nil)))))

  (defun bh/skip-non-project-tasks ()
    "Show project tasks.
Skip project and sub-project tasks, habits, and loose non-project tasks."
    (save-restriction
      (widen)
      (let* ((subtree-end (save-excursion (org-end-of-subtree t)))
	     (next-headline (save-excursion (or (outline-next-heading) (point-max)))))
	(cond
	 ((bh/is-project-p)
	  next-headline)
	 ((org-is-habit-p)
	  subtree-end)
	 ((and (bh/is-project-subtree-p)
	       (member (org-get-todo-state) (list "NEXT")))
	  subtree-end)
	 ((not (bh/is-project-subtree-p))
	  subtree-end)
	 (t
	  nil)))))

  (defun bh/skip-projects-and-habits ()
    "Skip trees that are projects and tasks that are habits"
    (save-restriction
      (widen)
      (let ((subtree-end (save-excursion (org-end-of-subtree t))))
	(cond
	 ((bh/is-project-p)
	  subtree-end)
	 ((org-is-habit-p)
	  subtree-end)
	 (t
	  nil)))))

  (defun bh/skip-non-subprojects ()
    "Skip trees that are not projects"
    (let ((next-headline (save-excursion (outline-next-heading))))
      (if (bh/is-subproject-p)
	  nil
	next-headline)))
  
  (defun gs/select-with-tag-function (select-fun-p)
    (save-restriction
      (widen)
      (let ((next-headline
	     (save-excursion (or (outline-next-heading)
				 (point-max)))))
	(if (funcall select-fun-p) nil next-headline))))
  
  (defun gs/select-projects ()
    "Selects tasks which are project headers"
    (gs/select-with-tag-function #'bh/is-project-p))
  (defun gs/select-project-tasks ()
    "Skips tags which belong to projects (and is not a project itself)"
    (gs/select-with-tag-function
     #'(lambda () (and
		   (not (bh/is-project-p))
		   (bh/is-project-subtree-p)))))
  (defun gs/select-standalone-tasks ()
    "Skips tags which belong to projects. Is neither a project, nor does it blong to a project"
    (gs/select-with-tag-function
     #'(lambda () (and
		   (not (bh/is-project-p))
		   (not (bh/is-project-subtree-p))))))
  (defun gs/select-projects-and-standalone-tasks ()
    "Skips tags which are not projects"
    (gs/select-with-tag-function
     #'(lambda () (or
		   (bh/is-project-p)
		   (bh/is-project-subtree-p)))))

  (defun gs/org-agenda-project-warning ()
    "Is a project stuck or waiting. If the project is not stuck,
show nothing. However, if it is stuck and waiting on something,
show this warning instead."
    (if (gs/org-agenda-project-is-stuck)
	(if (gs/org-agenda-project-is-waiting) " !W" " !S") ""))

  (defun gs/org-agenda-project-is-stuck ()
    "Is a project stuck"
    (if (bh/is-project-p) ; first, check that it's a project
	(let* ((subtree-end (save-excursion (org-end-of-subtree t)))
	       (has-next))
	  (save-excursion
	    (forward-line 1)
	    (while (and (not has-next)
			(< (point) subtree-end)
			(re-search-forward "^\\*+ NEXT " subtree-end t))
	      (unless (member "WAITING" (org-get-tags-at))
		(setq has-next t))))
	  (if has-next nil t)) ; signify that this project is stuck
      nil)) ; if it's not a project, return an empty string

  (defun gs/org-agenda-project-is-waiting ()
    "Is a project stuck"
    (if (bh/is-project-p) ; first, check that it's a project
	(let* ((subtree-end (save-excursion (org-end-of-subtree t))))
	  (save-excursion
	    (re-search-forward "^\\*+ WAITING" subtree-end t)))
      nil)) ; if it's not a project, return an empty string

  ;; Some helper functions for agenda views
  (defun gs/org-agenda-prefix-string ()
    "Format"
    (let ((path (org-format-outline-path (org-get-outline-path))) ; "breadcrumb" path
	  (stuck (gs/org-agenda-project-warning))) ; warning for stuck projects
      (if (> (length path) 0)
	  (concat stuck ; add stuck warning
		  " [" path "]") ; add "breadcrumb"
	stuck)))
  
  (defun gs/org-agenda-add-location-string ()
    "Gets the value of the LOCATION property"
    (let ((loc (org-entry-get (point) "LOCATION")))
      (if (> (length loc) 0)
	  (concat "{" loc "} ")
	"")))







  
  (setq org-agenda-files (list org-work-root)
	org-agenda-window-setup 'only-window
	org-agenda-dim-agenda-tasks nil
	org-agenda-compact-blocks 1
	org-agenda-todo-list-sublevels nil
	;; org-stuck-projects (quote ("" nil nil ""))
	org-agenda-time-grid (quote
			      ((daily today remove-match)
			       (800 1200 1600 2000)
			       "......" "----------------"))
	
	
	org-agenda-custom-commands (quote
				    (("N" "Notes" tags "NOTE"
				      ((org-agenda-overriding-header "Notes")
				       (org-tags-match-list-sublevels t)))

 
				     ;; using this as an example. Might be some good code in here.
				     ;; https://github.com/gjstein/emacs.d/blob/master/config/gs-org.el
				     
				     (" " "Export Schedule" (
							     (agenda "" ((org-agenda-overriding-header "Today's Schedule:")
									 (org-agenda-span 'day)
									 (org-agenda-ndays 1)
									 (org-agenda-start-on-weekday nil)
									 (org-agenda-start-day "+0d")
									 (org-agenda-todo-ignore-deadlines nil)))
							     
							     (tags "REFILE"
								   ((org-agenda-overriding-header "Tasks to Refile:")
								    (org-tags-match-list-sublevels nil)))

							     (todo "NEXT"
									((org-agenda-overriding-header "Next Tasks:")))

							     (tags-todo "+project/!+TODO|+NEXT"
									((org-agenda-overriding-header "Active Projects test:")
									 (org-agenda-sorting-strategy
									  '(category-keep))))
							    
							     (tags "ENDOFAGENDA"
								   ((org-agenda-overriding-header "End of Agenda")
								    (org-tags-match-list-sublevels nil)))
							     )
				      ((org-agenda-start-with-log-mode t)
				       (org-agenda-log-mode-items '(clock))
					;(org-agenda-prefix-format '((agenda . "  %-12:c%?-12t %(gs/org-agenda-add-location-string)% s")
					;			   (timeline . "  % s")
					;			   (todo . "  %-12:c %(gs/org-agenda-prefix-string) ")
					;			   (tags . "  %-12:c %(gs/org-agenda-prefix-string) ")
					;			   (search . "  %i %-12:c")))
				       (org-agenda-todo-ignore-deadlines 'near)
				       (org-agenda-todo-ignore-scheduled t)))


				     ("R" "Agenda"
				      ((agenda "" nil)
				       (tags "REFILE"
					     ((org-agenda-overriding-header "Tasks to Refile")
					      (org-tags-match-list-sublevels nil)))
				       (tags-todo "-CANCELLED/!"
						  ((org-agenda-overriding-header "Stuck Projects")
						   (org-agenda-skip-function 'bh/skip-non-stuck-projects)
						   (org-agenda-sorting-strategy
						    '(category-keep))))
				       (tags-todo "-HOLD-CANCELLED/!"
						  ((org-agenda-overriding-header "Projects")
						   (org-agenda-skip-function 'bh/skip-non-projects)
						   (org-tags-match-list-sublevels 'indented)
						   (org-agenda-sorting-strategy
						    '(category-keep))))
				       (tags-todo "-CANCELLED/!NEXT"
						  ((org-agenda-overriding-header (concat "Project Next Tasks"
											 (if bh/hide-scheduled-and-waiting-next-tasks
											     ""
											   " (including WAITING and SCHEDULED tasks)")))
						   (org-agenda-skip-function 'bh/skip-projects-and-habits-and-single-tasks)
						   (org-tags-match-list-sublevels t)
						   (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
						   (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)
						   (org-agenda-todo-ignore-with-date bh/hide-scheduled-and-waiting-next-tasks)
						   (org-agenda-sorting-strategy
						    '(todo-state-down effort-up category-keep))))
				       (tags-todo "-REFILE-CANCELLED-WAITING-HOLD/!"
						  ((org-agenda-overriding-header (concat "Project Subtasks"
											 (if bh/hide-scheduled-and-waiting-next-tasks
											     ""
											   " (including WAITING and SCHEDULED tasks)")))
						   (org-agenda-skip-function 'bh/skip-non-project-tasks)
						   (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
						   (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)
						   (org-agenda-todo-ignore-with-date bh/hide-scheduled-and-waiting-next-tasks)
						   (org-agenda-sorting-strategy
						    '(category-keep))))
				       (tags-todo "-REFILE-CANCELLED-WAITING-HOLD/!"
						  ((org-agenda-overriding-header (concat "Standalone Tasks"
											 (if bh/hide-scheduled-and-waiting-next-tasks
											     ""
											   " (including WAITING and SCHEDULED tasks)")))
						   (org-agenda-skip-function 'bh/skip-project-tasks)
						   (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
						   (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)
						   (org-agenda-todo-ignore-with-date bh/hide-scheduled-and-waiting-next-tasks)
						   (org-agenda-sorting-strategy
						    '(category-keep))))
				       (tags-todo "-CANCELLED+WAITING|HOLD/!"
						  ((org-agenda-overriding-header (concat "Waiting and Postponed Tasks"
											 (if bh/hide-scheduled-and-waiting-next-tasks
											     ""
											   " (including WAITING and SCHEDULED tasks)")))
						   (org-agenda-skip-function 'bh/skip-non-tasks)
						   (org-tags-match-list-sublevels nil)
						   (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
						   (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)))
				       (tags "-REFILE/"
					     ((org-agenda-overriding-header "Tasks to Archive")
					      (org-agenda-skip-function 'bh/skip-non-archivable-tasks)
					      (org-tags-match-list-sublevels nil)))))
				      
				      ("b" "Agenda Review" (
							    (tags "REFILE-ARCHIVE-REFILE=\"nil\""
								  ((org-agenda-overriding-header "Tasks to Refile:")
								   (org-tags-match-list-sublevels nil)))
							    (tags-todo "-SOMEDAY-CANCELLED-ARCHIVE/!NEXT"
								       ((org-agenda-overriding-header "Next Tasks:")
									))
							    (tags-todo "-SOMEDAY-HOLD-CANCELLED-REFILE-ARCHIVEr/!"
								       ((org-agenda-overriding-header "Active Projects:")
					;(org-agenda-skip-function 'gs/select-projects)))
									(org-agenda-skip-function 'bh/skip-stuck-projects)))
							    
							    (tags-todo "-SOMEDAY-HOLD-CANCELLED-REFILE-ARCHIVEr/!"
								       ((org-agenda-overriding-header "Stuck Projects:")
									(org-agenda-skip-function 'bh/skip-non-stuck-projects)))
							    
							    (tags-todo "-SOMEDAY-HOLD-CANCELLED-REFILE-ARCHIVE-STYLE=\"habit\"/!-NEXT"
								       ((org-agenda-overriding-header "Standalone Tasks:")
									(org-agenda-skip-function 'gs/select-standalone-tasks)))

							    (tags-todo "-SOMEDAY-HOLD-CANCELLED-REFILE-ARCHIVE/!-NEXT"
								       ((org-agenda-overriding-header "Remaining Project Tasks:")
									(org-agenda-skip-function 'gs/select-project-tasks)))
							    (tags-todo "-SOMEDAY-CANCELLED-ARCHIVE/!WAITING"
								       ((org-agenda-overriding-header "Waiting Tasks:")
									))
							    (tags "SOMEDAY-ARCHIVE-CANCELLED"
								  ((org-agenda-overriding-header "Inactive Projects and Tasks")
								   (org-tags-match-list-sublevels nil)))
							    (tags "ENDOFAGENDA"
								  ((org-agenda-overriding-header "End of Agenda")
								   (org-tags-match-list-sublevels nil)))
							    )
				       ((org-agenda-start-with-log-mode t)
					(org-agenda-log-mode-items '(clock))
					(org-agenda-prefix-format '((agenda . "  %-12:c%?-12t %(gs/org-agenda-add-location-string)% s")
								    (timeline . "  % s")
								    (todo . "  %-12:c %(gs/org-agenda-prefix-string) ")
								    (tags . "  %-12:c %(gs/org-agenda-prefix-string) ")
								    (search . "  %i %-12:c")))
					(org-agenda-todo-ignore-deadlines 'near)
					(org-agenda-todo-ignore-scheduled t))))))

				      
	
	:config

	(defun fury/org-agenda-done (&optional arg)
	  "Mark current TODO as done.
This changes the line at point, all other lines in the agenda referring to
the same tree node, and the headline of the tree node in the Org-mode file."

	  (interactive "P")
	  (org-agenda-todo "DONE"))

	(defun fury/org-skip-subtree-if-priority (priority)
	  "Skip an agenda subtree if it has a priority of PRIORITY (?A ?B or ?C."
	  (let ((subtree-end (save-excursion (org-end-of-subtree t)))
		(pri-value (* 1000 (- org-lowest-priority priority)))
		(pri-current (org-get-priority (thing-at-point 'line t))))
	    (if (= pri-value pri-current)
		subtree-end
	      nil)))
	
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
    (defun org-journal-date-format-func (time)
      "Custom function to insert journal date header,
and some custom text on a newly created journal file."
      (when (= (buffer-size) 0)
	(insert
	 (pcase org-journal-file-type
	   (`daily "#+TITLE: Daily Journal")
	   (`weekly "#+TITLE: Weekly Journal")
	   (`monthly "#+TITLE: Monthly Journal")
	   (`yearly "#+TITLE: Yearly Journal"))))
      (concat org-journal-date-prefix (format-time-string "%A, %x" time)))

    (setq org-journal-dir (concat org-work-root "/journal")
	  org-journal-encrypt-journal t
	  org-journal-date-format 'org-journal-date-format-func
	  org-journal-file-type 'weekly)
    )

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

  (provide 'setup-org)
