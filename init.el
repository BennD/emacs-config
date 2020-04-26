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
    'neotree        ;; https://github.com/jaypei/emacs-neotree
)



;; === CUSTOM CONFIGS ===

;; evil
(require 'evil)
(evil-mode 1)

;; amx
(require 'amx)

;; magit
(require 'magit)

;; projectile
(require 'projectile)
(projectile-mode +1)

;; neotree
(require 'neotree)
(evil-set-initial-state 'neotree-mode 'emacs)
(setq neo-theme 'icons)
(setq neo-smart-open t)
(defun custom-neotree-enter-hide ()
  "Deine Mama."
  (interactive)
  (neotree-enter)
  (neotree-hide)
)

;; which-key
(require 'which-key)
(which-key-mode)
(which-key-setup-side-window-right-bottom)

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
 "" '(nil :wk "LeaderKey")
 "SPC" '(amx :wk "M-x")
 "g" 'magit-status
 "n" 'neotree-toggle

 ;; window
 "w" '(nil :wk "window")
 "w d" '(nil :wk "delete")
 "w d m" '(delete-window :wk "this")
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
)

;; neotree keybindings
(general-define-key
 :keymaps 'neotree-mode-map
 "j" 'next-logical-line
 "k" 'previous-logical-line
 "l" 'neotree-quick-look
 "RET" 'custom-neotree-enter-hide
)

;; relocate custom settings
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file :noerror)

;; relocate backup files to for less clutter
(setq backup-directory-alist '(("." . "~/.emacs_backup_files")))

(provide 'init)
;;; init.el ends here
