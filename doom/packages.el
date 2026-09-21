;; -*- no-byte-compile: t; -*-
;;; packages.el

(package! gruber-darker-theme)
(package! kusanagi-theme)
(package! wakatime-mode)
(package! org-roam-ui)
(package! empv)
(package! supersonic
  :recipe (:host github :repo "systemfreund/supersonic.el")
  :pin "531c2458bf3c4516335ffb594df5d4fea8be7d71")
(package! typst-ts-mode
  :recipe (:host codeberg :repo "meow_king/typst-ts-mode")
  :pin "00048014025fc51c5c910727623d147b9a899d8c")
(package! typst-preview
  :recipe (:host github :repo "havarddj/typst-preview.el"))
(package! catppuccin-theme)
(package! pr-review
  :recipe (:host github :repo "blahgeek/emacs-pr-review"))
(package! org-typst-preview
  :recipe (:host github :repo "soliprem/org-typst-preview")
  :pin "6475957e5371e04c6ac50663a9fe44a95c1068c2")
