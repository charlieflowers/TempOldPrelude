(add-to-list 'load-path "~/.emacs.d/personal/evil")
(require 'evil)
(evil-mode 1)
(setq evil-default-state 'normal)

;; This is from cofi's evil config ... i think it colors the "evil state" indicator, to make it stand out more.
(setq evil-normal-state-tag   (propertize "N" 'face '((:background "green" :foreground "black")))
      evil-emacs-state-tag    (propertize "E" 'face '((:background "orange" :foreground "black")))
      evil-insert-state-tag   (propertize "I" 'face '((:background "red")))
      evil-motion-state-tag   (propertize "M" 'face '((:background "blue")))
      evil-visual-state-tag   (propertize "V" 'face '((:background "grey80" :foreground "black")))
      evil-operator-state-tag (propertize "O" 'face '((:background "purple"))))

;; Certain modes need to start up in Emacs mode (especially the freaking repl! ... or does it?) And this makes that happen (taken from cofi evil)
(loop for (mode . state) in '((inferior-emacs-lisp-mode      . emacs)
                              (pylookup-mode                 . emacs)
                              (comint-mode                   . emacs)
                              (ebib-entry-mode               . emacs)
                              (ebib-index-mode               . emacs)
                              (ebib-log-mode                 . emacs)
                              (gtags-select-mode             . emacs)
                              (shell-mode                    . emacs)
                              (term-mode                     . emacs)
                              (bc-menu-mode                  . emacs)
                              (magit-branch-manager-mode-map . emacs)
                              (semantic-symref-results-mode  . emacs)
                              (rdictcc-buffer-mode           . emacs))
      do (evil-set-initial-state mode state))

;; A couple of key bindings for insert mode that are useful (from cofi evil)
(fill-keymap evil-insert-state-map
             "C-y" 'yank
             )
