(require 'org)
(require 'org-agenda)

(add-to-list 'org-modules 'org-habit)

(setq org-root-path "~/Nextcloud/workflow/org")
(setq org-refile-file "~/Nextcloud/workflow/org/refile.org")
(setq org-journal-file "~/Nextcloud/workflow/org/journal.org")

(setq org-enforce-todo-dependencies t ; can't close without subtasks being done
      org-use-fast-todo-selection t)

(setq org-todo-keywords
      '((sequence "TODO(t)" "|" "DONE(d)")
	(sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)" "MEETING")))

(setq org-todo-keyword-faces
      '(("TODO" :foreground "red" :weight bold)
	("DONE" :foreground "forest green" :weight bold)
	("WAITING" :foreground "orange" :weight bold)
	("HOLD" :foreground "magenta" :weight bold)
	("CANCELLED" :foreground "forest green" :weight bold)
	("MEETING" :foreground "forest green" :weight bold)))

(defun fury/org-file (filename)
  "Create a file name in our org directory"
  (interactive)
  (concat org-root-path "/" filename))

;; Agenda - load all files under this directory
(setq org-agenda-files
      (list org-root-path))

;; Do not dim blocked tasks
(setq org-agenda-dim-blocked-tasks nil)

;; Compact the block agenda view
(setq org-agenda-compact-blocks t)

;; Custom agenda command definitions
(defvar  bh/hide-scheduled-and-waiting-next-tasks t)

;; stuck projects 
;;(setq org-stuck-projects '("" ("TODO") nil ""))

;; Sacha
(defun my/org-agenda-done (&optional arg)
  "Mark current TODO as done.
This changes the line at point, all other lines in the agenda referring to
the same tree node, and the headline of the tree node in the Org-mode file."
  (interactive "P")
  (org-agenda-todo "DONE"))
;; Override the key definition for org-exit
(define-key org-agenda-mode-map "x" 'my/org-agenda-done)

  (defun my/org-agenda-mark-done-and-add-followup ()
    "Mark the current TODO as done and add another task after it.
Creates it at the same level as the previous task, so it's better to use
this with to-do items than with projects or headings."
    (interactive)
    (org-agenda-todo "DONE")
    (org-agenda-switch-to)
    (org-capture 0 "t"))

;; Override the key definition
(define-key org-agenda-mode-map "X" 'my/org-agenda-mark-done-and-add-followup)

;; end Sacha
;;(defun bh/is-project-p ()
;;  "Any task with a todo keyword subtask"
;;  (save-restriction
;;    (widen)
;;    (let ((has-subtask)
;;          (subtree-end (save-excursion (org-end-of-subtree t)))
;;          (is-a-task (member (nth 2 (org-heading-components)) org-todo-keywords-1)))
;;      (save-excursion
;;        (forward-line 1)
;;        (while (and (not has-subtask)
;;                    (< (point) subtree-end)
;;                    (re-search-forward "^\*+ " subtree-end t))
;;          (when (member (org-get-todo-state) org-todo-keywords-1)
;;            (setq has-subtask t))))
;;      (and is-a-task has-subtask))))
;;
;;(defun bh/is-project-subtree-p ()
;;  "Any task with a todo keyword that is in a project subtree.
;;Callers of this function already widen the buffer view."
;;  (let ((task (save-excursion (org-back-to-heading 'invisible-ok)
;;                              (point))))
;;    (save-excursion
;;      (bh/find-project-task)
;;      (if (equal (point) task)
;;          nil
;;        t))))
;;
;;(defun bh/is-task-p ()
;;  "Any task with a todo keyword and no subtask"
;;  (save-restriction
;;    (widen)
;;    (let ((has-subtask)
;;          (subtree-end (save-excursion (org-end-of-subtree t)))
;;          (is-a-task (member (nth 2 (org-heading-components)) org-todo-keywords-1)))
;;      (save-excursion
;;        (forward-line 1)
;;        (while (and (not has-subtask)
;;                    (< (point) subtree-end)
;;                    (re-search-forward "^\*+ " subtree-end t))
;;          (when (member (org-get-todo-state) org-todo-keywords-1)
;;            (setq has-subtask t))))
;;      (and is-a-task (not has-subtask)))))
;;
;;(defun bh/is-subproject-p ()
;;  "Any task which is a subtask of another project"
;;  (let ((is-subproject)
;;        (is-a-task (member (nth 2 (org-heading-components)) org-todo-keywords-1)))
;;    (save-excursion
;;      (while (and (not is-subproject) (org-up-heading-safe))
;;        (when (member (nth 2 (org-heading-components)) org-todo-keywords-1)
;;          (setq is-subproject t))))
;;    (and is-a-task is-subproject)))
;;
;;(defun bh/list-sublevels-for-projects-indented ()
;;  "Set org-tags-match-list-sublevels so when restricted to a subtree we list all subtasks.
;;  This is normally used by skipping functions where this variable is already local to the agenda."
;;  (if (marker-buffer org-agenda-restrict-begin)
;;      (setq org-tags-match-list-sublevels 'indented)
;;    (setq org-tags-match-list-sublevels nil))
;;  nil)
;;
;;(defun bh/list-sublevels-for-projects ()
;;  "Set org-tags-match-list-sublevels so when restricted to a subtree we list all subtasks.
;;  This is normally used by skipping functions where this variable is already local to the agenda."
;;  (if (marker-buffer org-agenda-restrict-begin)
;;      (setq org-tags-match-list-sublevels t)
;;    (setq org-tags-match-list-sublevels nil))
;;  nil)
;;
;;(defvar bh/hide-scheduled-and-waiting-next-tasks t)
;;
;;(defun bh/toggle-next-task-display ()
;;  (interactive)
;;  (setq bh/hide-scheduled-and-waiting-next-tasks (not bh/hide-scheduled-and-waiting-next-tasks))
;;  (when  (equal major-mode 'org-agenda-mode)
;;    (org-agenda-redo))
;;  (message "%s WAITING and SCHEDULED NEXT Tasks" (if bh/hide-scheduled-and-waiting-next-tasks "Hide" "Show")))
;;
;;(defun bh/skip-stuck-projects ()
;;  "Skip trees that are not stuck projects"
;;  (save-restriction
;;    (widen)
;;    (let ((next-headline (save-excursion (or (outline-next-heading) (point-max)))))
;;      (if (bh/is-project-p)
;;          (let* ((subtree-end (save-excursion (org-end-of-subtree t)))
;;                 (has-next ))
;;            (save-excursion
;;              (forward-line 1)
;;              (while (and (not has-next) (< (point) subtree-end) (re-search-forward "^\\*+ NEXT " subtree-end t))
;;                (unless (member "WAITING" (org-get-tags-at))
;;                  (setq has-next t))))
;;            (if has-next
;;                nil
;;              next-headline)) ; a stuck project, has subtasks but no next task
;;        nil))))
;;
;;(defun bh/skip-non-stuck-projects ()
;;  "Skip trees that are not stuck projects"
;;  ;; (bh/list-sublevels-for-projects-indented)
;;  (save-restriction
;;    (widen)
;;    (let ((next-headline (save-excursion (or (outline-next-heading) (point-max)))))
;;      (if (bh/is-project-p)
;;          (let* ((subtree-end (save-excursion (org-end-of-subtree t)))
;;                 (has-next ))
;;            (save-excursion
;;              (forward-line 1)
;;              (while (and (not has-next) (< (point) subtree-end) (re-search-forward "^\\*+ NEXT " subtree-end t))
;;                (unless (member "WAITING" (org-get-tags-at))
;;                  (setq has-next t))))
;;            (if has-next
;;                next-headline
;;              nil)) ; a stuck project, has subtasks but no next task
;;        next-headline))))
;;
;;(defun bh/skip-non-projects ()
;;  "Skip trees that are not projects"
;;  ;; (bh/list-sublevels-for-projects-indented)
;;  (if (save-excursion (bh/skip-non-stuck-projects))
;;      (save-restriction
;;        (widen)
;;        (let ((subtree-end (save-excursion (org-end-of-subtree t))))
;;          (cond
;;           ((bh/is-project-p)
;;            nil)
;;           ((and (bh/is-project-subtree-p) (not (bh/is-task-p)))
;;            nil)
;;           (t
;;            subtree-end))))
;;    (save-excursion (org-end-of-subtree t))))
;;
;;(defun bh/skip-non-tasks ()
;;  "Show non-project tasks.
;;Skip project and sub-project tasks, habits, and project related tasks."
;;  (save-restriction
;;    (widen)
;;    (let ((next-headline (save-excursion (or (outline-next-heading) (point-max)))))
;;      (cond
;;       ((bh/is-task-p)
;;        nil)
;;       (t
;;        next-headline)))))
;;
;;(defun bh/skip-project-trees-and-habits ()
;;  "Skip trees that are projects"
;;  (save-restriction
;;    (widen)
;;    (let ((subtree-end (save-excursion (org-end-of-subtree t))))
;;      (cond
;;       ((bh/is-project-p)
;;        subtree-end)
;;       ((org-is-habit-p)
;;        subtree-end)
;;       (t
;;        nil)))))
;;
;;(defun bh/skip-projects-and-habits-and-single-tasks ()
;;  "Skip trees that are projects, tasks that are habits, single non-project tasks"
;;  (save-restriction
;;    (widen)
;;    (let ((next-headline (save-excursion (or (outline-next-heading) (point-max)))))
;;      (cond
;;       ((org-is-habit-p)
;;        next-headline)
;;       ((and bh/hide-scheduled-and-waiting-next-tasks
;;             (member "WAITING" (org-get-tags-at)))
;;        next-headline)
;;       ((bh/is-project-p)
;;        next-headline)
;;       ((and (bh/is-task-p) (not (bh/is-project-subtree-p)))
;;        next-headline)
;;       (t
;;        nil)))))
;;
;;(defun bh/skip-project-tasks-maybe ()
;;  "Show tasks related to the current restriction.
;;When restricted to a project, skip project and sub project tasks, habits, NEXT tasks, and loose tasks.
;;When not restricted, skip project and sub-project tasks, habits, and project related tasks."
;;  (save-restriction
;;    (widen)
;;    (let* ((subtree-end (save-excursion (org-end-of-subtree t)))
;;           (next-headline (save-excursion (or (outline-next-heading) (point-max))))
;;           (limit-to-project (marker-buffer org-agenda-restrict-begin)))
;;      (cond
;;       ((bh/is-project-p)
;;        next-headline)
;;       ((org-is-habit-p)
;;        subtree-end)
;;       ((and (not limit-to-project)
;;             (bh/is-project-subtree-p))
;;        subtree-end)
;;       ((and limit-to-project
;;             (bh/is-project-subtree-p)
;;             (member (org-get-todo-state) (list "NEXT")))
;;        subtree-end)
;;       (t
;;        nil)))))
;;
;;(defun bh/skip-project-tasks ()
;;  "Show non-project tasks.
;;Skip project and sub-project tasks, habits, and project related tasks."
;;  (save-restriction
;;    (widen)
;;    (let* ((subtree-end (save-excursion (org-end-of-subtree t))))
;;      (cond
;;       ((bh/is-project-p)
;;        subtree-end)
;;       ((org-is-habit-p)
;;        subtree-end)
;;       ((bh/is-project-subtree-p)
;;        subtree-end)
;;       (t
;;        nil)))))
;;
;;(defun bh/skip-non-project-tasks ()
;;  "Show project tasks.
;;Skip project and sub-project tasks, habits, and loose non-project tasks."
;;  (save-restriction
;;    (widen)
;;    (let* ((subtree-end (save-excursion (org-end-of-subtree t)))
;;           (next-headline (save-excursion (or (outline-next-heading) (point-max)))))
;;      (cond
;;       ((bh/is-project-p)
;;        next-headline)
;;       ((org-is-habit-p)
;;        subtree-end)
;;       ((and (bh/is-project-subtree-p)
;;             (member (org-get-todo-state) (list "NEXT")))
;;        subtree-end)
;;       ((not (bh/is-project-subtree-p))
;;        subtree-end)
;;       (t
;;        nil)))))
;;
;;(defun bh/skip-projects-and-habits ()
;;  "Skip trees that are projects and tasks that are habits"
;;  (save-restriction
;;    (widen)
;;    (let ((subtree-end (save-excursion (org-end-of-subtree t))))
;;      (cond
;;       ((bh/is-project-p)
;;        subtree-end)
;;       ((org-is-habit-p)
;;        subtree-end)
;;       (t
;;        nil)))))
;;
;;(defun bh/skip-non-subprojects ()
;;  "Skip trees that are not projects"
;;  (let ((next-headline (save-excursion (outline-next-heading))))
;;    (if (bh/is-subproject-p)
;;        nil
;;      next-headline)))
;;;;stop
;;
;;
;;(defun bh/find-project-task ()
;;  "Move point to the parent (project) task if any"
;;  (save-restriction
;;    (widen)
;;    (let ((parent-task (save-excursion (org-back-to-heading 'invisible-ok) (point))))
;;      (while (org-up-heading-safe)
;;        (when (member (nth 2 (org-heading-components)) org-todo-keywords-1)
;;          (setq parent-task (point))))
;;      (goto-char parent-task)
;;      parent-task)))
;;
;;(setq org-agenda-custom-commands
 ;;     '(("w" todo "WAITING" nil) 
;;	("n" todo "NEXT" nil);
;;	("d" "Agenda + Next Actions" ((agenda) (todo "NEXT")))))
(setq org-agenda-custom-commands
      (quote (("N" "Notes" tags "NOTE"
               ((org-agenda-overriding-header "Notes")
                (org-tags-match-list-sublevels t)))
	      ("Q" "Questions" tags "QUESTION"
	       ((org-agenda-overriding-header "Questions")
		(org-tags-match-list-sublevels t )))
	      ("d" "Daily" ((agenda)(todo "TODO")))
	      ("w" "Waiting" ((todo "WAITING")))
              ("h" "Habits" tags-todo "STYLE=\"habit\""
               ((org-agenda-overriding-header "Habits")
                (org-agenda-sorting-strategy
                 '(todo-state-down effort-up category-keep))))
              (" " "Review"
	       ((agenda "" nil)
                (tags "REFILE"
                      ((org-agenda-overriding-header "Tasks to Refile")
                       (org-tags-match-list-sublevels nil)))
		;; Stuck Projects
		;; Current TODOs
		(todo "WAITING|HOLD"
		      ((org-agenda-overriding-header "Waiting and Postponed Tasks")
		       (org-tags-match-list-sublevels nil)))

		;; Someday/Maybe Projects
		;; tasks to Archive
		)))))

;; Org capture
(setq org-capture-templates
      '(("t" "Todo" entry (file org-refile-file)
	 "* TODO %?")
	("r" "Respond" entry (file org-refile-file)
	 "* TODO Respond to %:from on %:subject")
	("i" "Interuption" entry (file org-refile-file)
	 "* DONE %?\nSCHEDULED: <%(org-read-date nil nil nil)>" :clock-in :clock-resume)
	("n" "Note" entry (file org-refile-file)
	 "* %? :NOTE:")
	("Q" "Question" entry (file org-refile-file)
	 "* %? :QUESTION:")
	("m" "Meeting" (file org-refile-file)
	 "* MEETING with %? :MEETING:")
	("j" "Journal Entry" entry (file+datetree+prompt org-journal-file)
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

