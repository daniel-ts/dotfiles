(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/") t)
(add-to-list 'package-archives '("nongnu" . "https://elpa.nongnu.org/nongnu/") t)
;; (setq package-refresh-contents-hook nil)

(customize-set-variable
 'package-vc-selected-packages
 '((anki-editor . (:url
                       "https://github.com/orgtre/anki-editor.git"
                       :branch "master"))))

(use-package exec-path-from-shell
  :ensure t
  :demand t
  :init
  (customize-set-variable 'exec-path-from-shell-variables
                          '("PATH" "MANPATH" "INFOPATH"
                            "WORKON_HOME" "SSH_AUTH_SOCK"
                            "XDG_SESSION_TYPE" "WAYLAND_DISPLAY"
                            "EDITOR" "VISUAL" "XDG_CONFIG_HOME"))
  (exec-path-from-shell-initialize)
  (unless (getenv "WAYLAND_DISPALY")
    (setenv "WAYLAND_DISPLAY" "wayland-1"))
  (unless (getenv "XDG_SESSION_TYPE")
    (setenv "XDG_SESSION_TYPE" "wayland"))
  )

(use-package dash
  :ensure t
  :demand t)

(use-package emacs
  :config
  (defun set-c-indentation ()
    (setq-default indent-tabs-mode nil)
    (setq-default tab-width 4))

  (defun dt/clean-region-after-pdf-copy (pmin pmax)
    (interactive "r")
    (cl-flet ((clean-forward ()
                ;; clean newline
                (save-excursion
                  (while (re-search-forward (char-to-string #xa) nil t)
                    (replace-match " " nil nil)))
                ;; clean line continuation
                (save-excursion
                  (while (re-search-forward "- " nil t)
                    (replace-match "" nil nil)))
                ;; clean weird double dash
                (save-excursion
                  (while (re-search-forward "-­" nil t)
                    (replace-match "-" nil nil)))))
      (if (= pmin pmax)
          (clean-forward)
        (with-narrowing pmin pmax
                        (goto-char (point-min))
                        (clean-forward)))))

  (defun dt/switch-theme (theme)
    ;; This interactive call is taken from `load-theme'
    (interactive
     (list
      (intern (completing-read "Load custom theme: "
                               (mapcar 'symbol-name
                                       (custom-available-themes))))))
    (mapcar #'disable-theme custom-enabled-themes)
    (load-theme theme t))

  (defun dt/rename-buffer ()
    "Rename buffer with current buffer name as default value.  Wrapper around 'rename-buffer'."
    (interactive)
    (rename-buffer
     (read-from-minibuffer "Rename buffer (to new name):  " (buffer-name) nil nil
                           nil nil nil)))

  (defun dt/open-cwd-in-kitty ()
    (interactive)
    (start-process "kitty" nil "kitty" "--detach" "--directory" default-directory))

  (defun dt/anki-push-note (begin end)
    (interactive "r")
    (save-excursion
      (narrow-to-region begin end)
      (anki-editor-push-notes)
      (widen))))

(use-package compat
  :ensure t)

(use-package emacsql-sqlite-builtin
  :ensure t)

(use-package gotham-theme
  :ensure t)

(use-package doom-themes
  :ensure t)

(use-package emacs
  :init
  (prefer-coding-system 'utf-8)
  (set-terminal-coding-system 'utf-8)
  (set-buffer-file-coding-system 'utf-8)
  (global-auto-revert-mode t)

  (setq inhibit-startup-screen t)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (menu-bar-mode -1)
  (blink-cursor-mode 0)

  (when (fboundp 'native-compile-async)
    (setq comp-deferred-compilation t
          comp-deferred-compilation-black-list '("/mu4e.*\\.el$")))

  (setq native-comp-async-report-warnings-errors 'silent) ; emacs28 with native compilation

  :hook
  ;; prog-mode
  (prog-mode . display-line-numbers-mode)
  (scheme-mode . display-line-numbers-mode)
  (conf-mode . display-line-numbers-mode)
  (prog-mode . auto-revert-mode)

  ;; other
  (before-save . delete-trailing-whitespace)

  :config
  (defalias 'yes-or-no-p 'y-or-n-p)
  (put 'dired-find-alternate-file 'disabled nil)
  (put 'upcase-region 'disabled nil)
  (put 'downcase-region 'disabled nil)

  (when (display-graphic-p)
    (setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING)))

  (setq initial-scratch-message (concat ";; Daniel Tschertkow - " (format-time-string "%d-%m-%Y") "\n"))
  (setq default-directory "~/")
  (setq make-backup-files nil)
  (add-to-list 'backup-directory-alist
             (cons tramp-file-name-regexp nil))

  (global-visual-line-mode 1)
  (column-number-mode 1)
  (setq-default indent-tabs-mode nil)
  (setq-default tab-width 4)

  (cond ((string= (system-name) "arch") (dt/switch-theme 'doom-horizon))
	(t (dt/switch-theme 'doom-gruvbox)))

  (add-to-list 'default-frame-alist '(alpha-background . 82))
  (set-face-attribute 'default nil :height 105 :font "JetBrains Mono" :weight 'normal)
  )

(use-package emacs
  :init
  ;; behavior of opened and buffers
  ;; (setq pop-up-frames 'graphic-only)
  ;; (setq display-buffer-alist nil)


  ;; (add-to-list 'display-buffer-alist '("^magit:.*" display-buffer-at-bottom) t)
  (setq frame-auto-hide-function 'delete-frame)
  (setq mouse-autoselect-window nil)
  (setq focus-follows-mouse nil)

  (defun kill-frame-if-sole-buffer-killed ()
    "Kill a frame when it's buffer is killed and no other windows are displayed in this frame."
    (when window-system
      (let* ((current-buffer-window (get-buffer-window (current-buffer) 0))
             (buffer-frame (window-frame current-buffer-window))
             (window-count (length (window-list buffer-frame))))
        (when current-buffer-window ;; if buffer is displayed
          (if (eql window-count 1)
              (delete-frame buffer-frame)
            (delete-window current-buffer-window))))))
  :hook
  (kill-buffer . kill-frame-if-sole-buffer-killed)

  :custom
  (display-buffer-base-action '((display-buffer-reuse-window display-buffer-pop-up-frame) (reusable-frames . 0)))
  (display-buffer-alist '(("^magit:.*" display-buffer-at-bottom)
                          ("^\\*Org Links\\*.*" display-buffer-at-bottom)
                          ("^\\*Warnings\\*.*" display-buffer-at-bottom)
                          ("^\\*Geiser Debug\\*.*" display-buffer-at-bottom)
                          ("^ \\*Agenda Commands\\*" display-buffer-at-bottom)
                          ("^\\*Org Select\\*" display-buffer-at-bottom)
                          ("^\\*Org Attach\\*" display-buffer-at-bottom)
                          ("^\\*Calendar\\*" display-buffer-at-bottom)
                          ("^\\*Org Export Dispatcher*\\*" display-buffer-at-bottom)
                          ("^\\*Bookmark List\\*.*" (display-buffer-same-window display-buffer-pop-up-frame))))
  ;; (setq display-buffer-alist nil)
  )

(use-package org
  :init
  ;; must be set before loading org
  ;; for ctrlf search
  (setq org-fold-core-style 'overlays)

  :hook
  ((org-mode . turn-on-font-lock)
   (org-mode . org-indent-mode)
   (org-mode . company-mode))

  :bind ((:map org-mode-map
               ;; ("C-c n d c" . org-download-clipboard)
               ;; ("C-c TAB" . org-toggle-item))
               )
         (:map global-map
               ("C-c c" . org-capture)
               ("C-c i" . org-capture-inbox)
               ("C-c l" . org-store-link)
               ("C-c a" . org-agenda)
               ("C-< i" . dt/org-capture-transient)
               ("C-< a" . dt/org-agenda-transient)
               ))

  :custom
  ;; org files
  (org-directory "~/org")
  (org-attach-id-dir "attachments/")
  (org-attach-dir-relative t)
  (org-attach-method 'cp) ;; 'mv also possible
  (org-default-notes-file "notes.org")
  (org-agenda-files (list "gtd.org" "inbox.org" "tickler.org" "anniversaries.org"))
  (org-refile-targets '(("gtd.org" . (:maxlevel . 3))
                        ("someday.org" . (:maxlevel . 1))
                        ("cooking.org" . (:maxlevel . 1))
                        ("tickler.org" . (:maxlevel . 1))))
  (org-refile-target-verify-function #'(lambda ()
                                         "Additional refiling rules"
                                         ;; do not refile to a task
                                         (if (org-get-todo-state)
                                             nil ;; has todo state like TODO => not a refile target
                                           t)))
  (org-log-done nil)
  (org-agenda-prefix-format '((agenda . " %i %-12:c%?-12t% s")
                              (todo   . " %i %-12:c")
                              (tags   . " %i %-12:c")
                              (search . " %i %-12:c")))
  (org-capture-templates
   `(("i" "Inbox" entry  (file "inbox.org")
      ,(concat "* %?\n"
               "/Entered on/ %U"))
     ("bi" "org-protocol from Browser to Inbox" entry  (file "inbox.org")
      ,(concat "* %:description  :bookmark: \n"
               "%i\n"
               "%:annotation\n"
               "/Entered on/ %U"))
     ("m" "Meeting" entry  (file+headline "tickler.org" "Inbox")
      ,(concat "* %? :meeting:\n"
               "<%<%Y-%m-%d %a %H:00>>"))
     ("e" "Event" entry  (file+headline "tickler.org" "Inbox")
      ,(concat "* %? :event:\n"
               "<%<%Y-%m-%d %a %H:00>>"))
     ))

  :config
  (require 'dash)
  (require 'org-protocol)
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;    org agenda tweaks for GTD    ;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  (setq org-agenda-custom-commands
      '(("g" "Get Things Done (GTD)"
         ((agenda ""
                  ((org-deadline-warning-days 10)
                   (org-agenda-prefix-format "\t%i %s %t ")))
          ;; (alltodo ""
          ;;          ((org-agenda-overriding-header "Tasks\n")
          ;;           (org-agenda-skip-function
          ;;            '(org-agenda-skip-entry-if 'deadline 'scheduled))
          ;;           (org-agenda-prefix-format " %i %.30b\t")))
          (tags "projects"
                   ((org-agenda-overriding-header "Tasks\n")
                    (org-agenda-skip-function
                     '(org-agenda-skip-entry-if 'deadline 'scheduled))
                    (org-agenda-prefix-format "\t%i %l")))
          (tags "projects"
                ((org-agenda-overriding-header "Projects\n")
                 (org-agenda-skip-function
                  #'(lambda ()
                      "Skips item unless the following conditions are true"
                      (unless (and (eql (org-outline-level) 2)
                                   (eq (org-get-todo-state) nil))
                        (or (outline-next-heading)
                            (goto-char (point-max))))))
                (org-agenda-prefix-format "\t")))
          (tags "inbox"
                ((org-agenda-prefix-format "  %?-12t% s")
                 (org-agenda-overriding-header "\nInbox\n")
                 (org-agenda-skip-function)))
          (tags "CLOSED>=\"<today>\""
                ((org-agenda-overriding-header "\nCompleted today\n")))))

        ("A" "Next two weeks"
         ((agenda ""
                  ((org-agenda-overriding-header "\nNext 14 days\n\n")
                   (org-agenda-prefix-format "\t%i %s\t")
                   (org-agenda-span 15)
                   (start-on-weekday nil)))))
        ("h" "At home" tags "+@home")
        ("v" "At VRalive" tags "+@VRalive")
        ("p" "In Hamburg" tags "+@hamburg")
        ("w" "Waiting" todo "WAIT" ((org-agenda-prefix-format "%i %b\t\t")))
        ;; ("b" "Buy" tags "+buy")
        ("b" "Buy"
         ((tags "+buy"
                ((org-agenda-prefix-format "\t%l")))))
        ("D" "Done tasks" todo "DONE")
        ("s" "Someday/Maybe" tags "+someday"
         ((org-agenda-files '("someday.org"))
          (org-agenda-text-search-extra-files nil)))
      ))


  (defun org-capture-inbox ()
     (interactive)
     ;;(call-interactively 'org-store-link)
     (org-capture nil "i"))

  (defun dt/org-capture-transient ()
    (interactive)
    (let ((org-directory "~/.cache/org-capture-transient")
          (org-agenda-files '("transient.org"))
          (org-capture-templates
           `(("i" "Inbox" entry  (file "transient.org")
              ,(concat "* TODO %?\n"
                       "/Relating to/ [[%F][%f]]")))))
      (org-capture nil "i")))

  (defun dt/org-agenda-transient ()
    (interactive)
    (let ((org-directory "~/.cache/org-capture-transient")
          (org-agenda-files '("transient.org"))
          (org-agenda-custom-commands
           '(("i" "Transient tasks" todo "TODO" ((org-agenda-prefix-format "\t%i *%l"))))))
      (org-agenda nil "i" nil)))

  ;; org export will only use the minibuffer until ? is pressed
  (setq org-export-dispatch-use-expert-ui t)

  ;; general
  (set 'org-agenda-window-setup 'other-frame)
  (setq org-startup-folded "content") ; "fold", "nofold", "content", "showeverything"
  (setq org-startup-with-inline-images t)
  (add-to-list 'org-latex-packages-alist '("" "tabularx" nil))
  (add-to-list 'org-latex-packages-alist '("" "float" nil))

  ;; org will use frames
  (setq org-link-frame-setup
        (quote
         ((vm . vm-visit-folder-other-frame)
          (vm-imap . vm-visit-imap-folder-other-frame)
          (gnus . org-gnus-no-new-news)
          (file . find-file-other-frame)
          (wl . wl-other-frame))))
  (setq org-src-window-setup 'other-frame)
  (setq org-agenda-window-setup 'other-frame)


  ;; org babel
  (setq org-src-preserve-indentation t)
  (org-babel-do-load-languages 'org-babel-load-languages
                               '((awk . t)
                                 (shell . t)
                                 (python . t)
                                 (R . t)
                                 (emacs-lisp . t)
                                 (dot . t)
                                 (scheme . t)))

  ;; org latex
  (setq org-latex-compiler "pdflatex")
  ;;(setq org-format-latex-options (plist-put org-format-latex-options :scale 1.7))
  (plist-put org-format-latex-options :scale 1.7)
  (add-to-list 'org-latex-packages-alist
               '("AUTO" "babel" t ("pdflatex")))

  ;; some useful org kbd macros
  (defalias 'dt/org-bolden-bullet
   (kmacro "* C-s : <return> C-b * C-n C-a")
   )) ;; end of usepackage org

(use-package oc-biblatex
  :config
  (setq org-cite-export-processors
	'((latex biblatex)
	  (t basic))))

(use-package org-download
  :ensure t
  :after org
  :bind (:map org-mode-map
              ("C-c n d c" . org-download-clipboard)))

(use-package ox-latex
  :config
  (setq org-latex-hyperref-template "")
  ;; article classes
  (add-to-list 'org-latex-classes
               '("tubsartcl"
                 "\\documentclass[a4paper, 12pt, blue]{tubsartcl}
  [NO-DEFAULT-PACKAGES]
  [PACKAGES]
  [EXTRA]"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}")
                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

  ;; article classes
  (add-to-list 'org-latex-classes
               '("tubsthesis"
                 "\\documentclass[german=true,thesistype=bachelor,nolistoffigures,nodate]{tubsthesis}
  [NO-DEFAULT-PACKAGES]
  [PACKAGES]
  [EXTRA]"
                 ("\\chapter{%s}" . "\\chapter*{%s}")
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}")
                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))


  (add-to-list 'org-latex-classes
               '("tubsbeamer"
                 "\\documentclass[fleqn,11pt,aspectratio=1610]{beamer}
  [NO-DEFAULT-PACKAGES]
  [PACKAGES]
  [EXTRA]"
                 ("\\part{%s}" . "\\part*{%s}")
                 ("\\frame{%s}" . "\\frame*{%s}")))

  )

(use-package org-roam
  :ensure t
  :diminish org-roam-mode
  :custom
  (org-roam-directory "~/org/wiki/")
  (org-roam-completion-everywhere t)
  (org-roam-node-display-template (concat "${title:*} " (propertize "${tags:30}" 'face 'org-tag)))

  :init
  (setq org-roam-v2-ack t)

  :config
  (push 'company-capf company-backends)
  (org-roam-db-autosync-mode)

  :bind (("C-c n f" . org-roam-node-find)
         :map org-mode-map
         ("C-c n i" . org-roam-node-insert)
         ("C-c n e" . org-roam-extract-subtree)
         ("C-c n n" . org-roam-buffer-toggle)
         ("C-c n N" . org-roam-buffer-display-dedicated)
         ("C-c n a" . org-roam-alias-add)
         ("C-c n r" . org-roam-ref-add)
         ("C-c n t" . org-roam-tag-add)

         ("C-c n g r" . org-roam-ref-find) ; get reference

         ("C-c n k a" . org-roam-alias-remove) ; kill alias
         ("C-c n k r" . org-roam-ref-remove) ; kill reference
         ("C-c n k t" . org-roam-tag-remove) ; kill reference
	 ))

(use-package anki-editor
  ;; :init (package-vc-install
  ;;        '(anki-editor . (:url
  ;;                          "https://github.com/orgtre/anki-editor.git"
  ;;                          :branch "master")))
  ;; :ensure t ;; (anki-editor :type git :host github :repo "orgtre/anki-editor")
  :bind
  (:map anki-editor-mode-map
        ("C-c A p" . #'dt/anki-push-note)
        ("C-c A n" . (lambda (&optional prefix)
		               "Modified version of `anki-editor-insert-note'."
		               (interactive "P")
		               (let* ((deck (org-entry-get-with-inheritance anki-editor-prop-deck))
			                  (type "Einfach")
			                  (fields (anki-editor-api-call-result 'modelFieldNames
							                                       :modelName type))
			                  (heading "Item"))
		                 (anki-editor--insert-note-skeleton prefix deck heading type fields)))))
  :config
  (setq anki-editor-create-decks t))

(use-package bookmark
  :hook
  (bookmark-after-jump . (lambda ()
                           (kill-buffer "*Bookmark List*")))
  (bookmark-bmenu-mode . (lambda ()
                           (local-unset-key (kbd "/"))
                           (local-unset-key (kbd "a"))
                           (local-unset-key (kbd "A"))
                           (local-unset-key (kbd "o"))

                           (local-set-key (kbd "j") #'next-line)
                           (local-set-key (kbd "k") #'previous-line)
                           (local-set-key (kbd "<return>") #'bookmark-bmenu-other-frame)
                           ))
  ;; (setq bookmark-bmenu-mode-hook nil)

  :config
  (defun bookmark-bmenu-list ()
    "Display a list of existing bookmarks.
The list is displayed in a buffer named `*Bookmark List*'.
The leftmost column displays a D if the bookmark is flagged for
deletion, or > if it is flagged for displaying.

Note: I customized this function to always pop-to-buffer."
    (interactive)
    (bookmark-maybe-load-default-file)
    (let ((buf (get-buffer-create bookmark-bmenu-buffer)))
      (with-current-buffer buf
        ;; (display-buffer buf '(display-buffer-same-window))
        (display-buffer buf)
        (bookmark-bmenu-mode)
        (bookmark-bmenu--revert))))

  :custom
  (bookmark-save-flag 1)
  (bookmark-default-file "~/.emacs.d/bookmarks")
  (bookmark-bmenu-file-column 40))

(use-package prescient
  :ensure t)

(use-package selectrum-prescient
  :ensure t)

(use-package selectrum
  :ensure t
  :init
  (selectrum-mode +1)
  (selectrum-prescient-mode +1)
  (prescient-persist-mode +1)
  :config
  (setq prescient-filter-method 'regexp))

(use-package ctrlf
  :ensure t
  :bind (:map ctrlf-mode-map
	 ("C-s" . ctrlf-forward-fuzzy-regexp)
	 ("C-r" . ctrlf-backward-fuzzy-regexp)
	 ("C-M-s" . ctrlf-forward-literal)
	 ("C-M-r" . ctrlf-backward-literal)
	 ("M-s _" . ctrlf-forward-regexp))

  :custom
  (ctrlf-auto-recenter t)
  :init
  (ctrlf-mode +1))
(setq ctrlf-auto-recenter t)
(use-package diminish
  :ensure t)

(use-package dired-x
  :after dired)

(use-package dired-aux
  :after dired)

(use-package dired-hide-dotfiles
  :ensure t
  :after dired)

;; (use-package dired-subtree
;;   :after dired)

(use-package dired
  :config
  (defun dt/dired-open-file ()
    "In dired, open the file named on this line."
    (interactive)
    (let* ((file (dired-get-filename nil t)))
      (message "Opening %s..." file)
      (call-process "xdg-open" nil 0 nil file)
      (message "Opening %s done" file)))

  ;; (local-unset-key (kbd "u"))
  ;; (local-unset-key (kbd "U"))
  :bind
  ("C-< o" . dt/dired-open-file)
  (:map dired-mode-map
        ("H" . dired-hide-details-mode)
        ("h" . dired-hide-dotfiles-mode)
        ("I" . dired-kill-subdir)
        ("z" . (lambda ()
                 (interactive)
                 (let ((kill-buffer-hook nil))
                   (find-alternate-file ".."))))
        ("RET" . (lambda ()
                   (interactive)
                   (if (dired-nondirectory-p (thing-at-point 'filename))
                       (dired-find-file-other-window)
                     (let ((kill-buffer-hook nil))
                       (dired-find-alternate-file)))))
        ("C-a a" . #'org-attach-dired-to-subtree)
        )

  :hook
  (dired-mode . dired-hide-dotfiles-mode)
  :custom
  (dired-listing-switches "--all -l --human-readable --group-directories-first"))

(use-package dockerfile-mode
  :ensure t)

(use-package dockerfile-ts-mode
  :after dockerfile-mode
  :mode
  ("Dockerfile\\'" . dockerfile-mode)
  ("Containerfile\\'" . dockerfile-mode))

(use-package flyspell
  :ensure t
  :hook latex-mode
  :config
  (setq ispell-list-command "--list")
  (setq flyspell-default-dictionary "de_DE"))

;; (use-package json-navigator
;;   :ensure t
;;   :config (require 'hierarchy))

(use-package magit
  :ensure t)

(use-package markdown-mode
  :ensure t
  :mode ("\\.md\\'" . markdown-mode))

(use-package notmuch-addr
  :ensure t)

(use-package notmuch
  :ensure t
  :custom
  (notmuch-search-oldest-first nil)
  (notmuch-address-use-company t)
  (notmuch-search-result-format '(
                                  ("date" . "%12s ")
                                  ("count" . " %-7s ")
                                  ("authors" . "%-20s ")
                                  ("subject" . "%s ")
                                  ("tags" . "(%s)")))
  :config
  (with-eval-after-load 'notmuch-address
    (require 'notmuch-addr)
    (notmuch-addr-setup)))

(use-package nov
  :ensure t
  :mode ("\\.epub\\'" . nov-mode)
  :config
  (setq nov-text-width 80))

(use-package openwith
  :ensure t
  :config
  (setq openwith-associations
            (list
             (list (openwith-make-extension-regexp
                    '("mpg" "mpeg" "mp3" "mp4"
                      "avi" "wmv" "wav" "mov" "flv"
                      "ogm" "ogg" "mkv"))
                   "vlc"
                   '(file))
             (list (openwith-make-extension-regexp
                    '("doc" "xls" "ppt" "odt" "ods" "odg" "odp"))
                   "libreoffice"
                   '(file))
             (list (openwith-make-extension-regexp
                    '("pdf" "ps" "ps.gz" "dvi"))
                   "evince"
                   '(file))
             ))
  (openwith-mode 1))

(use-package rainbow-mode
  :ensure t)

(use-package restclient
  :ensure t)

(use-package company-restclient
  :ensure t)

(use-package tramp
  :custom
  (tramp-termial-type "dumb")
  (tramp-default-method "ssh"))

(use-package tramp-container)

(use-package treesit
  :custom
  (major-mode-remap-alist
   '((css-mode . css-ts-mode)
     (dockerfile-mode . dockerfile-ts-mode)
     (go-mode . go-ts-mode)
     ;; (hcl-mode . hcl-ts-mode)
     (html-mode . html-ts-mode)
     ;; (javascript-mode . )
     ;; (latex . -ts-mode)
     (python-mode . python-ts-mode)
     (conf-toml-mode . toml-ts-mode)
     (typescript-mode . typescipt-ts-mode)
     (yaml-mode . yaml-ts-mode)))

  :config
  (use-package combobulate
    :preface
    ;; You can customize Combobulate's key prefix here.
    ;; Note that you may have to restart Emacs for this to take effect!
    (setq combobulate-key-prefix "C-c o")

    ;; Optional, but recommended.
    ;;
    ;; You can manually enable Combobulate with `M-x
    ;; combobulate-mode'.
    :hook ((python-ts-mode . combobulate-mode)
           (js-ts-mode . combobulate-mode)
           (css-ts-mode . combobulate-mode)
           (yaml-ts-mode . combobulate-mode)
           (typescript-ts-mode . combobulate-mode)
           (tsx-ts-mode . combobulate-mode))
    ;; Amend this to the directory where you keep Combobulate's source
    ;; code.
    :load-path ("~/.local/lib/emacs/29.1/site-lisp/combobulate")))

(use-package use-package-chords
  :ensure t
  :init (key-chord-mode 1))

(use-package which-key
  :ensure t
  :diminish which-key-mode
  :init
  (setq which-key-show-early-on-C-h t)
  (which-key-mode))

(use-package company
  :ensure t
  :config
  (define-key company-active-map (kbd "M-p") nil)
  (define-key company-active-map (kbd "M-n") nil)
  (define-key company-active-map (kbd "C-p") #'company-select-previous)
  (define-key company-active-map (kbd "C-n") #'company-select-next)
  (setq company-idle-delay 0.3)
  :hook
  (prog-mode . company-mode)
  (scheme-mode . company-mode)
  :diminish (company-mode . " ©"))

(use-package crux
  :ensure t
  :bind
  ("C-a" . crux-move-beginning-of-line)
  ("C-c e r" . crux-eval-and-replace)
  )

(use-package eglot
  :config
  (setq eglot-extend-to-xref t)
  (setq-default eglot-workspace-configuration
                '((:gopls .
                          ((staticcheck . t)
                           (matcher . "CaseSensitive")))))
  (add-to-list 'eglot-server-programs '(terraform-mode . ("terraform-lsp" "")))
  (add-to-list 'eglot-server-programs '(python-mode . ("pyright" "--stdio" "--lib")))
  (add-to-list 'eglot-server-programs '(css-mode . ("vscode-html-languageserver" "--stdio")))

  :hook
  (go-mode . eglot-ensure)
  ;; (python-mode . eglot-ensure)

  :bind (:map eglot-mode-map
              ("M-l <tab>" . complete-at-point)
	          ("M-l s" . eglot-code-actions)
	          ("M-l d" . eldoc-doc-buffer)
              ("M-l r" . eglot-rename)
              ("M-l v" . eglot-format)

	          ("M-l f d" . xref-find-definitions-other-frame)
	          ("M-l f r" . xref-find-references)
	          ("M-l f i" . eglot-find-implementation)
              ("M-l f t" . eglot-find-typeDefinition)
              ("M-l f f" . eglot-find-declaration)

              ("M-l e e" . flymake-goto-next-error)
              ("M-l e r" . flymake-goto-prev-error)))

(use-package easy-hugo
  :ensure t
  :custom
  (easy-hugo-basedir "~/work/admonica-project/blog")
  ;; (easy-hugo-url "https://dev.daniel-ts.xyz/blog")
  (easy-hugo-url "http://localhost:1313/blog/")
  (easy-hugo-sshdomain "infra1")
  (easy-hugo-root "/opt/cloud/admproj_blog")
  (easy-hugo-preview-url "http://localhost:1313/blog/")
  ;; (easy-hugo-server-flags "--buildDrafts --noHTTPCache")
  (easy-hugo-postdir "content/posts")
  (easy-hugo-default-ext ".org"))

(use-package highlight-indent-guides
  :ensure t
  :diminish highlight-indent-guides-mode
  :hook (prog-mode . highlight-indent-guides-mode)
  :init
  (setq highlight-indent-guides-method 'character)
  (setq highlight-indent-guides-responsive 'top)
  (setq highlight-indent-guides-auto-odd-face-perc 5)
  (setq highlight-indent-guides-auto-even-face-perc 5)
  (setq highlight-indent-guides-auto-character-face-perc 8))

(use-package hledger-mode
  :ensure t)

(use-package key-chord
  :custom
  (key-chord-two-keys-delay 0.3)
  (key-chord-one-key-delay 0.3))


(use-package kmacro
  :chords
  ("z8" . kmacro-end-and-call-macro)
  ("Z(" . kmacro-call-ring-2nd)
  ("z9" . kmacro-cycle-ring-next)
  ("Z)" . kmacro-cycle-ring-previous)
  ("Z/" . kmacro-delete-ring-head)
  ("z7" . kmacro-edit-macro))

;; (use-package origami
;;   :ensure t
;;   :hook (prog-mode . origami-mode)
;;   :chords (("4r" . origami-toggle-node)
;;            ("4t" . origami-show-only-node)))

(use-package projectile
  :ensure t
  :init
  (setq projectile-indexing-method 'native)
  (setq projectile-sort-order 'modification-time)
  (setq projectile-enable-caching t)
  (setq projectile-mode-line-prefix " Π")
  (setq projectile-dynamic-mode-line nil)
  :config
  (projectile-mode +1)
  (define-key projectile-mode-map (kbd "M-p") 'projectile-command-map))

(use-package rainbow-delimiters
  :ensure t
  :config
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))

(use-package register
  :chords
  ("Z=" . point-to-register)
  ("z0" . jump-to-register))

(use-package sh-script
  :mode
  ("\\.bb\\'" . shell-script-mode)
  ("\\.bbclass\\'" . shell-script-mode)
  ("\\.bbappend\\'" . shell-script-mode)
  ("\\.inc\\'" . shell-script-mode)
  )

(use-package smartparens
  :ensure t
  :diminish smartparens-mode
  :hook
  ((prog-mode . smartparens-mode)
   (org-mode . smartparens-mode)
   (conf-mode . smartparens-mode)
   (markdown-mode . smartparens-mode)
   (geiser-repl-mode . smartparens-mode))
  :config
  (sp-local-pair 'org-mode "*" "*" :actions '(wrap))
  (sp-local-pair 'org-mode "/" "/" :actions '(wrap))
  (sp-local-pair 'org-mode "_" "_" :actions '(wrap))
  (sp-local-pair 'org-mode "=" "=" :actions '(wrap)))

(use-package undo-tree
  :ensure t
  :chords
  ("U(" . undo-tree-redo)
  ("u8" . undo-tree-undo)
  :diminish undo-tree-mode
  :config
  (global-undo-tree-mode 1)
  (setq undo-tree-auto-save-history nil))

(use-package yasnippet
:ensure t
:diminish yas-minor-mode
:config
(add-to-list 'yas-snippet-dirs "~/.emacs.d/yasnippets")
(yas-global-mode))

(use-package ivy-yasnippet
:ensure t
:bind ("M-+" . ivy-yasnippet)
:config
(setq ivy-yasnippet-expand-keys 'never))

(use-package cc-mode
  :init
  (setq c-default-style '((java-mode . "java")
                          (awk-mode . "awk")
                          (c++-mode . "stroustrup")
			      (c-mode . "stroustrup")
                          (other . "linux"))))

(use-package c++-mode
  :hook (c++-mode . eglot-ensure))

;; (use-package csharp-mode
;;   )

(use-package caddyfile-mode
  :ensure t
  :init
  (defun my-caddyfile-hook ()
    (setq-local tab-width 4)  ;; Default: 8
    (setq-local indent-tabs-mode nil))  ;; Default: t
  :mode (("Caddyfile\\'" . caddyfile-mode)
         ("caddy\\.conf\\'" . caddyfile-mode))
  :hook
  ((caddyfile-mode . my-caddyfile-hook)))

(use-package clojure-mode
:ensure t
:mode ("\\.clj\\'"))

(use-package cider
:ensure t
:config
(add-hook 'cider-mode-hook #'eldoc-mode)
(add-hook 'cider-repl-mode-hook #'eldoc-mode)
(add-hook 'cider-repl-mode-hook #'smartparens-mode)
(add-hook 'cider-repl-mode-hook #'rainbow-delimiters-mode))

(use-package cmake-mode
  :ensure t)

(use-package elisp-mode
  :hook
  (emacs-lisp-mode . display-fill-column-indicator-mode)
  :bind
  ("C-c s s" . sp-forward-slurp-sexp)
  ("C-c s f" . sp-forward-parallel-sexp)
  ("C-c s u" . sp-up-sexp)
  ("C-c s d" . sp-down-sexp)
  ("C-c s m" . sp-mark-sexp)
  ("C-c s a" . sp-beginning-of-sexp)
  ("C-c s e" . sp-end-of-sexp)
  ("C-c s h" . sp-highlight-current-sexp))

(use-package package-lint
  :ensure t)

(use-package fish-mode
  :ensure t)

(use-package go-mode
  :ensure t)

(use-package go-ts-mode
  :after go-mode
  :init
  ;; (defun lsp-go-install-save-hooks ()
  ;;   (add-hook 'before-save-hook #'lsp-format-buffer t t))
  (defun eglot-format-buffer-on-save ()
    (add-hook 'before-save-hook #'eglot-format-buffer -10 t))

  :hook
  (go-mode . eglot-format-buffer-on-save)
  (go-mode . set-c-indentation)
  (go-mode . flymake-mode)
  (go-mode . display-fill-column-indicator-mode)
  (go-mode . (lambda () (setq-default fill-column 80)))

   :config
   (defun project-find-go-module (dir)
     (when-let ((root (locate-dominating-file dir "go.mod")))
       (cons 'go-module root)))

   (cl-defmethod project-root ((project (head go-module)))
     (cdr project))

   (add-hook 'project-find-functions #'project-find-go-module))




(use-package company-go
  :ensure t)

(use-package js2-mode
  :ensure t
  :mode
  ("\\.js[mx]?\\'" . js2-mode)
  ("\\.tsx?\\'" . js2-mode)
  :diminish
  ((js2-mode . "js_ide")
   (js-mode . "js_iqde"))
  :config
  (setq js2-strict-missing-semi-warning nil)
  (setq js2-no-semi-insertion nil)
  (setq js2-missing-semi-one-line-override t))

(use-package json-mode
  :ensure t
  :after json-navigator
  :hook
  (json-mode . (lambda ()
		 (local-set-key (kbd "C-c n") #'json-navigator-navigate-after-point))))

;; hier ist ein Fehler!
;; (use-package auctex-latexmk
;;   :ensure t
;;   :config
;;   (auctex-latexmk-setup)
;;   (setq auctex-latexmk-inherit-Tex-PDF-mode t))

(use-package reftex
  :ensure t
  :defer t
  :config
  (setq reftex-cite-prompt-optional-args t))

(use-package company-auctex
  :ensure t)

(use-package latex-mode
  :ensure auctex
  :mode "\\.tex\\'"
  :hook
  ;; mixed-case ist hier wichtig (LaTeX). Siehe obere Links.
  (LaTeX-mode . reftex-mode)
  (LaTeX-mode . smartparens-mode)
  (LaTeX-mode . company-mode)
  (LaTeX-mode . flyspell-mode)
  (LaTeX-mode . display-line-numbers-mode)
  (LaTeX-mode . (lambda()
		  (add-to-list 'TeX-command-list '("XeLaTeX" "%`xelatex%(mode)%' %t" TeX-run-TeX nil t))
		  (setq TeX-command-default "XeLaTeX")
		  (setq TeX-save-query nil)
		  (setq TeX-show-compilation nil)

		  (setq my-TeX-outdir "OUT")
		  (add-to-list 'TeX-expand-list
			       `("%(OUTDIR)"
				 (lambda ()
				   (unless (file-directory-p my-TeX-outdir)
				     (make-directory my-TeX-outdir))
				   (cond ((or (eq TeX-engine 'xetex)
					      (eq TeX-engine 'luatex))
					 ,(concat "--output-directory=" my-TeX-outdir))

					 ((eq TeX-engine 'pdftex)
					  ,(concat "-output-directory " my-TeX-outdir))
					 (t
					  ,(concat "--output-directory=" my-TeX-outdir))))))
		  (add-to-list 'TeX-command-list
			       '("XeLaTeX OUTDIR" "%`xelatex%(mode)%' %(OUTDIR) %t" TeX-run-TeX nil t))
		  ))
  ;;(LaTeX-mode . TeX-fold-mode)
  :config
  (setq TeX-auto-save t)
  (setq TeX-parse-self t)
  ;;(setq-default TeX-master nil)

  (setq TeX-source-correlate-mode t)
  (setq TeX-source-correlate-method 'synctex)
  (setq reftex-plug-into-AUCTeX t)
  ;; Update PDF buffers after successful LaTeX run
  (add-hook 'TeX-after-compilation-finished-functions #'TeX-revert-document-buffer))

(use-package nginx-mode
  :ensure t
  :init
  (add-to-list 'auto-mode-alist '("/nginx/sites-\\(?:available\\|enabled\\)/" . nginx-mode)))

(use-package nix-mode
  :ensure t
  :mode "\\.nix\\'"
  )

(use-package systemd
  :ensure t
  :hook
  (systemd-mode . display-line-numbers-mode)
  (systemd-mode . highlight-indent-guides-mode)
  (systemd-mode . smartparens-mode)
  (systemd-mode . company-mode)
)

(eval-after-load "visual-line-mode" (diminish 'visual-line-mode))
(eval-after-load "eldoc-mode" (diminish 'eldoc-mode))
(eval-after-load "auto-revert-mode" (diminish 'auto-revert-mode))

(use-package urlenc
  :ensure t
  :config
  (custom-set-variables '(urlenc:default-coding-system 'utf-8)))

(use-package php-mode
  :ensure t
  :mode "\\.php\\'")

(use-package pyvenv
  ;; https://github.com/jorgenschaefer/pyvenv
  :ensure t
  :config
  (add-hook 'pyvenv-post-activate-hooks
            (lambda ()
              (setq pyvenv-mode-line-indicator
                  (concat "[venv:" pyvenv-virtual-env-name "]"))
              (pyvenv-mode +1)))
  (add-hook 'pyvenv-post-deactivate-hooks
            (lambda ()
              (pyvenv-mode -1)))
  )

(use-package python
  :bind (:map python-ts-mode-map
              ("C-c h" . (lambda ()
                          (interactive)
                          (info "python"))))
  :custom
  (python-shell-interpreter "ipython3")
  (python-shell-interpreter-args "-i --simple-prompt --InteractiveShell.display_page=True")
  (python-shell-prompt-detect-failure-warning t))

(use-package slime
  :ensure t
  :config
  (setq inferior-lisp-program "sbcl"))

(use-package geiser
  :ensure t)

;; (use-package geiser-guile
;;   :ensure t
;;   :after (dash exec-path-from-shell)
;;   :custom
;;   (geiser-guile-load-path (-distinct (string-split (exec-path-from-shell-getenv "GUILE_LOAD_PATH") ":" t))))

(use-package scheme-mode
  :mode "\\.scm\\'"
  :hook
  (scheme-mode . geiser-mode)
  :config
  (setq fill-column 78)
  (setq tab-width 8)
  (setq sentence-end-double-space t)
  (setq indent-tabs-mode nil)
  (put 'eval-when 'scheme-indent-function 1)
  (put 'call-with-prompt 'scheme-indent-function 1)
  (put 'test-assert 'scheme-indent-function 1)
  (put 'test-assertm 'scheme-indent-function 1)
  (put 'test-equalm 'scheme-indent-function 1)
  (put 'test-equal 'scheme-indent-function 1)
  (put 'test-eq 'scheme-indent-function 1)
  (put 'call-with-input-string 'scheme-indent-function 1)
  (put 'guard 'scheme-indent-function 1)
  (put 'lambda* 'scheme-indent-function 1)
  (put 'substitute* 'scheme-indent-function 1)
  (put 'match-record 'scheme-indent-function 2)

  ;; 'modify-phases' and its keywords.
  (put 'modify-phases 'scheme-indent-function 1)
  (put 'replace 'scheme-indent-function 1)
  (put 'add-before 'scheme-indent-function 2)
  (put 'add-after 'scheme-indent-function 2)

  (put 'modify-services 'scheme-indent-function 1)
  (put 'with-directory-excursion 'scheme-indent-function 1)
  (put 'package 'scheme-indent-function 0)
  (put 'origin 'scheme-indent-function 0)
  (put 'build-system 'scheme-indent-function 0)
  (put 'bag 'scheme-indent-function 0)
  (put 'graft 'scheme-indent-function 0)
  (put 'operating-system 'scheme-indent-function 0)
  (put 'file-system 'scheme-indent-function 0)
  (put 'manifest-entry 'scheme-indent-function 0)
  (put 'manifest-pattern 'scheme-indent-function 0)
  (put 'substitute-keyword-arguments 'scheme-indent-function 1)
  (put 'with-store 'scheme-indent-function 1)
  (put 'with-external-store 'scheme-indent-function 1)
  (put 'with-error-handling 'scheme-indent-function 0)
  (put 'with-mutex 'scheme-indent-function 1)
  (put 'with-atomic-file-output 'scheme-indent-function 1)
  (put 'call-with-compressed-output-port 'scheme-indent-function 2)
  (put 'call-with-decompressed-port 'scheme-indent-function 2)
  (put 'call-with-gzip-input-port 'scheme-indent-function 1)
  (put 'call-with-gzip-output-port 'scheme-indent-function 1)
  (put 'call-with-lzip-input-port 'scheme-indent-function 1)
  (put 'call-with-lzip-output-port 'scheme-indent-function 1)
  (put 'signature-case 'scheme-indent-function 1)
  (put 'emacs-batch-eval 'scheme-indent-function 0)
  (put 'emacs-batch-edit-file 'scheme-indent-function 1)
  (put 'emacs-substitute-sexps 'scheme-indent-function 1)
  (put 'emacs-substitute-variables 'scheme-indent-function 1)
  (put 'with-derivation-narinfo 'scheme-indent-function 1)
  (put 'with-derivation-substitute 'scheme-indent-function 2)
  (put 'with-status-report 'scheme-indent-function 1)
  (put 'with-status-verbosity 'scheme-indent-function 1)

  (put 'mlambda 'scheme-indent-function 1)
  (put 'mlambdaq 'scheme-indent-function 1)
  (put 'syntax-parameterize 'scheme-indent-function 1)
  (put 'with-monad 'scheme-indent-function 1)
  (put 'mbegin 'scheme-indent-function 1)
  (put 'mwhen 'scheme-indent-function 1)
  (put 'munless 'scheme-indent-function 1)
  (put 'mlet* 'scheme-indent-function 2)
  (put 'mlet 'scheme-indent-function 2)
  (put 'run-with-store 'scheme-indent-function 1)
  (put 'run-with-state 'scheme-indent-function 1)
  (put 'wrap-program 'scheme-indent-function 1)
  (put 'with-imported-modules 'scheme-indent-function 1)
  (put 'with-extensions 'scheme-indent-function 1)

  (put 'with-database 'scheme-indent-function 2)
  (put 'call-with-transaction 'scheme-indent-function 2)

  (put 'call-with-container 'scheme-indent-function 1)
  (put 'container-excursion 'scheme-indent-function 1)
  (put 'eventually 'scheme-indent-function 1)

  (put 'call-with-progress-reporter 'scheme-indent-function 1)

  ;; This notably ( in Paredit to not insert a space when the
  ;; preceding symbol is one of (eval . (modify-syntax-entry ?~ "'"))
  (modify-syntax-entry ?$ "'")
  (modify-syntax-entry ?+ "'")
  :custom
  (geiser-default-implementation 'guile))

(use-package svelte-mode
  :ensure t
  :mode "\\.svelte\\'"
  :config
  (setq svelte-display-submode-name t))

(use-package terraform-mode
  :ensure t
  :config
  (terraform-format-on-save-mode 1)
  (custom-set-variables '(terraform-indent-level 2)))

(use-package typescript-mode
  :ensure t)

(use-package typescript-ts-mode
  :after typescript-mode
  :mode ("\\.ts\\'" . typescript-ts-mode)
  :hook (typescript-mode . eglot-ensure))

(use-package yaml-mode
  :ensure t)

(use-package yaml-ts-mode
  :after yaml-mode
  :mode ("\\.ya?ml\\'")
  :hook
  (yaml-ts-mode . display-line-numbers-mode)
  (yaml-ts-mode . highlight-indent-guides-mode)
  (yaml-ts-mode . smartparens-mode)
  (yaml-ts-mode . (lambda ()
		            (define-key yaml-mode-map "\C-m" 'newline-and-indent)))
  :config
  (defun dt/ansible-lint-on-buffer ()
    (interactive)
    (shell-command (string-join (list "ansible-lint"
                                      "--profile" "production"
                                      "--format" "full") " ")
                   "*ansible-lint*"))
  :bind ((:map yaml-ts-mode-map
               ("C-c h l" . dt/ansible-lint-on-buffer)))

  )

(use-package guix-emacs
  :hook
  (scheme-mode . guix-devel-mode))

(use-package lxd-tramp
  :ensure t)

(use-package emacs
  :config
  ;; unset creation of keyboard macro
  (global-unset-key (kbd "C-x C-k"))

  ;; unset to-lower and to-upper keys
  (global-unset-key (kbd "M-l"))
  (global-unset-key (kbd "M-u"))

  ;; unset emacs news
  (global-unset-key (kbd "C-h n"))

  :bind
  ("C-x C-f" . find-file-other-frame)
  ("C-x d" . (lambda ()
               (interactive)
               (dired-other-frame default-directory)))
  ("C-x D" . dired-other-frame)
  ("C-x b" . (lambda (buf)
	       (interactive "B")
	       (let ((display-buffer-alist '((".*" display-buffer-pop-up-frame))))
		 (switch-to-buffer-other-frame buf))))
  ("C-x C-b" . switch-to-buffer)
  ("C-< t". dt/open-cwd-in-kitty)

  ("M-+" . ivy-yasnippet)

  ("C-< r". dt/rename-buffer)
  ("C-< v". toggle-truncate-lines)

  ("C-< c". (lambda ()
	      "open emacs configuration file 'configuration.org'"
	      (interactive)
	      (find-file-other-frame "~/.emacs.d/init.el")))

  ("C-< f u" . (lambda ()
		 (interactive)
		 (set-face-attribute 'default nil :height 110 :font "Inconsolata Condensed" :weight 'normal)))

  ("C-< f s" . (lambda ()
		 (interactive)
		 (set-face-attribute 'default nil :height 90 :font "JetBrains Mono" :weight 'normal)))

  ("C-< f m" . (lambda ()
		 (interactive)
		 (set-face-attribute 'default nil :height 105 :font "JetBrains Mono" :weight 'normal)))

  ("C-< f l" . (lambda ()
		 (interactive)
		 (set-face-attribute 'default nil :height 130 :font "JetBrains Mono" :weight 'normal)))

  :chords
  ;; use em!
  ("o0" . comment-or-uncomment-region)
  )
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auth-source-save-behavior nil)
 '(package-selected-packages
   '(notmuch-addr notmuch hledger-mode org-protocol magit slime org-download lxd-tramp pyvenv anki-editor emacsql-sqlite-builtin emacs-sqlite-builtin anki-editor zig-mode ansible-doc typescript-mode terraform-mode svelte-mode sonic-pi poetry ein php-mode urlenc systemd nix-mode nginx-mode company-auctex js2-mode company-go go-mode fish-mode package-lint cmake-mode cider clojure-mode caddyfile-mode flycheck use-package-chords company-restclient restclient openwith nov dockerfile-mode dired-hacks dired-hide-dotfiles selectrum-prescient academic-phrases gotham-theme yaml-mode which-key undo-tree markdown-mode smartparens rainbow-mode rainbow-delimiters pkg-info projectile vertico selectrum corfu prescient pg finalize emacsql-sqlite3 org-roam async json-mode ivy-yasnippet hydra highlight-indent-guides magit-popup edit-indirect bui geiser-guile exec-path-from-shell doom-themes f eimp diminish ctrlf crux company auctex))
 '(safe-local-variable-values
   '((eval modify-syntax-entry 43 "'")
     (eval modify-syntax-entry 36 "'")
     (eval modify-syntax-entry 126 "'")))
 '(terraform-indent-level 2)
 '(urlenc:default-coding-system 'utf-8)
 '(warning-suppress-log-types '((org-element-cache))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'narrow-to-region 'disabled nil)
