;;; ../../dotfiles/doom/.config/doom/lisp/programs.el -*- lexical-binding: t; -*-

;; make a function to run a program with a given name and arguments
(defun run-program (name &rest args)
  (interactive)
  (let ((program (executable-find name)))
    (if program
        (apply #'start-process name nil program args)
      (error "Could not find program %s" name))))
