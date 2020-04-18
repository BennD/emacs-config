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
    'magit
    'evil
    'flycheck
    'smartparens
    'which-key
)

;; === CUSTOM CONFIGS ===

;; which-key
(require 'which-key)
(which-key-mode)

;; evil
(require 'evil)
(evil-mode 1)

;; flycheck
(require 'flycheck)
(require 'flycheck-irony)
(add-hook 'c-mode-hook 'flycheck-mode)
(add-hook 'c++-mode-hook 'flycheck-mode)

;; /smartparens/: insert pair of symbols
;; when you press RET, the curly braces automatically add another newline
(require 'smartparens-config)
(add-hook 'c-mode-hook #'smartparens-mode)
(add-hook 'c++-mode-hook #'smartparens-mode)
(sp-with-modes '(c-mode c++-mode)
  (sp-local-pair "{" nil :post-handlers '(("||\n[i]" "RET")))
  (sp-local-pair "/*" "*/" :post-handlers '(("| " "SPC") ("* ||\n[i]" "RET"))))

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
