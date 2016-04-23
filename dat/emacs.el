;; .emacs

;; uncomment this line to disable loading of "default.el" at startup
(setq inhibit-default-init t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auto-compression-mode t nil (jka-compr))
 '(auto-save-default nil)
 '(case-fold-search t)
 '(column-number-mode t)
 '(current-language-environment "UTF-8")
 '(default-input-method "rfc1345")
 '(display-time-mode t nil (time))
 '(load-home-init-file t t)
 '(make-backup-files nil)
 '(show-paren-mode t nil (paren))
 '(text-mode-hook (quote (turn-on-auto-fill text-mode-hook-identify)))
 '(tool-bar-mode nil))

;; =======================================
;; Custom file type binding to mode
;; =======================================
(setq auto-mode-alist
  (append
   ;; File name ends in `.C'.
   '(
     ("\\.h\\'" . c++-mode)
     ("\\.tpp\\'" . c++-mode)
     ("\\.c\\'" . c-mode)
     ("\\.org\\'" . org-mode)
     ("\\.txt\\'" . org-mode)
     ) auto-mode-alist))

;; ============================
;; Display
;; ============================

;; display the current time
(display-time)

;; Show column number at bottom of screen
(column-number-mode 1)

;; alias y to yes and n to no
(defalias 'yes-or-no-p 'y-or-n-p)

;; highlight matches from searches
(setq isearch-highlight t)
(setq search-highlight t)
(setq-default transient-mark-mode t)

;; disable blinking cursor (block cursor)
(when (fboundp 'blink-cursor-mode) (blink-cursor-mode -1))

;; format the title-bar to always include the buffer name
(setq frame-title-format "emacs - %b")

;; show a menu only when running within X (save real estate when
;; in console)
(menu-bar-mode (if window-system 1 -1))

;; turn off the toolbar
;(if (<= emacs-major-version 21) (tool-bar-mode -1))

;; ============================
;; Setup syntax, background, and foreground coloring
;; ============================
;; turn on font-lock mode
(global-font-lock-mode t)
(set-background-color "Black")
(set-foreground-color "Ivory")
(set-cursor-color "LightSkyBlue")
(set-mouse-color "LightSkyBlue")
(setq font-lock-maximum-decoration t)

;; setup font
(set-default-font "-Misc-Fixed-Medium-R-Normal--15-140-75-75-C-90-ISO8859-1")

(add-to-list 'default-frame-alist '(foreground-color . "Ivory"))
(add-to-list 'default-frame-alist '(background-color . "Black"))
(add-to-list 'default-frame-alist '(cursor-color . "LightSkyBlue"))
(add-to-list 'default-frame-alist '(mouse-color . "LightSkyBlue"))
(add-to-list 'default-frame-alist '(font . "-Misc-Fixed-Medium-R-Normal--15-140-75-75-C-90-ISO8859-1"))

;; ============================
;; Key mappings
;; ============================

(global-set-key [ (control x) (/) ] 'point-to-register)
(global-set-key [ (control x) (j) ] 'jump-to-register)
(global-set-key [ (control x) (x) ] 'copy-to-register)
(global-set-key [ (control x) (g) ] 'insert-register)
(global-set-key [ (control x) (f)] 'find-file)
(global-set-key [ (meta g) ] 'goto-line)
(global-set-key [M-S-left] 'shrink-window-horizontally)
(global-set-key [M-S-right] 'enlarge-window-horizontally)
(global-set-key [M-S-down] 'shrink-window)
(global-set-key [M-S-up] 'enlarge-window)
(define-key global-map (kbd "RET") 'newline-and-indent)

;; ============================
;; Mouse Settings
;; ============================

;; mouse button one drags the scroll bar
(global-set-key [vertical-scroll-bar down-mouse-1] 'scroll-bar-drag)

;; setup scroll mouse settings
(defun up-slightly () (interactive) (scroll-up 5))
(defun down-slightly () (interactive) (scroll-down 5))
(global-set-key [mouse-4] 'down-slightly)
(global-set-key [mouse-5] 'up-slightly)

(defun up-one () (interactive) (scroll-up 1))
(defun down-one () (interactive) (scroll-down 1))
(global-set-key [S-mouse-4] 'down-one)
(global-set-key [S-mouse-5] 'up-one)

(defun up-a-lot () (interactive) (scroll-up))
(defun down-a-lot () (interactive) (scroll-down))
(global-set-key [C-mouse-4] 'down-a-lot)
(global-set-key [C-mouse-5] 'up-a-lot)

;; ===========================
;; Behaviour
;; ===========================

;; disable startup message
(setq inhibit-startup-message t
      inhibit-startup-echo-area-message t)

;; enable visual feedback on selections
(setq transient-mark-mode t)

;; parenthsis decoration
(setq show-paren-style 'expression) ; highlight whole expression

;; use vertical splitting in ediff
(setq ediff-split-window-function (lambda (&optional arg)
  (if (> (frame-width) 150)
    (split-window-horizontally arg)
    (split-window-vertically arg))))

;; define tab behavior
(define-key text-mode-map (kbd "TAB") 'self-insert-command)
(setq-default indent-tabs-mode nil)
(setq-default tab-width 3)
(setq-default c-basic-offset 3)

;; Pgup/dn will return exactly to the starting point.
(setq scroll-preserve-screen-position 1)

;; don't automatically add new lines when scrolling down at
;; the bottom of a buffer
(setq next-line-add-newlines nil)

;; by default word wrapping at the end of a window width
(setq default-truncate-lines nil)

;; scroll just one line when hitting the bottom of the window
(setq scroll-step 1)
(setq scroll-conservatively 1)

;; To make system copy work with Emacs paste and Emacs copy work with system paste
(setq x-select-enable-clipboard t)

;; turn on word wrapping in text mode
(add-hook 'text-mode-hook 'turn-on-auto-fill)

;; replace highlighted text with what I type rather than just
;; inserting at a point
(delete-selection-mode t)

;; highlight during searching
(setq query-replace-highlight t)

;; highlight incremental search
(setq search-highlight t)

;; define function to shutdown emacs server instance
(defun server-shutdown ()
  "Save buffers, Quit, and Shutdown (kill) server"
  (interactive)
  (save-some-buffers)
  (kill-emacs))

;; ============================
;; Emacs packages
;; ============================

(require 'cc-mode)
