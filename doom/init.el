;;; init.el -*- lexical-binding: t; -*-

(doom! :completion
       (corfu +orderless)
       vertico

       :ui
       doom
       dashboard
       hl-todo
       modeline
       ophints
       (popup +defaults)
       (vc-gutter +pretty)
       vi-tilde-fringe
       workspaces

       :editor
       (evil +everywhere)
       file-templates
       fold
       snippets

       :emacs
       dired
       electric
       undo
       vc

       :checkers
       syntax

       :tools
       (eval +overlay)
       lookup
       magit
       tree-sitter

       :os
       (:if (featurep :system 'macos) macos)

       :lang
       emacs-lisp
       markdown
       nix
       (org +pretty +roam)
       python
       sh

       :email
       (mu4e +org +gmail +mbsync)

       :config
       (default +bindings +smartparens))
