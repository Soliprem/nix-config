;;; config.el -*- lexical-binding: t; -*-

;;; Appearance

(setq doom-theme 'kusanagi
      doom-font (font-spec :size 12.0)
      display-line-numbers-type 'relative
      display-line-numbers-current-absolute t)

;;; Authentication

(setq auth-sources '("/run/agenix/gonic_authinfo" "~/.authinfo" "/run/agenix/gomuks_authinfo"))

;;; Development

(after! envrc
  (defadvice! +envrc-cade-env-dir-p-a (dir)
    :before-until #'envrc--env-dir-p
    (file-exists-p (expand-file-name ".cade" dir)))

  (defadvice! +envrc-cade-status-a ()
    :override #'envrc--direnv-allowed-status-code
    ;; Cade 0.1.3 has text status only; use JSON when it supports it.
    (with-temp-buffer
      (unless (zerop (process-file "cade" nil t nil "status"))
        (error "Cade status failed: %s" (buffer-string)))
      (goto-char (point-min))
      (cond
       ((re-search-forward "^root: +none " nil t) nil)
       ((re-search-forward "^  .+  \\[\\([^]]+\\)\\]$" nil t)
        (pcase (match-string 1)
          ("allowed, composed" 0)
          ((pred (string-prefix-p "not allowed")) 2)
          (_ (error "Unrecognised Cade trust status"))))
       (t (error "Unrecognised Cade status output")))))

  (defadvice! +envrc-cade-command-a (original verb)
    :around #'envrc--run-direnv
    (if (equal verb "reload")
        ;; A fresh JSON export makes Cade recheck its watched files.
        (envrc--with-required-current-env env-dir
          (envrc--get-current-env-or-run-direnv t))
      (let ((envrc-direnv-executable "cade"))
        (funcall original (if (equal verb "deny") "disallow" verb))))))

(after! code-review
  (require 'ghub-legacy)
  (setq code-review-auth-login-marker 'forge))

(use-package! pr-review
  :commands (pr-review
             pr-review-notification
             pr-review-search
             pr-review-search-open)
  :init
  (setq pr-review-ghub-auth-name 'forge))

(use-package! wakatime-mode
  :ensure t
  :config
  (global-wakatime-mode 1))

;;; Org

(setq org-directory "~/Documents/org/"
      org-roam-directory org-directory
      org-roam-dailies-directory "dailies/")

(after! org
  (custom-set-faces!
    '(org-document-title :weight bold :height 1.5)
    '(org-level-1 :weight bold :height 1.35)
    '(org-level-2 :weight bold :height 1.25)
    '(org-level-3 :weight bold :height 1.15)
    '(org-level-4 :weight bold :height 1.1)))

(use-package! org-roam-ui
  :after org-roam
  :commands org-roam-ui-mode
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start t))

(use-package! org-typst-preview
  :after org)

;; To enable it in every Org buffer
(add-hook 'org-mode-hook #'org-typst-preview-mode)

;;; Julia

(use-package! julia-snail
  :hook ((julia-mode julia-ts-mode) . julia-snail-mode)
  :config
  (setq-default julia-snail-multimedia-enable t)
  (setq-default julia-snail-extensions '(formatter))
  (advice-add #'julia-snail :around #'envrc-propagate-environment)
  (map! :map julia-snail-mode-map
        :localleader
        :desc "Start or open Julia REPL" "'" #'julia-snail
        :desc "Activate Julia project" "a" #'julia-snail-package-activate
        :desc "Look up documentation" "d" #'julia-snail-doc-lookup
        :desc "Update module cache" "r" #'julia-snail-update-module-cache
        :desc "Interrupt Julia task" "i" #'julia-snail-interrupt-task
        :desc "Copy last result" "y" #'julia-snail-copy-last-eval-result
        :desc "Evaluate expression or region" "e e" #'julia-snail-send-dwim
        :desc "Evaluate line" "e l" #'julia-snail-send-line
        :desc "Evaluate region" "e r" #'julia-snail-send-region
        :desc "Evaluate file" "e b" #'julia-snail-send-buffer-file
        :desc "Evaluate top-level form" "e f" #'julia-snail-send-top-level-form
        :desc "Format buffer" "f" #'julia-snail/formatter-format-buffer
        :desc "Format region" "F" #'julia-snail/formatter-format-region)
  (map! :map julia-snail-repl-mode-map
        :localleader
        :desc "Return to source" "m" #'julia-snail-repl-go-back
        :desc "Activate Julia project" "a" #'julia-snail-package-activate
        :desc "Look up documentation" "d" #'julia-snail-doc-lookup
        :desc "Update module cache" "r" #'julia-snail-update-module-cache))

;;; Typst

(use-package! typst-ts-mode
  :mode "\\.typ\\'"
  :hook (typst-ts-mode . eglot-ensure)
  :config
  (map! :map typst-ts-mode-map
        :localleader
        (:prefix ("c" . "compile")
         "c" #'typst-ts-compile
         "p" #'typst-ts-compile-and-preview)
        (:prefix ("p" . "preview")
         "p" #'typst-preview-mode
         "s" #'typst-preview-send-position)))

(after! eglot
  (add-to-list 'eglot-server-programs '(typst-ts-mode . ("tinymist"))))

(use-package! typst-preview
  :commands (typst-preview-mode
             typst-preview-send-position)
  :init
  (setq typst-preview-browser "xwidget")
  :config
  (defun +typst-preview-in-right-window (open-browser browser hostname)
    "Open the embedded Typst preview on the right without moving focus."
    (if (equal browser "xwidget")
        (let ((switch-to-buffer-obey-display-actions t)
              (display-buffer-overriding-action
               '((display-buffer-reuse-window display-buffer-in-direction)
                 (direction . right)
                 (window-width . 0.5)
                 (inhibit-same-window . t))))
          (save-selected-window
            (funcall open-browser browser hostname)))
      (funcall open-browser browser hostname)))
  (advice-add 'typst-preview--connect-browser :around
              #'+typst-preview-in-right-window))

;;; Mail

(set-email-account! "unibo"
  '((user-full-name . "Francesco Prem Solidoro")
    (user-mail-address . "francesco.solidoro@studio.unibo.it")
    (smtpmail-smtp-user . "francesco.solidoro@studio.unibo.it")
    (message-sendmail-extra-arguments . ("--read-envelope-from" "--account=unibo"))
    (mu4e-sent-folder . "/unibo/Sent")
    (mu4e-drafts-folder . "/unibo/Drafts")
    (mu4e-trash-folder . "/unibo/Trash")
    (mu4e-refile-folder . "/unibo/Archives"))
  t)

(set-email-account! "gmail"
  '((user-full-name . "Francesco Prem Solidoro")
    (user-mail-address . "franci.solidoro@gmail.com")
    (smtpmail-smtp-user . "franci.solidoro@gmail.com")
    (message-sendmail-extra-arguments . ("--read-envelope-from" "--account=gmail"))
    (mu4e-sent-folder . "/gmail/[Gmail]/Sent Mail")
    (mu4e-drafts-folder . "/gmail/[Gmail]/Drafts")
    (mu4e-trash-folder . "/gmail/[Gmail]/Bin")
    (mu4e-refile-folder . "/gmail/[Gmail]/All Mail")))

(set-email-account! "soliprem-accounts"
  '((user-full-name . "Francesco Prem Solidoro")
    (user-mail-address . "accounts@soliprem.eu")
    (smtpmail-smtp-user . "accounts@soliprem.eu")
    (message-sendmail-extra-arguments . ("--read-envelope-from" "--account=soliprem-accounts"))
    (mu4e-sent-folder . "/soliprem-accounts/Sent")
    (mu4e-drafts-folder . "/soliprem-accounts/Drafts")
    (mu4e-trash-folder . "/soliprem-accounts/Trash")
    (mu4e-refile-folder . "/soliprem-accounts/Archive")))

(set-email-account! "soliprem"
  '((user-full-name . "Francesco Prem Solidoro")
    (user-mail-address . "soliprem@soliprem.eu")
    (smtpmail-smtp-user . "soliprem@soliprem.eu")
    (message-sendmail-extra-arguments . ("--read-envelope-from" "--account=soliprem"))
    (mu4e-sent-folder . "/soliprem/Sent")
    (mu4e-drafts-folder . "/soliprem/Drafts")
    (mu4e-trash-folder . "/soliprem/Trash")
    (mu4e-refile-folder . "/soliprem/Archive")))

(after! mu4e
  (setq mu4e-maildir "~/.local/share/mail"
        mu4e-update-interval 300
        mu4e-context-policy 'pick-first
        mu4e-compose-context-policy 'always-ask
        sendmail-program (executable-find "msmtp")
        send-mail-function #'smtpmail-send-it
        message-sendmail-f-is-evil t
        message-sendmail-extra-arguments '("--read-envelope-from")
        message-send-mail-function #'message-send-mail-with-sendmail
        mu4e-read-option-use-builtin nil
        mu4e-completing-read-function #'completing-read))

;;; Music

(after! emms
  (require 'emms-player-mpv)
  (setq emms-player-list '(emms-player-mpv)))

(use-package! empv
  :commands (empv-play empv-subsonic-search empv-subsonic-artists
             empv-subsonic-albums empv-subsonic-songs)
  :init
  (map! :leader
        :prefix ("o e" . "empv")
        "/" #'empv-subsonic-search
        "A" #'empv-subsonic-artists
        "B" #'empv-subsonic-albums
        "S" #'empv-subsonic-songs)
  :config
  (require 'auth-source)
  (setq empv-subsonic-url "https://nv.soliprem.eu")
  (when-let* ((auth (car (auth-source-search :host empv-subsonic-url
                                           :require '(:user :secret)))))
    (setq empv-subsonic-username (plist-get auth :user)
          empv-subsonic-password (auth-info-password auth))))

(use-package! gomuks
  :commands gomuks
  :init
  (map! :leader
        :desc "Gomuks"
        "o g" #'gomuks))

(use-package! sub-buffer
  :commands sub-buffer
  :init
  (setq sub-buffer-server "https://nv.soliprem.eu")
  (map! :leader
        :desc "sub-buffer"
        "o s" #'sub-buffer))

(use-package! supersonic
  :bind ("C-c s" . supersonic)
  :config
  (require 'auth-source)
  (setq supersonic-host "https://nv.soliprem.eu"))

(after! (supersonic evil)
  (map! :map (supersonic-artist-mode-map supersonic-album-mode-map
              supersonic-album-type-mode-map supersonic-tracks-mode-map
              supersonic-search-mode-map supersonic-queue-mode-map
              supersonic-now-playing-mode-map supersonic-podcast-mode-map
              supersonic-podcast-episodes-mode-map)
        :n "q" #'quit-window
        :n "?" #'supersonic
        :n "s" #'supersonic-search
        :n "t" #'supersonic-toggle-playing
        :n "]" #'supersonic-skip-track
        :n "[" #'supersonic-prev-track
        :n ">" #'supersonic-seek-forward
        :n "<" #'supersonic-seek-back
        :n "Q" #'supersonic-show-queue
        :n "N" #'supersonic-show-now-playing)
  (map! :map supersonic-artist-mode-map
        :n "RET" #'supersonic-open-album
        :n "gr" #'supersonic-artists-revert
        :map (supersonic-album-mode-map supersonic-album-type-mode-map)
        :n "RET" #'supersonic-open-tracks
        :n "a" #'supersonic-enqueue-album
        :map supersonic-tracks-mode-map
        :n "RET" #'supersonic-play-tracks
        :n "a" #'supersonic-enqueue-tracks
        :map supersonic-search-mode-map
        :n "RET" #'supersonic-open-search-result
        :map supersonic-queue-mode-map
        :n "gr" #'supersonic-queue-refresh
        :map supersonic-now-playing-mode-map
        :n "gr" #'supersonic-now-playing-refresh
        :n "RET" #'push-button
        :n "TAB" #'forward-button
        :n "<backtab>" #'backward-button
        :map supersonic-podcast-mode-map
        :n "RET" #'supersonic-open-podcast-episodes
        :n "a" #'supersonic-add-podcast
        :n "?" #'supersonic-podcast-help
        :map supersonic-podcast-episodes-mode-map
        :n "RET" #'supersonic-play-podcast
        :n "d" #'supersonic-download-podcast-episode
        :n "?" #'supersonic-podcast-episode-help))
