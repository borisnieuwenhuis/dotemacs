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


; auto load all buffers on changes
(global-auto-revert-mode t) 

; Use only spaces for auto-indentation
(setq-default indent-tabs-mode nil)
(setq tab-width 4)
(add-hook 'before-save-hook 'delete-trailing-whitespace)

(require 'whitespace)

;; untabify some modes
(setq alexott/untabify-modes '(haskell-mode emacs-lisp-mode lisp-mode scheme-mode
                                            erlang-mode clojure-mode python-mode javascript-mode php-mode))
(defun alexott/untabify-hook ()
  (when (member major-mode alexott/untabify-modes)
    (untabify (point-min) (point-max))))

(add-hook 'before-save-hook 'alexott/untabify-hook)



(setq make-backup-files nil) ;no backup files
(setq auto-save-list-filen-name nil) ;no .save files
(setq auto-save-default nil) ;no auto saving

; Automatically save all buffers before compilation
; without asking
(setq compilation-ask-about-save nil)


; Use much less annoying visible bell (inverse
; video) as opposed to "beep"
(setq visible-bell t)

(add-to-list 'load-path "~/.emacs.d/vendor/textmate.el")
(require 'textmate)
(textmate-mode)

(add-to-list 'load-path "~/.emacs.d/vendor/coffee-mode")
(require 'coffee-mode)

(defun coffee-custom ()
  "coffee-mode-hook"
 (set (make-local-variable 'tab-width) 2))

(add-hook 'coffee-mode-hook
  '(lambda() (coffee-custom)))

(line-number-mode 1) ;display line number in the mode line
(column-number-mode 1) ;display column number in the mode line

;looks like this must be last
(if (window-system) (set-frame-size (selected-frame) 124 80))
(if (window-system) (set-frame-position (selected-frame) 200 40))

;make ctrl-c/v/x work
(cua-mode t)


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


;save buffer history
(desktop-save-mode 1)

;save mini buffer history
(savehist-mode 1)

;show line numbers
(global-linum-mode 1)

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


(setq default-directory "~/work/bliep/bliep" )

;; load tags file
(visit-tags-table "~/work/bliep/bliep/TAGS")


(require 'uniquify)
(setq
  uniquify-buffer-name-style 'post-forward
  uniquify-separator ":")

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

(require 'python)

(setq frame-title-format
      (list (format "%s %%S: %%j " (system-name))
        '(buffer-file-name "%f" (dired-directory dired-directory "%b"))))


(require 'lambda-mode)
(add-hook 'python-mode-hook #'lambda-mode 1)

(setq lambda-symbol (string (make-char 'greek-iso8859-7 107)))

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

(defun create-tags (dir-name)
     "Create tags file."
     (interactive "DDirectory: ")
     (eshell-command
      (format "find %s -type f -name \"*.[ch]\" | etags -L -" dir-name)))

(defmacro cmd (name &rest body)
  "declare an interactive command without all the boilerplate"
  `(defun ,name ()
     (interactive)
     ,@body))

(defmacro bind (key fn)
"shortcut for global-set-key"
        `(global-set-key (kbd ,key)
        ;; handle unquoted function names and lambdas
        ,(if (listp fn)
         fn
       `',fn)))

(cmd isearch-other-window
     (save-selected-window
       (other-window 1)
       (isearch-forward)))

(bind "C-M-S" isearch-other-window)

(defun quick-copy-line ()
      "Copy the whole line that point is on and move to the beginning of the next line.
    Consecutive calls to this command append each line to the
    kill-ring."
      (interactive)
      (let ((beg (line-beginning-position 1))
            (end (line-beginning-position 2)))
        (if (eq last-command 'quick-copy-line)
            (kill-append (buffer-substring beg end) (< end beg))
          (kill-new (buffer-substring beg end))))
      (beginning-of-line 2))


