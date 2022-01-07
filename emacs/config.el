;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Name and email
(setq user-full-name "Chinar Joshi"
      user-mail-address "chinarjoshi7@gmail.com")

;; Doom setup (theme, org directory, and line numbers)
(setq doom-theme 'doom-vibrant
      org-directory "~/org/"
      display-line-numbers-type t)

;; Font setup
(cond ((string= (getenv "DESKTOP") "0") (setq size 14))
      ((string= (getenv "MAC") "0") (setq size 22))
      (t (setq size 14)))

(setq doom-font (font-spec :family "Source Code Pro" :size size)
      doom-font-increment 1
      doom-big-font (font-spec :family "Noto Sans Mono" :size size)
      doom-big-font-increment 2
      doom-serif-font (font-spec :family "EB Garamond" :size size)
      doom-variable-pitch-font (font-spec :family "Helvetica" :size size)
      doom-unicode-font (font-spec :family "Fira Mono"))

(remove-hook '+doom-dashboard-functions #'doom-dashboard-widget-shortmenu)
(add-hook! '+doom-dashboard-mode-hook (hide-mode-line-mode 1) (hl-line-mode -1))
(setq-hook! '+doom-dashboard-mode-hook evil-normal-state-cursor (list nil))

;; Remove confirm kill message
(setq confirm-kill-emacs nil)
(if (daemonp)
    (setq initial-major-mode 'org-mode))

;; Mouse wheel scroll amount
(setq mouse-wheel-scroll-amount '(3 ((shift) . 3))
      mouse-wheel-progressive-speed nil
      mouse-wheel-follow-mouse 't
      scroll-step 1)

(after! doom-modeline
  (setq doom-modeline-major-mode-icon t))

(defvar mixed-pitch-modes '(org-mode LaTeX-mode markdown-mode gfm-mode Info-mode)
  "Modes that `mixed-pitch-mode' should be enabled in, but only after UI initialisation.")
(defun init-mixed-pitch-h ()
  "Hook `mixed-pitch-mode' into each mode in `mixed-pitch-modes'.
Also immediately enables `mixed-pitch-modes' if currently in one of the modes."
  (when (memq major-mode mixed-pitch-modes)
    (mixed-pitch-mode 1))
  (dolist (hook mixed-pitch-modes)
    (add-hook (intern (concat (symbol-name hook) "-hook")) #'mixed-pitch-mode)))
(add-hook 'doom-init-ui-hook #'init-mixed-pitch-h)

(autoload #'mixed-pitch-serif-mode "mixed-pitch"
  "Change the default face of the current buffer to a serifed variable pitch, while keeping some faces fixed pitch." t)

(after! mixed-pitch
  (defface variable-pitch-serif
    '((t (:family "serif")))
    "A variable-pitch face with serifs."
    :group 'basic-faces)
  (setq mixed-pitch-set-height t)
  (setq variable-pitch-serif-font (font-spec :family "Alegreya" :size 27))
  (set-face-attribute 'variable-pitch-serif nil :font variable-pitch-serif-font)
  (defun mixed-pitch-serif-mode (&optional arg)
    "Change the default face of the current buffer to a serifed variable pitch, while keeping some faces fixed pitch."
    (interactive)
    (let ((mixed-pitch-face 'variable-pitch-serif))
      (mixed-pitch-mode (or arg 'toggle)))))

;; <--------------------- PACKAGE CONFIGURATION ------------------------------->
(after! lsp-mode
  (setq lsp-ui-doc-show-with-cursor nil)
  ;; (setq lsp-headerline-breadcrumb-enable t)
  (setq lsp-diagnostics-provider :none))

;; Which-key
(after! which-key
  (setq which-key-idle-delay 0.5
        which-key-allow-multiple-replacements t)
  (pushnew!
   which-key-replacement-alist
   '(("" . "\\`+?evil[-:]?\\(?:a-\\)?\\(.*\\)") . (nil . "\\1"))
   '(("\\`g s" . "\\`evilem--?motion-\\(.*\\)") . (nil . "\\1"))))

;; Company
;;(after! company
 ;; (setq company-minimum-prefix-length 3
  ;;      company-global-modes '(not org-mode markdown-mode)
   ;;     company-box-show-single-candidate nil
    ;;    company-box-max-candidates 15
     ;;   company-frontends '(company-pseudo-tooltip-unless-just-one-frontend
      ;;                             company-preview-if-just-one-frontend
       ;;                            company-echo-metadata-frontend)))

(after! spell-fu
  (setq spell-fu-idle-delay 0.5))

(map! :leader
      :desc "Eval Python expression"
      ";" #'+python/open-repl)

(after! org
  (setq org-hide-emphasis-markers t))
