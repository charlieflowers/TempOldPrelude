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

;; Want to add C-y as yank, but to do it cofi's way, gotta find and load his personal functions. Later! TODO

;; Here are a whole bunch more org mode keys from cofi
(evil-define-key 'normal orgstruct-mode-map
  (kbd "RET") 'org-open-at-point
  "za"        'org-cycle
  "zA"        'org-shifttab
  "zm"        'hide-body
  "zr"        'show-all
  "zo"        'show-subtree
  "zO"        'show-all
  "zc"        'hide-subtree
  "zC"        'hide-all
  (kbd "M-j") 'org-shiftleft
  (kbd "M-k") 'org-shiftright
  (kbd "M-H") 'org-metaleft
  (kbd "M-J") 'org-metadown
  (kbd "M-K") 'org-metaup
  (kbd "M-L") 'org-metaright)

(evil-define-key 'insert org-mode-map
  (kbd "M-j") 'org-shiftleft
  (kbd "M-k") 'org-shiftright
  (kbd "M-H") 'org-metaleft
  (kbd "M-J") 'org-metadown
  (kbd "M-K") 'org-metaup
  (kbd "M-L") 'org-metaright)

(evil-define-key 'insert orgstruct-mode-map
  (kbd "M-j") 'org-shiftleft
  (kbd "M-k") 'org-shiftright
  (kbd "M-H") 'org-metaleft
  (kbd "M-J") 'org-metadown
  (kbd "M-K") 'org-metaup
  (kbd "M-L") 'org-metaright)


;; These are key combos I want.
(define-key evil-normal-state-map ",1" 'delete-other-windows) ;; Like emacs C-x 1 (I hope)
(define-key evil-normal-state-map "gb" 'ido-switch-buffer)    ;; Hopefully same as C-x b

;; Here is my attempt to let "jj" exit insert mode
;; Borrower from here: http://zuttobenkyou.wordpress.com/2011/02/15/some-thoughts-on-emacs-and-vim/

(define-key evil-insert-state-map "j" #'cofi/maybe-exit)

(evil-define-command cofi/maybe-exit ()
  :repeat change
  (interactive)
  (let ((modified (buffer-modified-p)))
    (insert "j")
    (let ((evt (read-event (format "Insert %c to exit insert state" ?j)
                           nil 0.5)))
      (cond
       ((null evt) (message ""))
       ((and (integerp evt) (char-equal evt ?j))
        (delete-char -1)
        (set-buffer-modified-p modified)
        (push 'escape unread-command-events))
       (t (setq unread-command-events (append unread-command-events
                                              (list evt))))))))

;; Here's a couple of org-mode keys i like:
(evil-declare-key 'normal org-mode-map "T" 'org-todo)
(evil-declare-key 'normal org-mode-map "-" 'org-cycle-list-bullet)

;; OK, I am piecing this together by myself, but it's going to be sweet!
;; I want ,TAB to do the following:
;;  1. Go to the top of the sexp I'm on (evil-backward-sentence)
;;  2. Indent the current sexp (which is the top, since we went there) (indent-pp-sexp)
;;  3. RETURN to where the cursor was originally (tricky, since shit has moved around)

;; UPDATE: There ARE solutions for # 3, but they involve some tradeoffs I don't
;;  fully understand yet, so I'm going to hold off. ,TAB is pretty awesome for now!

(define-key evil-normal-state-map ",\t" #'charlie/indent-top-sexp-and-return)

(evil-define-command charlie/indent-top-sexp-and-return ()
  (interactive)
  (evil-backward-sentence)
  (indent-pp-sexp)
  (evil-jump-backward))

;; Here's another one I'm cobbling together.
;; I want ,r to switch to the repl (when there is a repl)
(define-key evil-normal-state-map "gr" #'charlie/switch-to-repl-buffer)

(evil-define-command charlie/switch-to-repl-buffer ()
  (interactive)
  (switch-to-buffer "*slime-repl ccl*"))
