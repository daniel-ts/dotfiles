(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'org)
(straight-use-package 'use-package)
;; (setq straight-use-package-by-default t)

(org-babel-load-file "~/.emacs.d/configuration.org")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(ob-ffuf package-lint terraform-mode rainbow-mode academic-phrases zig-mode yaml-mode which-key use-package-chords urlenc undo-tree typescript-mode systemd svelte-mode sonic-pi smartparens selectrum-prescient sane-term realgud-lldb rainbow-delimiters projectile poetry php-mode paredit origami org-roam org-download openwith ob-http ob-go nov nix-mode nginx-mode multi-vterm magit json-mode js2-mode ivy-yasnippet highlight-indent-guides groovy-mode gotham-theme geiser-guile flycheck fish-mode exec-path-from-shell ein eglot edit-server doom-themes dockerfile-mode docker diminish ctrlf crux company-restclient company-go company-auctex cmake-mode cider caddyfile-mode auctex-latexmk ansible-doc anki-editor))
 '(terraform-indent-level 2)
 '(urlenc:default-coding-system 'utf-8))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'narrow-to-region 'disabled nil)
(put 'list-threads 'disabled nil)
