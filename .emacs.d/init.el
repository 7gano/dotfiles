;;; load
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory
	      (expand-file-name (concat user-emacs-directory path))))
	(add-to-list 'load-path default-directory)
	(if (fboundp 'normal-top-level-add-subdirs-to-load-path)
	    (normal-top-level-add-subdirs-to-load-path))))))
;;
(add-to-load-path "elisp" "conf" "public_repos")

(require 'auto-async-byte-compile)

;;; ignore auto-compile
(setq auto-async-byte-compile-exclude-files-regexp "/junk/")
(add-hook 'emacs-lisp-mode-hook 'enable-auto-async-byte-compile-mode)
(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
(add-hook 'lisp-interaction-mode-hook 'turn-on-eldoc-mode)
(add-hook 'ielm-mode-hook 'turn-on-eldoc-mode)
(setq eldoc-idle-delay 0.1)
(setq eldoc-minor-mode-string "")

(show-paren-mode 1)

(setq-default save-place t)
(require 'saveplace)
(savehist-mode 1)
(desktop-save-mode 1)


(defmacro defkey (keymap key command)
  `(define-key ,keymap ,(read-kbd-macro key) ,command))
(defmacro gdefkey (key command)
  `(define-key global-map ,(read-kbd-macro key) ,command))

(gdefkey "C-m" 'newline-and-indent)
(keyboard-translate ?\C-h ?\C-?)
(setq inhibit-startup-screen t)

(setq indent-tabs-mode nil)
(tool-bar-mode -1)
(defalias 'yes-or-no-p 'y-or-n-p)
(scroll-bar-mode -1)

;;; minibufferで入力を取り消しても履歴に残す
(defadvice abort-recursive-edit (before minibuffer-save activate)
  (when (eq (selected-window) (active-minibuffer-window))
    (add-to-history minibuffer-history-variable (minibuffer-contents))))


(when (boundp 'show-trailing-whitespace)
  (setq-default show-trailing-whitespace t))
(set-face-background 'trailing-whitespace "lightgray")
(setq anthy-wide-space "　")

;;; 現在行に色を付ける
(global-hl-line-mode 1)
(set-face-background 'font-lock-regexp-grouping-construct "green")
(set-face-background 'hl-line "darkgreen")


(keyboard-translate ?\C-h ?\C-?)

(put 'narrow-to-region 'disabled nil)


(require 'redo+)
(global-set-key (kbd "C-M-/") 'redo)
(setq undo-no-redo t)
(setq undo-limit 60000)
(setq undo-strong-limit 600000)

;; auto-installの設定
(when (require 'auto-install nil t)
  (setq auto-install-directory "~/.emacs.d/elisp/"))


(require 'open-junk-file)
(global-set-key (kbd "C-x C-z") 'open-junk-file) 

(require 'lispxmp)

;; emacs-list-modeでC-c C-dを押すと注釈される
(define-key emacs-lisp-mode-map (kbd "C-c C-d") 'lispxmp)

(require 'paredit)
(add-hook 'emacs-lisp-mode-hook 'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook 'enable-paredit-mode)
(add-hook 'lisp-mode-hook 'enable-paredit-mode)
(add-hook 'ielm-mode-hook 'enable-paredit-mode)

(set-face-attribute 'default nil :height 130)


;https://github.com/m2ym/popwin-el/raw/master/popwin.el
(require 'popwin)
(setq display-buffer-function 'popwin:display-buffer)


(when (require 'package nil t)
  (add-to-list 'package-archives
	       '("marmalade" .  "http://marmalade-repo.org/packages/"))
  (add-to-list 'package-archives '("ELPA" . "http://tromey.com/elpa"))
  (package-initialize))

;;; Ruby
(setq ruby-indent-level 2
      ruby-deep-indent-paren-style nil
      ruby-indent-tabs-mode nil)

;; (require 'smart-compile)
;; (define-key ruby-mode-map (kbd "C-c c") 'smart-compile)
;; (define-key ruby-mode-map (kbd "C-c C-c") (kbd "C-c c C-m"))


;;; anything.el
(require 'anything-startup)


;;; shell
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
(require 'shell-history)


;;; custom key bindings
(define-key global-map (kbd "C-c C-s") 'sort-lines)
(define-key global-map (kbd "C-0") 'follow-mode)
;; "C=t"でウインドウを切り替える
(define-key global-map (kbd "C-t") 'other-window)


;; C-a / C-e
(require 'sequential-command-config)
(sequential-command-setup-keys)


(require 'auto-complete-config)
(global-auto-complete-mode t)
(auto-complete-mode 1)
(add-to-list 'ac-modes 'org-mode)
(ac-config-default)
(ac-flyspell-workaround)
(setq ac-auto-start 1)
(setq ac-auto-show-menu 0.01)
(setq ac-use-comphist t)                       ; 補完候補をソート
(setq ac-candidate-limit nil)                  ; 補完候補表示を無制限に
(setq ac-use-quick-help nil)                   ; tool tip 無し
(setq ac-use-menu-map t)                       ; キーバインド
(define-key ac-menu-map (kbd "C-n")         'ac-next)
(define-key ac-menu-map (kbd "C-p")         'ac-previous)
;(define-key ac-completing-map (kbd "RET") nil) ; return )



(setq completion-ignore-case t)
(global-auto-revert-mode 1)
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-BRACKETS)


;;https://github.com/shibayu36/emacs/tree/master/emacs.d
(when (require 'recentf nil t)
  (setq recentf-max-saved-items 2000)
  (setq recentf-exclude '(".recentf"))
  (setq recentf-auto-cleanup 10)
  (setq recentf-auto-save-timer
        (run-with-idle-timer 30 t 'recentf-save-list))
  (recentf-mode 1)
  (require'recentf-ext))

(global-set-key (kbd "M-y")'anything-show-kill-ring)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (wombat))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(delete-selection-mode t)
