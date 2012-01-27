;; Tell emacs where is your personal elisp lib dir
;; this is the dir you place all your extra packages
(add-to-list 'load-path "~/.emacs.d/")

;; load the packaged named xyz.
(load "package") ;; best not to include the ending “.el” or “.elc”

(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

;(defun turn-on-paredit () (paredit-mode 1))
;(add-hook 'clojure-mode-hook 'turn-on-paredit)

(fset 'save-and-compile "\C-x\C-s\C-c\C-k")
(global-set-key [f7] 'save-and-compile)

(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
;(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))

(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)

(setq make-backup-files nil) ;no backup files
(setq auto-save-list-filen-name nil) ;no .save files
(setq auto-save-default nil) ;no auto saving

; Automatically save all buffers before compilation
; without asking
(setq compilation-ask-about-save nil)


; Use much less annoying visible bell (inverse
; video) as opposed to "beep"
(setq visible-bell t)


(line-number-mode 1) ;display line number in the mode line
(column-number-mode 1) ;display column number in the mode line

;looks like this must be last
(if (window-system) (set-frame-size (selected-frame) 124 80))
(if (window-system) (set-frame-position (selected-frame) 200 40))

;make ctrl-c/v/x work
(cua-mode t)


(setq show-paren-mode t)
(setq show-paren-style 'parenthesis)
(setq blink-matching-paren t)

(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )

;syntax highlight in slime
(add-hook 'slime-repl-mode-hook 'clojure-mode-font-lock-setup)

;; auto complete
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
(ac-config-default)
(setq ac-delay 0.1)

; Use only spaces for auto-indentation
(setq-default indent-tabs-mode nil)

(defun select-next-window ()
  "Switch to the next window"
  (interactive)
  (select-window (next-window)))

(defun select-previous-window ()
  "Switch to the previous window"
  (interactive)
  (select-window (previous-window)))

(global-set-key (kbd "M-<right>") 'select-next-window)
(global-set-key (kbd "M-<left>")  'select-previous-window)

(setq default-directory "~/work" )

(add-hook 'python-mode-hook '(lambda ()
 (setq python-indent 4)
 (setq indent-tabs-mode nil)))

(require 'uniquify)
(setq
  uniquify-buffer-name-style 'post-forward
  uniquify-separator ":")

;; untabify some modes
(setq alexott/untabify-modes '(haskell-mode emacs-lisp-mode lisp-mode scheme-mode
                                            erlang-mode clojure-mode python-mode javascript-mode php-mode))
(defun alexott/untabify-hook ()
  (when (member major-mode alexott/untabify-modes)
    (untabify (point-min) (point-max))))

(add-hook 'before-save-hook 'alexott/untabify-hook)


;rainbow-delimiters
(add-hook 'clojure-mode-hook 'rainbow-delimiters-mode)

(require 'color-theme-zenburn)
(color-theme-zenburn)

(ido-mode t)
(ido-everywhere t)
(setq ido-enable-flex-matching t)

(defun ido-find-file-in-tag-files ()
      (interactive)
      (save-excursion
        (let ((enable-recursive-minibuffers t)) (visit-tags-table-buffer))
        (find-file (expand-file-name
                    (ido-completing-read "Project file: "
                                         (tags-table-files) nil t)))))

(ido-better-flex/enable)

(global-set-key "\C-t" 'ido-find-file-in-tag-files)

(setq compilation-error-regexp-alist nil)
(setq compilation-error-regexp-alist-alist nil)

(setq frame-title-format
      (list (format "%s %%S: %%j " (system-name))
        '(buffer-file-name "%f" (dired-directory dired-directory "%b"))))

(add-to-list 'load-path "~/.emacs.d/vendor/python-mode.el-6.0.4")
(setq py-install-directory "~/.emacs.d/vendor/python-mode.el-6.0.4")
(require 'python-mode)

(add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))

(require 'pymacs)
(autoload 'pymacs-apply "pymacs")
(autoload 'pymacs-call "pymacs")
(autoload 'pymacs-eval "pymacs" nil t)
(autoload 'pymacs-exec "pymacs" nil t)
(autoload 'pymacs-load "pymacs" nil t)
;;(eval-after-load "pymacs"
;;  '(add-to-list 'pymacs-load-path YOUR-PYMACS-DIRECTORY"))

(add-to-list 'load-path "~/.emacs.d/vendor/pymacs-0.24-beta2")
(require 'pymacs)
(pymacs-load "ropemacs" "rope-")
(setq ropemacs-enable-autoimport t)

(setq ipython-command "/usr/local/bin/ipython")
(require 'ipython)

(add-hook 'before-save-hook 'delete-trailing-whitespace)

(require 'lambda-mode)
(add-hook 'python-mode-hook #'lambda-mode 1)

(setq lambda-symbol (string (make-char 'greek-iso8859-7 107)))

(require 'anything)
(require 'anything-ipython)
(when (require 'anything-show-completion nil t)
   (use-anything-show-completion 'anything-ipython-complete
                                 '(length initial-pattern)))

(setq pylookup-dir "~/.emacs.d/pylookup")
(add-to-list 'load-path pylookup-dir)

;; load pylookup when compile time
(eval-when-compile (require 'pylookup))

;; set executable file and db file
(setq pylookup-program (concat pylookup-dir "/pylookup.py"))
(setq pylookup-db-file (concat pylookup-dir "/pylookup.db"))

;; set search option if you want
;; (setq pylookup-search-options '("--insensitive" "0" "--desc" "0"))

;; to speedup, just load it on demand
(autoload 'pylookup-lookup "pylookup"
  "Lookup SEARCH-TERM in the Python HTML indexes." t)

(autoload 'pylookup-update "pylookup"
  "Run pylookup-update and create the database at `pylookup-db-file'." t)

(require 'python-pep8)
(require 'python-pylint)

;;; A quick & ugly PATH solution to Emacs on Mac OSX
(if (string-equal "darwin" (symbol-name system-type))
   (setenv "PATH" (concat "/opt/local/bin:/opt/local/sbin:" (getenv "PATH"))))

(defun create-tags (dir-name)
     "Create tags file."
     (interactive "DDirectory: ")
     (eshell-command
      (format "find %s -type f -name \"*.[ch]\" | etags -L -" dir-name)))
