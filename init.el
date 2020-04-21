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
(setq flycheck-highlighting-mode nil)
(add-hook 'prog-mode-hook 'flycheck-mode)

;; company
(require 'company)
(require 'company-lsp)
(setq company-minimum-prefix-length 1
      company-idle-delay 0.1) ;; default is 0.2
(push 'company-lsp company-backends)

;; LSP-mode
(require 'lsp-ui)
(require 'lsp-mode)
(setq lsp-idle-delay 1)
(setq lsp-ui-sideline-delay 1)
(setq lsp-ui-doc-enable nil)
(setq lsp-keymap-prefix "SPC l") ;; fix which-key integration, doesn't actually bind (i think)
(add-hook 'prog-mode-hook 'lsp)
(add-hook 'prog-mode-hook 'lsp-enable-which-key-integration)

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
 :states '(normal emacs)

 ;; ungrouped
 "" '(nil :which-key "Leader Key")
 "SPC" '(amx :which-key "M-x")
 "g" 'magit-status

 ;; window
 "w" '(nil :which-key "window")
 "w d" '(nil :which-key "delete")
 "w d m" '(delete-window :which-key "this")
 "w d o" '(delete-other-windows :which-key "others")

 ;; buffer - bundle into keymap
 "b" '(nil :which-key "buffer")
 "b TAB" 'mode-line-other-buffer
 "b n" 'next-buffer
 "b p" 'previous-buffer

 ;; keymaps
 "p" '(projectile-command-map :which-key "projectile") ;; why is this different?
 "e" '(:keymap flycheck-command-map :which-key "flycheck")
 "l" '(:keymap lsp-command-map :which-key "LSP")
)

;; relocate custom settings
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file :noerror)

;; relocate backup files to for less clutter
(setq backup-directory-alist '(("." . "~/.emacs_backup_files")))

(provide 'init)
;;; init.el ends here
