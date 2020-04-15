;; === SETUP ===
(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/"))
(package-initialize)
(package-refresh-contents)

;; === CUSTOM CHECK FUNCTION ===
(defun ensure-package-installed (&rest packages)
  "Assure every package is installed, ask for installation if it’s not.
     Return a list of installed packages or nil for every skipped package."
  (mapcar
   (lambda (package)
     (unless (package-installed-p package)
       (package-install package)))
   packages)
  )

;; === INSTALLED PACKAGES ===
(ensure-package-installed
    'projectile
    'magit
    'evil
    'eldoc
    'irony
    'irony-eldoc
    'flycheck
    'flycheck-irony
    'counsel
    'smartparens
    'xcscope
    'rust-mode
    'which-key
)

;; === CUSTOM CONFIGS ===

;; which-key
(require 'which-key)
(which-key-mode)

;; rust
(require 'rust-mode)
(add-hook 'rust-mode-hook
	  (lambda () (setq indent-tabs-mode nil)))
(setq rust-format-on-save t)

;; evil
(require 'evil)
;(evil-set-initial-state 'cscope-list-entry-mode 'emacs) ;; Why does this not work... workaround in ctags settings
(evil-mode 1)

;; Projectile
(require 'projectile)
(projectile-mode 1)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

;; irony
(require 'irony)
(add-hook 'c-mode-hook 'irony-mode)
(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
(define-key irony-mode-map (kbd "s-/") 'irony-get-type)

;; eldoc
(require 'eldoc)
(require 'irony-eldoc)
(add-hook 'irony-mode-hook #'irony-eldoc)

;; flycheck
(require 'flycheck)
(require 'flycheck-irony)
(add-hook 'c-mode-hook 'flycheck-mode)
(add-hook 'c++-mode-hook 'flycheck-mode)
(add-hook 'flycheck-mode-hook #'flycheck-irony-setup)

;; counsel-irony
(defun my-irony-mode-hook ()
  (define-key irony-mode-map
    [remap completion-at-point] 'counsel-irony)
  (define-key irony-mode-map
    [remap complete-symbol] 'counsel-irony))
(add-hook 'irony-mode-hook 'my-irony-mode-hook)

;; /smartparens/: insert pair of symbols
;; when you press RET, the curly braces automatically add another newline
(require 'smartparens-config)
(add-hook 'c-mode-hook #'smartparens-mode)
(add-hook 'c++-mode-hook #'smartparens-mode)
(sp-with-modes '(c-mode c++-mode)
  (sp-local-pair "{" nil :post-handlers '(("||\n[i]" "RET")))
  (sp-local-pair "/*" "*/" :post-handlers '(("| " "SPC") ("* ||\n[i]" "RET"))))

;; ctags
(require 'xcscope)
(add-hook 'cscope-list-entry-hook
	  (lambda () (evil-emacs-state 1)))
(cscope-setup)

;; === AUTO GENERATED ===
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(custom-enabled-themes (quote (tango-dark)))
 '(package-selected-packages
   (quote
    (which-key magit ## flycheck-irony irony-eldoc evil irony))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
