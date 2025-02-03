;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Docky Docker"
      user-mail-address "n.a.")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
(setq doom-font (font-spec :family "Mononoki Nerd Font Mono" :size 16))

;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'doom-one)
(setq doom-theme 'doom-tomorrow-night)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; priorities
;; https://stackoverflow.com/a/65591436
(setq org-highest-priority ?A
      org-default-priority ?B
      org-lowest-priority ?E)

;; https://emacs.stackexchange.com/a/17405
(setq org-priority-faces '((?A . (:foreground "#ffa488" :weight 'bold))
                           (?B . (:foreground "#ffe788"))
                           (?C . (:foreground "#eeedbe"))
                           (?D . (:foreground "#cece9b"))
                           (?E . (:foreground "#c3c3a6"))))


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.


;; choose the default browser
(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "librewolf")


;; org settings
(setq org-hide-emphasis-markers t
      ;; org-fontify-done-headline t
      org-hide-leading-stars t
      ;; org-pretty-entities t
      )

(font-lock-add-keywords 'org-mode
                         '(("^ *\\([-]\\) "
                            (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "▶")))))
                         )
(font-lock-add-keywords 'org-mode
                         '(("^ *\\([+]\\) "
                            (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "▶")))))
                         )

(use-package org-bullets
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
  )

