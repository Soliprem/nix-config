;; -*- no-byte-compile: t; -*-
;;; packages.el

(package! gruber-darker-theme)
(package! kusanagi-theme)
(package! wakatime-mode)
(package! org-roam-ui)
(package! typst-ts-mode
  :recipe (:host codeberg :repo "meow_king/typst-ts-mode")
  :pin "00048014025fc51c5c910727623d147b9a899d8c")
(package! typst-preview
  :recipe (:host github :repo "havarddj/typst-preview.el"))
(package! catppuccin-theme)
(package! pr-review
  :recipe (:host github :repo "blahgeek/emacs-pr-review"))
