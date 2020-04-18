;;; package --- Summary
; inits emacs and guarantees that all required packages are installed

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
)



;; === CUSTOM CONFIGS ===

;; magit
(require 'magit)
(global-set-key (kbd "C-x g") 'magit-status)

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

;; Bell alternative
(setq visible-bell nil
      ring-bell-function 'double-flash-mode-line)
(defun double-flash-mode-line () "Flashes the mode-line twice."
  (let ((flash-sec (/ 1.0 20)))
    (invert-face 'mode-line)
    (run-with-timer flash-sec nil 'invert-face 'mode-line)
    (run-with-timer (* 2 flash-sec) nil 'invert-face 'mode-line)
    (run-with-timer (* 3 flash-sec) nil 'invert-face 'mode-line)))

;; relocate custom settings
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file :noerror)

(provide 'init)
;;; init.el ends here
