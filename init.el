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
;
; company-box | https://github.com/sebastiencs/company-box/
; - better frondend for company (no tty support though)
;
; neotree | https://github.com/jaypei/emacs-neotree
; - (doom-themes-neotree-config) to enable doom-themes for neotree

;;; Code:
;; === SETUP ===
(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/")
	     '("gnu" . "http://elpa.gnu.org/packages/"))
(package-initialize)
(package-refresh-contents)

;; === CUSTOM CHECK FUNCTION ===
(defun ensure-package-installed (&rest packages) "Ensures all PACKAGES are installed."
  (mapcar
   (lambda (package)
     (unless (package-installed-p package)
       (package-install package)))
   packages)
  )

;; === INSTALLED PACKAGES ===
(ensure-package-installed
    'magit          ;; https://github.com/magit/magit
    'evil           ;; https://github.com/emacs-evil/evil
    'flycheck       ;; https://github.com/flycheck/flycheck
    'smartparens    ;; https://github.com/Fuco1/smartparens
    'which-key      ;; https://github.com/justbur/emacs-which-key
    'lsp-mode       ;; https://github.com/emacs-lsp/lsp-mode
    'lsp-ui         ;; https://github.com/emacs-lsp/lsp-ui
    'company        ;; https://github.com/company-mode/company-mode
    'company-lsp    ;; https://github.com/tigersoldier/company-lsp
    'rustic         ;; https://github.com/brotzeit/rustic
    'doom-modeline  ;; https://github.com/seagle0128/doom-modeline
    'all-the-icons  ;; https://github.com/domtronn/all-the-icons.el
    'doom-themes    ;; https://github.com/hlissner/emacs-doom-themes
    'projectile     ;; https://github.com/bbatsov/projectile
    'general        ;; https://github.com/noctuid/general.el
    'amx            ;; https://github.com/DarwinAwardWinner/amx
)



;; === CUSTOM CONFIGS ===

;; amx
(require 'amx)

;; magit
(require 'magit)

;; projectile
(require 'projectile)
(projectile-mode +1)

;; which-key
(require 'which-key)
(which-key-mode)

;; evil
(require 'evil)
(evil-mode 1)

;; smartparens
(require 'smartparens-config)
(add-hook 'prog-mode-hook 'smartparens-mode)
(sp-with-modes '(c-mode c++-mode rustic-mode)
  (sp-local-pair "{" nil :post-handlers '(("||\n[i]" "RET")))
  (sp-local-pair "/*" "*/" :post-handlers '(("| " "SPC") ("* ||\n[i]" "RET"))))

;; rustic
(require 'rustic)
(setq rustic-lsp-server 'rust-analyzer)
(add-hook 'rust-mode-hook 'rustic-mode)

;; flycheck
(require 'flycheck)
(global-flycheck-mode 1)

;; company
(require 'company)
(require 'company-lsp)
(setq company-minimum-prefix-length 1
      company-idle-delay 0.1) ;; default is 0.2
(push 'company-lsp company-backends)

;; LSP-mode
(require 'lsp-ui)
(require 'lsp-mode)
(setq lsp-idle-delay 0.1)
(add-hook 'prog-mode-hook 'lsp)
(add-hook 'lsp-mode 'lsp-enable-which-key-integration)

;; doom modeline
(require 'doom-modeline)
(doom-modeline-mode 1)

;; doom themes
(require 'doom-themes)
(setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
      doom-themes-enable-italic t) ; if nil, italics is universally disabled
(doom-themes-visual-bell-config)
(doom-themes-org-config)

;; hightlight matching bracket
(show-paren-mode t)

;; hide toolbar/menubar
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

;; 'general' keybindings
(general-define-key
 :prefix "SPC"
 :keymaps '(normal emacs)
 "SPC" 'amx
 "p" 'projectile-command-map
 "g" 'magit-status)

;; relocate custom settings
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file :noerror)

(provide 'init)
;;; init.el ends here