(setq org-log-done 'time)

;; R-internals manual
;;; ESS https://stackoverflow.com/questions/12805873/changing-indentation-in-emacs-ess
(add-hook 'ess-mode-hook
      (lambda ()
        (ess-set-style 'C++ 'quiet)
        (add-hook 'local-write-file-hooks
              (lambda ()
            (ess-nuke-trailing-whitespace)))))
;;(setq ess-nuke-trailing-whitespace-p 'ask)
;; or even
(setq ess-nuke-trailing-whitespace-p t)


;; github flavored markdown https://github.com/larstvei/ox-gfm
(eval-after-load "org"
  '(require 'ox-gfm nil t))

;; hugo export from orgmode
(require 'ox-hugo)

;; quarto mode
;; (require 'quarto-mode)
;; Or, with use-package:
(use-package quarto-mode
  :mode (("\\.Rmd" . poly-quarto-mode))
  )

;; org roam
;; https://github.com/org-roam/org-roam#configuration
(map! :leader
    (:prefix ("n r"."org oram")
      :desc "org roam node insert"
             "i" #'org-roam-node-insert
      :desc "org roam node find"
             "f" #'org-roam-node-find
      :desc "org roam db sync/reload"
             "r" #'org-roam-db-sync
     )
)

;; https://systemcrafters.net/build-a-second-brain-in-emacs/capturing-notes-efficiently/
(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory  "~/notes")
  (org-roam-capture-templates
   '(("d" "default" plain
   "%?"
   :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: \n")
   :unnarrowed t))
   )
  ;;:bind
  ;;(("SPC n r l" . org-roam-buffer-toggle)
  ;; ("SPC n r f" . org-roam-node-find)
  ;; ("SPC n r i" . org-roam-node-insert)
  ;; ("SPC n r c" . org-roam-capture)
  ;; ;; Dailies
  ;; ;;("C-c n j" . org-roam-dailies-capture-today)
  ;;)
  :config
  (org-roam-setup)
  (setq org-roam-completion-everywhere t)
  ;;(setq org-roam-db-location
  ;;    (concat org-roam-directory "/.database/org-roam.db"))
  ;; If you're using a vertical completion framework, you might want a more informative completion interface
  (setq org-roam-node-display-template (concat "${title:*} " (propertize "${tags:64}" 'face 'org-tag)))
  (org-roam-db-autosync-mode)
  ;; If using org-roam-protocol
  (require 'org-roam-protocol)
  )


(autoload 'helm-bibtex "helm-bibtex" "" t)
(setq bibtex-completion-bibliography
      '("~/library.bib"
        "~/reads/_library.bib"))
(setq bibtex-completion-pdf-field "File")
(setq bibtex-completion-library-path '("~/reads"))
(setq bibtex-completion-notes-path "~/reads")


;; presentation mode
(use-package hide-mode-line)

(defun presentation_start ()
  ;; Hide the mode line
  (hide-mode-line-mode 1)

  ;; Display images inline
  (org-display-inline-images) ;; Can also use org-startup-with-inline-images

  ;; Scale the text.  The next line is for basic scaling:
  (setq text-scale-mode-amount 3)
  (text-scale-mode 1)
  )


(defun presentation_end ()
  ;; Show the mode line again
  (hide-mode-line-mode 0)

  ;; Turn off text scale mode (or use the next line if you didn't use text-scale-mode)
  (text-scale-mode 0)

  ;; If you use face-remapping-alist, this clears the scaling:
  ;;(setq-local face-remapping-alist '((default variable-pitch default)))
  )

(use-package org-tree-slide
  ;; :hook ((org-tree-slide-play . efs/presentation-setup)
  ;;       (org-tree-slide-stop . efs/presentation-end))
  :hook (('org-tree-slide-play . 'presentation_start)
         ('org-tree-slide-stop . 'presentation_end))
  :custom
  (org-tree-slide-slide-in-effect t)
  (org-tree-slide-activate-message "Presentation started!")
  (org-tree-slide-deactivate-message "Presentation finished!")
  (org-tree-slide-header t)
  (org-tree-slide-breadcrumbs " > ")
  (org-image-actual-width nil)
  )


(global-set-key (kbd "<f8>") 'org-tree-slide-mode)
(global-set-key (kbd "<f7>") 'hide-mode-line-mode)


;; reveal.js presentations
(require 'org-re-reveal)
(require 'org-re-reveal-ref)
;; (setq org-reveal-root "file://home/falk/reveal_test/reveal.js")


(global-set-key (kbd "<f3>") 'er/expand-region)



;; R Markdown Rendering
;; spa/rmd-render - modified
;; https://www.stefanavey.com/lessons/2018/01/04/ess-render
;; render commands and propose as suggestions in the minibuffer.
(defun rmd-render (arg)
  "Render the current Rmd file to PDF output."
  (interactive "P")
  ;; Build the default R render command
  (setq rcmd (concat "rmarkdown::render('" buffer-file-name "')"))
  ;; Build and evaluate the shell command
  (setq command (concat "echo \"" rcmd "\" | R --vanilla"))
  (compile command))

;; run all code chunks
;; https://stackoverflow.com/questions/24753969/knitr-run-all-chunks-in-an-rmarkdown-document
(defun rmd-runall (arg)
  "Run all code chunks of the current Rmd file in the current tmux session."
  (interactive "P")
  ;; Build the default R render command
  (setq rcmd (concat "tempR <- tempfile(fileext = '.R'); knitr::purl('" buffer-file-name "', output=tempR); source(tempR); unlink(tempR);"))
  ;; Build and evaluate the shell command
  (setq command (concat "echo \"" rcmd "\" | xargs -0 -I{} tmux send {} ENTER"))
  (compile command))

;; source current R script
(defun r-sourcescript (arg)
  "Source the current R file in a tmux session."
  (interactive "P")
  ;; Build the default R render command
  (setq rcmd (concat "source('" buffer-file-name "');"))
  ;; Build and evaluate the shell command
  (setq command (concat "echo \"" rcmd "\" | xargs -0 -I{} tmux send {} ENTER"))
  (compile command))

;;(defun rmd-select-and-send-chunk (arg)
;;  "select current code chunk and send it to a tmux session."
;;  (interactive "P")
;;  (select-rmarkdown-code-chunk)
;;  (+tmux/send-region)
;;  )
;;(global-set-key (kbd "C-c a b c") (lambda () (interactive) (some-command) (some-other-command)))

(defalias 'select-rmarkdown-code-chunk
   (kmacro "? ` ` ` <return> j V / ` ` ` <return> k"))

;; tmux
;; https://www.youtube.com/watch?v=QRmKpqDP5yE
(map! :leader
    (:prefix ("r"."run in tmux")
      :desc "select code chunk in .Rmd"
             "r" #'select-rmarkdown-code-chunk
      :desc "run selection in tmux"
             "t" #'+tmux/send-region
      :desc "compile RMarkdown"
             "m" #'rmd-render
      :desc "run all chunks in .Rmd"
             "a" #'rmd-runall
      :desc "source current .R script"
             "s" #'r-sourcescript
      :desc "Restart R"
             "/" #'(lambda (arg) (interactive "P") (compile "tmux send \"quit()\" ENTER && tmux send \"R --vanilla --silent\" ENTER "))
      :desc "dev/document"
             "d" #'(lambda (arg) (interactive "P") (compile "tmux send \"devtools::document()\" ENTER "))
      :desc "dev/test"
             "e" #'(lambda (arg) (interactive "P") (compile "tmux send \"devtools::test()\" ENTER "))
      :desc "dev/loadall"
             "l" #'(lambda (arg) (interactive "P") (compile "tmux send \"devtools::load_all()\" ENTER "))
      :desc "dev/install"
             "i" #'(lambda (arg) (interactive "P") (compile "tmux send \"devtools::install()\" ENTER "))
      :desc "dev/check"
             "c" #'(lambda (arg) (interactive "P") (compile "tmux send \"devtools::check()\" ENTER "))
     )
)


(provide 'config)
;;; config.el ends here
