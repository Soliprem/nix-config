;;; config.el -*- lexical-binding: t; -*-

(setq doom-theme 'gruber-darker
      display-line-numbers-type 'relative
      display-line-numbers-current-absolute t
      auth-sources '("~/.authinfo")
      org-directory "~/Documents/org/"
      org-roam-directory org-directory
      org-roam-dailies-directory "dailies/"
      doom-font (font-spec :size 12.0))

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
             typst-preview-send-position))

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
