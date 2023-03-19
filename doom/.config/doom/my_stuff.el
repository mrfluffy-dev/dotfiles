;;; ../../dotfiles/doom/.config/doom/my_stuff.el -*- lexical-binding: t; -*-

(defun emenu ()
  "List all executable programs in the PATH environment variable and open the selected one.
  Any text entered after the program name (separated by a space) is taken as arguments to the program."
  (interactive)
  (let* ((path-dirs (delete-dups (split-string (getenv "PATH") path-separator)))
         (executables (apply #'append
                             (mapcar #'(lambda (dir)
                                         (when (file-directory-p dir)
                                           (mapcar #'file-name-nondirectory
                                                   (directory-files dir t ".+"
                                                                    'nosort))))
                                     path-dirs)))
         (buf (generate-new-buffer "Programs")))
    (with-current-buffer buf
      (insert (mapconcat 'identity executables "\n")))
    (let* ((program (completing-read "Program: " executables))
           (args (if (string-match (concat "^" program " ") (buffer-substring-no-properties
                                                             (line-beginning-position)
                                                             (line-end-position)))
                     (substring-no-properties (buffer-substring-no-properties
                                               (line-beginning-position)
                                               (line-end-position)) (length program) nil)
                   nil))
           (program-args (if args (concat program " " args) program)))
      (when program
        (start-process-shell-command program nil program-args)
        (kill-buffer buf)))))
(map! :leader
      :desc "Emenu" "d e" #'emenu)


;; open pdfs scaled in zathura
(defun open-pdf-with-zathura ()
  (interactive)
  (start-process "zathura" nil "zathura" (buffer-file-name)))

(add-hook 'pdf-view-mode-hook
          (lambda ()
            (open-pdf-with-zathura)
            (kill-buffer)))

;; open images in imv
(defun open-image-with-imv ()
  "Open the current image file with imv, then kill the current buffer and
open a dired buffer in the directory of the image file."
  (interactive)
  (let* ((current-file (buffer-file-name))
         (directory (file-name-directory current-file))
         (all-files (directory-files directory nil "\\(png\\|jpg\\|jpeg\\|gif\\|bmp\\)$"))
         (selected-file (file-relative-name current-file directory))
         (selected-index (cl-position selected-file all-files :test #'equal))
         (sorted-files (append (nthcdr selected-index all-files)
                               (butlast all-files (- (length all-files) selected-index)))))
    (apply 'start-process "imv" nil "imv" sorted-files))
  (let ((image-dir (when buffer-file-name (file-name-directory buffer-file-name))))
    (kill-buffer)
    (when image-dir
      (cd image-dir)
      (dired image-dir))))

(add-hook 'image-mode-hook
          (lambda ()
            (open-image-with-imv)))


(add-hook 'doom-switch-buffer-hook
          (lambda ()
            (if (string= (buffer-name) "*doom*")
                (elcord-mode -1)
              (elcord-mode 1))))

;; search forwards for link and copy the link under point to the clipboard withouth external dependencies
(defun elfeed-copy-image ()
  "Copy the URL of the image under point to the clipboard."
  (interactive)
  (or (search-forward "link" nil t)
      (search-backward "link" nil t))
        (let ((url (get-text-property (point) 'shr-url)))
        (if url
                (progn
                (message (concat "Copying image URL to clipboard: " url))
                (kill-new url)
                (message "Copied image URL to clipboard."))
        (message "No image under point."))))
;;bind the function to a key spc i c
(map! :leader
      :desc "Copy image URL to clipboard" "i c" #'elfeed-copy-image)


(defun open-video-with-mpv ()
  "Open the current video file with mpv, then kill the current buffer and
open a dired buffer in the directory of the video file."
  (interactive)
  (setq large-file-warning-threshold nil) ; disable threshold
  (let ((current-file (buffer-file-name)))
    (start-process "mpv" nil "mpv" current-file))
  (let ((video-dir (when buffer-file-name (file-name-directory buffer-file-name))))
    (kill-buffer)
    (when video-dir
      (cd video-dir)
      (dired video-dir))))

(add-hook 'find-file-hook
          (lambda ()
            (when (and buffer-file-name
                       (string-match-p "\\(mp4\\|avi\\|mkv\\|webm\\|flv\\|mov\\|wmv\\)$" buffer-file-name))
              (open-video-with-mpv))))


(defun open-audio-with-mpv ()
  "Open the current audio file with mpv, then kill the current buffer and
open a dired buffer in the directory of the audio file."
  (interactive)
  (setq large-file-warning-threshold nil) ; disable threshold
  (let ((current-file (buffer-file-name)))
    (start-process "mpv" nil "mpv" "--no-video" current-file))
  (let ((audio-dir (when buffer-file-name (file-name-directory buffer-file-name))))
    (kill-buffer)
    (when audio-dir
      (cd audio-dir)
      (dired audio-dir))))

(add-hook 'find-file-hook
          (lambda ()
            (when (and buffer-file-name
                       (string-match-p "\\(mp3\\|flac\\|wav\\|aac\\|ogg\\|m4b\\)$" buffer-file-name))
              (open-audio-with-mpv))))
