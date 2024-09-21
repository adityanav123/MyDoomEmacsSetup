;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

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
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)
;; set theme doom-gruvbox
;; (setq doom-theme 'doom-gruvbox)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


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

;; LSP Mode with Clangd - for C & C++
(setq lsp-clients-clangd-args '("-j=3"
				"--background-index"
				"--clang-tidy"
				"--completion-style=detailed"
				"--header-insertion=never"
				"--header-insertion-decorators=0"))
(after! lsp-clangd (set-lsp-priority! 'clangd 2))

;; Relative line numbering
(setq display-line-numbers-type 'relative)


;; Font Settings
(setq doom-font (font-spec :family "Rec Mono Casual" :size 16)
      doom-variable-pitch-font (font-spec :family "Rec Mono Casual" :size 16)
      doom-symbol-font (font-spec :family "FiraCode Nerd Font" :size 16)
      doom-big-font (font-spec :family "Rec Mono Casual" :size 23))

;; Setting up EMMS : Media Player
(use-package! emms
  :config
  (require 'emms-setup)
  (emms-all)
  (setq emms-player-list '(emms-player-mpv)
        emms-source-file-default-directory "~/Music/")
  (require 'emms-playing-time)
  (emms-playing-time-mode 1)
  (require 'emms-info-libtag)
  (setq emms-info-functions '(emms-info-libtag))
  (emms-mode-line-mode 1))

(map! :leader
      :prefix ("d" . "emms")
      :desc "Play/Pause" "p" #'emms-pause
      :desc "Next Track" "n" #'emms-next
      :desc "Previous Track" "b" #'emms-previous
      :desc "Stop" "s" #'emms-stop
      :desc "Toggle Repeat Track" "r" #'emms-toggle-repeat-track
      :desc "Toggle Repeat Playlist" "R" #'emms-toggle-repeat-playlist
      :desc "Add Directory" "a" #'emms-add-directory-tree
      :desc "Show Playlist" "l" #'emms-playlist-mode-go
      :desc "Show Current Track" "i" #'emms-show)

;; Catppuccin theme config
;; (setq doom-theme 'catppuccin)

;; Org Mode - Modern
(use-package! org-modern
  :hook (org-mode . global-org-modern-mode)
  :config
  (setq org-modern-label-border 0.3))

;; Neotree icons
;; Enable nerd-icons
(use-package! nerd-icons
  :if (display-graphic-p))

;; Org-Drill Mode
(after! org
  (require 'org-drill))

(setq org-drill-maximum-duration 30 ;; Maximum duration of a drill session in minutes.
      org-drill-add-random-noise-to-intervals-p t ;; Adds random variation to the intervals.
      org-drill-save-buffers-after-drill-sessions-p t) ;; Automatically saves buffers after a drill session.

(map! :leader
      :desc "Start org-drill session" "b o d" #'org-drill)


;; Latex Mode in Org
(defun my/org-latex-preview-all ()
  "Preview all LaTeX fragments in the current buffer."
  (org-latex-preview '(16)))

(add-hook 'org-mode-hook 'my/org-latex-preview-all)


;; Inline Image Mode in Org
(use-package org
  :config
  (setq org-startup-with-inline-images t)
  (setq org-image-actual-width nil))


;; Custom Timer
;; Load alert package
(use-package! alert
  :commands (alert)
  :config
  (setq alert-default-style 'notifications))

;; Define variables for the timer
(defvar my-timer--remaining-time 0)
(defvar my-timer--message "")
(defvar my-timer--timer-object nil)

;; Function to update mode line
(defun my-timer-update-mode-line ()
  (when my-timer--timer-object
    (setq my-timer--remaining-time (- my-timer--remaining-time 1))
    (force-mode-line-update)
    (if (<= my-timer--remaining-time 0)
        (progn
          (alert my-timer--message :title "Emacs Timer")
          (my-cancel-timer)))))

;; Function to format the mode line timer
(defun my-timer-mode-line ()
  (if my-timer--timer-object
      (format " [%s] " (format-seconds "%m:%.2s" my-timer--remaining-time))
    ""))

;; Add to mode line
(add-to-list 'global-mode-string '(:eval (my-timer-mode-line)) t)

;; Function to cancel the timer
(defun my-cancel-timer ()
  "Cancel the current timer."
  (interactive)
  (when my-timer--timer-object
    (cancel-timer my-timer--timer-object)
    (setq my-timer--timer-object nil)
    (setq my-timer--message "")
    (setq my-timer--remaining-time 0)
    (force-mode-line-update)))

;; Define the timer function
(defun my-set-timer (minutes message)
  "Set a timer for MINUTES minutes with a MESSAGE."
  (interactive "nMinutes: \nsMessage: ")
  (my-cancel-timer)  ;; Cancel any existing timer
  (setq my-timer--remaining-time (* minutes 60))
  (setq my-timer--message message)
  (setq my-timer--timer-object
        (run-with-timer 1 1 #'my-timer-update-mode-line)))

;; Bind the timer functions to keybindings
(map! :leader
      :prefix ("b" . "buffers")
      :desc "Set timer"
      "t" #'my-set-timer
      :desc "Cancel timer"
      "q" #'my-cancel-timer)

