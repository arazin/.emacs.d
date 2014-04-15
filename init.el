;; (custom-set-variables
;;   ;; custom-set-variables was added by Custom.
;;   ;; If you edit it by hand, you could mess it up, so be careful.
;;   ;; Your init file should contain only one such instance.
;;   ;; If there is more than one, they won't work right.
;;  '(graphviz-dot-auto-indent-on-braces t)
;;  '(graphviz-dot-indent-width 1)
;;  '(inhibit-startup-screen t))

;;;emacs24設定
(require 'cl)

;;;日本語設定
(set-language-environment 'Japanese)
(prefer-coding-system 'utf-8)
(setq default-coding-systems 'utf-8)
(setq file-name-coding-system 'utf-8)
(setq locale-coding-system 'utf-8)

;; default to better frame titles
(setq frame-title-format
			(concat "%b - emacs@" (system-name)))


;;;----------------------------------------------
;;;パッケージ管理
;;;package.el
;;;please execute M-x list-package at first
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)


(setq load-path
			(append (list 
							 (expand-file-name "~/Dropbox/elisp/")
							 (expand-file-name "~/Dropbox/elisp/yasnippet")
  							 ;; ここの""のなかにパスを設定できる
							 )
							load-path))

;; .editorconfigで editorの設定共有
(load "editorconfig")

;; 改行キーでオートインデントさせる
(global-set-key "\C-m" 'newline-and-indent)
(global-set-key "\C-j" 'newline)

;;デフォルトの透明度を設定する
(add-to-list 'default-frame-alist '(alpha . 95))


;; tab 幅を 2 に設定
(setq-default tab-width 2)

;; スタートスクリーンの非表示
(setq inhibit-startup-screen t)

;;ツールバー、スクロールバーの非表示
(tool-bar-mode 0)
(toggle-scroll-bar 0)

;;set C-h Backspace
(global-set-key "\C-h" 'delete-backward-char)

;;オートセーブ
(require 'auto-save-buffers)
(run-with-idle-timer 1 t 'auto-save-buffers)


;; 対応する括弧を光らせる
(show-paren-mode 1)

;; １行ずつスクロールさせる
(setq scroll-step 1)

;; 行表示
(require 'linum)
(global-linum-mode t)

;;; beepを消す
(setq visible-bell t)
;;; 何もおこらなくする
(setq ring-bell-function '(lambda ()))

;;; バックアップファイルを作らない
(setq backup-inhibited t)

;; popwin buttompop
(require 'popwin)
(setq display-buffer-function 'popwin:display-buffer)

(setq popwin:popup-window-position 'bottom)


;; フレームサイズの設定
(setq default-frame-alist
			(append (list
							 '(width . 90)
							 '(height . 100)
							 '(top . 100)
							 '(left . 900)
							 )
							default-frame-alist))

;;smart-compileの実装
(require 'smart-compile)
(global-set-key "\C-cc" 'smart-compile)
(define-key menu-bar-tools-menu [compile] '("Compile ... " . smart-compile))

(add-to-list 'smart-compile-alist '("\\.cs$"     . "gmcs %f"))

;;shell-pop.el
(require 'shell-pop)
(shell-pop-set-internal-mode "ansi-term")
(shell-pop-set-internal-mode-shell "/bin/bash")
(defvar ansi-term-after-hook nil)
(add-hook 'ansi-term-after-hook
					(function
					 (lambda ()
						 (define-key term-raw-map "\C-t" 'shell-pop))))
(defadvice ansi-term (after ansi-term-after-advice (arg))
	"run hook as after advice"
	(run-hooks 'ansi-term-after-hook))
(ad-activate 'ansi-term)

(global-set-key "\C-t" 'shell-pop)
;; カラーテーマの設定


																				;(require 'color-theme)
																				;(color-theme-initialize)
																				;(color-theme-salmon-diff)
(defun my-color-theme ()
	(interactive)
	(color-theme-install
	 '(my-color-theme
		 ((background-color . "#000C00")
			(foreground-color . "#D3D3D3")
			(background-mode . dark)
			(border-color . "#323232")
			(cursor-color . "#FFA500")
			(mouse-color . "#323232"))
		 
		 (mode-line ((t (:foreground "#FFFFFF" :background "#323232"))))
		 ;; (region ((t (:background "#323232"))))
		 (region ((t (:background "#767676"))))
		 
		 (font-lock-comment-face ((t (:foreground "#FF6850"))))
		 (font-lock-constant-face ((t (:foreground "#D28000"))))
		 (font-lock-builtin-face ((t (:foreground "#CD73C9"))))
		 (font-lock-function-name-face ((t (:foreground "#FF78AA"))))
		 (font-lock-variable-name-face ((t (:foreground "#9F79EE"))))
		 (font-lock-keyword-face ((t (:foreground "#CD1076"))))
		 (font-lock-string-face ((t (:foreground "#FFC400"))))
		 (font-lock-doc-string-face ((t (:foreground "#FFC400"))))
		 (font-lock-type-face ((t (:foreground "#FF34B3"))))
		 )))
;; (color-theme initialize)??
;; (require 'color-theme)
;; (my-color-theme)
(when (not (eq (symbol-value 'window-system) 0))
	(require 'color-theme)
	(my-color-theme))

																				;auto-insert
(require 'autoinsert)

;; テンプレートのディレクトリ
(setq auto-insert-directory "~/Dropbox/elisp/auto-insert")

;; 各ファイルによってテンプレートを切り替える
(setq auto-insert-alist
      (nconc '(
               ("\\.cpp$" . ["template.cpp" my-template])
							 ("\\.c$" . ["template.c" my-template])
               ("\\.pl$" . ["template.pl" my-template])
               ("\\.tex$" . ["template.tex" my-template])
							 ("\\.gnu$" . ["template.gnu" my-template])
							 ("\\.html$" . ["template.html" my-template])
							 ("\\.php$" . ["template.html" my-template])
							 ("\\.cs$" . ["template.cs" my-template])
               ) auto-insert-alist))
(require 'cl)

;; ここが腕の見せ所
(defvar template-replacements-alists
  '(("%file%"             . (lambda () (file-name-nondirectory (buffer-file-name))))
    ("%file-without-ext%" . (lambda () (file-name-sans-extension (file-name-nondirectory (buffer-file-name)))))
    ("%include-guard%"    . (lambda () (format "__SCHEME_%s__" (upcase (file-name-sans-extension (file-name-nondirectory buffer-file-name))))))))

(defun my-template ()
  (time-stamp)
  (mapc #'(lambda(c)
						(progn
							(goto-char (point-min))
							(replace-string (car c) (funcall (cdr c)) nil)))
				template-replacements-alists)
  (goto-char (point-max))
  (message "done."))
(add-hook 'find-file-not-found-hooks 'auto-insert)





;;yatex-mode 
(setq load-path 
			(append '("~/Dropbox/elisp/yatex1.77") load-path)) 
(autoload 'yatex-mode "yatex" "Yet Another LaTeX mode" t) 
(setq dvi2-command "evince" 
			tex-command "platex --kanji=utf8" 
			dviprint-command-format "dvips %s | lpr" 
			YaTeX-kanji-code 4) 
;; *.texの拡張子をもつファイルを開いた場合、自動的にyatexを起動 
(setq auto-mode-alist 
			(cons (cons "\\.tex$" 'yatex-mode) auto-mode-alist)) 
;; (setq dvi2-command "evince" 
;;       tex-command "sh ~/.platex2pdf.sh" 
;;     dviprint-command-format "dvips %s | lpr" 
;;     YaTeX-kanji-code 3)
(setq YaTeX-dvi2-command-ext-alist
      '(("xdvi\\|dvipdmx".".dvi")
        ("ghostview\\lgv".".ps")
        ("evince" . ".pdf")))

;; flymake
(require 'flymake)
(defun flymake-cc-init ()
  (let* ((temp-file (flymake-init-create-temp-buffer-copy
										 'flymake-create-temp-inplace))
				 (local-file (file-relative-name
											temp-file
											(file-name-directory buffer-file-name))))
    (list "g++" (list "-Wall" "-Wextra" "-fsyntax-only" local-file))))
(push '("\\.cpp$" flymake-cc-init) flymake-allowed-file-name-masks)
(push '("\\.c$" flymake-cc-init) flymake-allowed-file-name-masks)
(defadvice flymake-post-syntax-check (before flymake-force-check-was-interrupted)
  (setq flymake-check-was-interrupted t))
(ad-activate 'flymake-post-syntax-check)

;; flymake popup
(global-set-key (kbd "M-e") 'flymake-goto-next-error)
(global-set-key (kbd "M-E") 'flymake-goto-prev-error)
;; Show error message under current line
(require 'popup)
(defun flymake-display-err-menu-for-current-line ()
  (interactive)
  (let* ((line-no (flymake-current-line-no))
         (line-err-info-list (nth 0 (flymake-find-err-info flymake-err-info line-no))))
    (when line-err-info-list
      (let* ((count (length line-err-info-list))
             (menu-item-text nil))
        (while (> count 0)
          (setq menu-item-text (flymake-ler-text (nth (1- count) line-err-info-list)))
          (let* ((file (flymake-ler-file (nth (1- count) line-err-info-list)))
                 (line (flymake-ler-line (nth (1- count) line-err-info-list))))
            (if file
                (setq menu-item-text (concat menu-item-text " - " file "(" (format "%d" line) ")"))))
          (setq count (1- count))
          (if (> count 0) (setq menu-item-text (concat menu-item-text "\n")))
          )
        (popup-tip menu-item-text)))))
(if (eq 'unspecified (face-attribute 'popup-tip-face :height))
    (set-face-attribute 'popup-tip-face nil :height 1.0))
(if (eq 'unspecified (face-attribute 'popup-tip-face :weight))
    (set-face-attribute 'popup-tip-face nil :weight 'normal))
(defun my/display-error-message ()
  (let ((orig-face (face-attr-construct 'popup-tip-face)))
    (set-face-attribute 'popup-tip-face nil
                        :height 1.5 :foreground "firebrick"
                        :background "LightGoldenrod1" :bold t)
    (unwind-protect
        (flymake-display-err-menu-for-current-line)
      (while orig-faceDropbox/programming/myself/aoj/
        (set-face-attribute 'popup-tip-face nil (car orig-face) (cadr orig-face))
        (setq orig-face (cddr orig-face))))))
(defadvice flymake-goto-prev-error (after flymake-goto-prev-error-display-message)
  (my/display-error-message))
(defadvice flymake-goto-next-error (after flymake-goto-next-error-display-message)
  (my/display-error-message))
(ad-activate 'flymake-goto-prev-error 'flymake-goto-prev-error-display-message)
(ad-activate 'flymake-goto-next-error 'flymake-goto-next-error-display-message)

;; flymake for C/C++ 
(add-hook 'c++-mode-hook
					'(lambda ()
						 (flymake-mode t)))
(add-hook 'c-mode-hook
					'(lambda ()
						 (flymake-mode t)))


;; flymake for php
(defun flymake-php-init ()
  (let* ((temp-file (flymake-init-create-temp-buffer-copy
                     'flymake-create-temp-inplace))
         (local-file (file-relative-name
                      temp-file
                      (file-name-directory buffer-file-name))))
    (list "php" (list "-l" local-file))))
(push '(".+\\.php$" flymake-php-init) flymake-allowed-file-name-masks)
(push '("(Parse|Fatal) error: (.*) in (.*) on line ([0-9]+)" 3 4 nil 2) flymake-err-line-patterns)

(add-hook 'web-mode-hook
					'(lambda ()
						 (flymake-mode t)))

;;html php multi mode web-mode
(require 'web-mode)
;;; 適用する拡張子
(add-to-list 'auto-mode-alist '("\\.phtml$"     . web-mode))
(add-to-list 'auto-mode-alist '("\\.php$" . web-mode))
(add-to-list 'auto-mode-alist '("\\.ctp$" . web-mode))
(add-to-list 'auto-mode-alist '("\\.jsp$"       . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x$"   . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb$"       . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?$"     . web-mode))

;;; インデント数
(defun web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-html-offset   2)
  (setq web-mode-css-offset    2)
  (setq web-mode-script-offset 2)
  (setq web-mode-php-offset    2)
  (setq web-mode-java-offset   2)
  (setq web-mode-asp-offset    2))
(add-hook 'web-mode-hook 'web-mode-hook )

;; 色の設定
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(web-mode-comment-face ((t (:foreground "#D9333F"))))
 '(web-mode-css-at-rule-face ((t (:foreground "#FF7F00"))))
 '(web-mode-css-pseudo-class-face ((t (:foreground "#FF7F00"))))
 '(web-mode-css-rule-face ((t (:foreground "#A0D8EF"))))
 '(web-mode-doctype-face ((t (:foreground "#82AE46"))))
 '(web-mode-html-attr-name-face ((t (:foreground "#C97586"))))
 '(web-mode-html-attr-value-face ((t (:foreground "#82AE46"))))
 '(web-mode-html-tag-face ((t (:foreground "#E6B422" :weight bold))))
 '(web-mode-server-comment-face ((t (:foreground "#D9333F")))))


;; (custom-set-variables
;;  ;; custom-set-variables was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(indent-tabs-mode nil)
;;  '(tab-width 2))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(indent-tabs-mode t)
 '(tab-width 2))


;; マークダウンモード
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;; 文字数表示
(column-number-mode t)
;; 選択範囲の情報表示
(defun count-lines-and-chars ()
  (if mark-active
      (format "[%3d:%4d]"
              (count-lines (region-beginning) (region-end))
              (- (region-end) (region-beginning)))
    ""))
(add-to-list 'default-mode-line-format
             '(:eval (count-lines-and-chars)))



;;csharp-mode
(autoload 'csharp-mode "csharp-mode" "Major mode for editing C# code." t)
(setq auto-mode-alist
			(append '(("\\.cs$" . csharp-mode)) auto-mode-alist))

(defvar my-csharp-default-compiler nil)
(setq my-csharp-default-compiler "mono @@FILE@@")
(require 'yasnippet)
(defun my-csharp-mode-fn ()
	"function that runs when csharp-mode is initialized for a buffer."
	(turn-on-auto-revert-mode)
	(setq indent-tabs-mode nil)
	;; (require 'flymake)
	;; (flymake-mode 1)
	(require 'yasnippet)
	(yas/minor-mode-on)
	;; (require 'rfringe)
	(c-set-offset 'substatement-open 0)
	(c-set-offset 'case-label '+)
	(c-set-offset 'arglist-intro '+)
	(c-set-offset 'arglist-close 0)
  )
(add-hook  'csharp-mode-hook 'my-csharp-mode-fn t)


