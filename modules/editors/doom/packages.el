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
  :pin "baa97a92781d0e9882b4e72c327233c283350146")
(package! gomuks
  :recipe (:host github :repo "soliprem/gomuks.el")
  :pin "312f89f0aadc95fc3d0e83e13f28ecb4dd7c6a9e")
(package! sub-buffer
  :recipe (:host github :repo "soliprem/sub-buffer.el")
  :pin "0df80c374c505b23d1f921f8cfdd764e89ac26a6")
