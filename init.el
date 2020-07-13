;;; package --- Summary
; inits emacs and guarantees that all required packages are installed
;
; MANDATORY STEPS
; - M-x all-the-icons-install-fonts | installs all needed icons/fonts

;;; Commentary:
; type completion alternatives: helm-lsp, lsp-ivy
; - do these integrate with company?
; 
; debugger: dap-mode | https://github.com/emacs-lsp/dap-mode
; - integrates nice with lsp-mode apperently
;				 
; project-treeview: lsp-treemacs
; - (doom-themes-treemacs-config)
;
; company-box | https://github.com/sebastiencs/company-box/
; - better frondend for company (no tty support though)

;;; Code:
(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/")
	     '("gnu" . "http://elpa.gnu.org/packages/"))
(package-initialize)
(package-refresh-contents)

(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)

(use-package treemacs
  :ensure t
  :init
  (setq treemacs-deferred-git-apply-delay      0.5
	treemacs-directory-name-transformer    #'identity
	treemacs-display-in-side-window        t
	treemacs-eldoc-display                 t
	treemacs-file-event-delay              5000
	treemacs-file-follow-delay             0.2
	treemacs-file-name-transformer         #'identity
	treemacs-follow-after-init             t
	treemacs-git-command-pipe              ""
	treemacs-goto-tag-strategy             'refetch-index
	treemacs-indentation                   2
	treemacs-indentation-string            " "
	treemacs-is-never-other-window         nil
	treemacs-max-git-entries               5000
	treemacs-missing-project-action        'ask
	treemacs-move-forward-on-expand        nil
	treemacs-no-png-images                 nil
	treemacs-no-delete-other-windows       t
	treemacs-project-follow-cleanup        nil
	treemacs-persist-file                  (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
	treemacs-position                      'left
	treemacs-recenter-distance             0.1
	treemacs-recenter-after-file-follow    nil
	treemacs-recenter-after-tag-follow     nil
	treemacs-recenter-after-project-jump   'always
	treemacs-recenter-after-project-expand 'on-distance
	treemacs-show-cursor                   nil
	treemacs-show-hidden-files             t
	treemacs-silent-filewatch              nil
	treemacs-silent-refresh                nil
	treemacs-sorting                       'alphabetic-asc
	treemacs-space-between-root-nodes      t
	treemacs-tag-follow-cleanup            t
	treemacs-tag-follow-delay              1.5
	treemacs-user-mode-line-format         nil
	treemacs-width                         35)
  :config
  (setq treemacs-collapse-dirs                 (if treemacs-python-executable 3 0)
	treemacs-file-extension-regex          treemacs-last-period-regex-value)
  ;; The default width and height of the icons is 22 pixels. If you are
  ;; using a Hi-DPI display, uncomment this to double the icon size.
  ;;(treemacs-resize-icons 44)
  (treemacs-follow-mode t)
  (treemacs-filewatch-mode t)
  (treemacs-fringe-indicator-mode t)
  (defun treemacs-visit-node-and-close (&optional arg)
    "Visit node and hide treemacs window."
    (interactive "P")
    (funcall-interactively treemacs-default-visit-action arg)
    (treemacs))
  (treemacs-define-RET-action 'file-node-closed 'treemacs-visit-node-and-close)
  (add-to-list 'treemacs-pre-file-insert-predicates #'treemacs-is-file-git-ignored?) ;; use .gitignore to hide files
  (pcase (cons (not (null (executable-find "git")))
	       (not (null treemacs-python-executable)))
    (`(t . t)
     (treemacs-git-mode 'extended))
    (`(t . _)
     (treemacs-git-mode 'simple))))

(use-package treemacs-evil
  :after treemacs evil
  :ensure t)

(use-package treemacs-projectile
  :after treemacs projectile
  :ensure t)

(use-package treemacs-icons-dired
  :after treemacs dired
  :ensure t
  :config
  (treemacs-icons-dired-mode))

(use-package treemacs-magit
  :after treemacs magit
  :ensure t)

(use-package ace-window
  :ensure t)

(use-package perspective
  :ensure t
  :config
  (persp-mode))

;; evil
(use-package evil
  :ensure t
  :config
  (evil-mode 1))

;; amx
(use-package amx
  :ensure t)

;; magit
(use-package magit
  :ensure t)

;; projectile
(use-package projectile
  :ensure t
  :init
  (setq projectile-track-known-projects-automatically nil)
  :config
  (projectile-mode 1))

;; which-key
(use-package which-key
  :ensure t
  :config
  (which-key-mode)
  (which-key-setup-side-window-bottom))

;; general
(use-package general
  :ensure t)

;; smartparens
(use-package smartparens
  :ensure t
  :hook
  (prog-mode . smartparens-mode)
  :config
  (sp-with-modes '(c-mode c++-mode)
    (sp-local-pair "{" nil :post-handlers '(("||\n[i]" "RET")))
    (sp-local-pair "/*" "*/" :post-handlers '(("| " "SPC") ("* ||\n[i]" "RET")))))

;; flycheck
(use-package flycheck
  :ensure t
  :hook
  (prog-mode . flycheck-mode)
  :init
  (setq flycheck-idle-change-delay 1))

;; rust
(use-package rust-mode
  :ensure t)

;; flycheck-rust
(use-package flycheck-rust
  :after flycheck
  :ensure t
  :hook
  (flycheck-mode-hook . flycheck-rust-setup))

;; company
(use-package company
  :ensure t
  :init
  (setq company-minimum-prefix-length 1
	company-idle-delay 0.1)
  :config
  (company-tng-configure-default))

(use-package company-lsp
  :ensure t
  :after company
  :config
  (push 'company-lsp company-backends))

;; LSP-mode
(use-package lsp-mode
  :after flycheck
  :ensure t
  :hook
  (prog-mode . lsp)
  (prog-mode . lsp-enable-which-key-integration)
  :init
  (setq lsp-idle-delay 1
	lsp-keymap-prefix "SPC l")
  (defvar lsp-rust-server "rust-analyzer"))

(use-package lsp-ui
  :ensure t
  :after lsp-mode
  :init
  (setq lsp-ui-sideline-delay 1
	lsp-ui-doc-enable nil))

;; doom modeline
(use-package doom-modeline
  :ensure t
  :config
  (doom-modeline-mode 1))

;; doom themes
(use-package doom-themes
  :ensure t
  :init
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
	doom-themes-enable-italic t) ; if nil, italics is universally disabled
  :config
  (doom-themes-visual-bell-config)
  (doom-themes-org-config))

;; general settings
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(show-paren-mode t)
(setq tab-width 4)

;; 'general' keybindings
(general-define-key
 :prefix "SPC"
 :states '(normal emacs)

 ;; ungrouped
 "" '(nil :wk "LeaderKey")
 "SPC" '(amx :wk "M-x")
 "g" '(magit-status :wk "git")
 "f" '(treemacs :wk "files")
 "P C-x" '(nil :wk "UNUSED")

 ;; window
 "w" '(nil :wk "window")
 "w w" '(ace-window :wk "window")
 "w d" '(nil :wk "delete")
 "w d d" '(delete-window :wk "this")
 "w d o" '(delete-other-windows :wk "others")

 ;; buffer
 "b" '(nil :wk "buffer")
 "b TAB" '(mode-line-other-buffer :wk "last")
 "b n" '(next-buffer :wk "next")
 "b p" '(previous-buffer :wk "previous")
 "b r" '(revert-buffer :wk "revert")
 "b s" '(save-buffer :wk "save")
 "b e" '(eval-buffer :wk "eval")

 ;; keymaps
 "p" '(projectile-command-map :wk "projectile") ;; why is this different?
 "e" '(:keymap flycheck-command-map :wk "flycheck")
 "l" '(:keymap lsp-command-map :wk "LSP")
 "P" '(:keymap perspective-map :wk "Perspective")
)

;; relocate custom settings
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file :noerror)

;; relocate backup files to for less clutter
(setq backup-directory-alist '(("." . "~/.emacs_backup_files")))

(provide 'init)
;;; init.el ends here
