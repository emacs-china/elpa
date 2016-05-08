;;; extract-package-url.el --- Extract Package URL

;; Copyright (C) 2016  Chunyang Xu
;;
;; License: GPLv3

;;; Commentary:
;;
;; Usage: elpa=the-name-of-elpa emacs -Q --batch -l extract-package-url.el

;;; Code:

(defvar extract-package-url-source-mapping
  '((gnu          . "http://elpa.gnu.org/packages/")
    (melpa        . "http://melpa.org/packages/")
    (melpa-stable . "http://stable.melpa.org/packages/")
    (marmalade    . "http://marmalade-repo.org/packages/")
    (SC           . "http://joseito.republika.pl/sunrise-commander/")
    (org          . "http://orgmode.org/elpa/"))
  "Mapping of source name and url.")

(let* ((name (getenv "elpa"))
       (url
        (and name
             (cdr (assq (intern name) extract-package-url-source-mapping)))))
  (unless url (error "Environment variable 'elpa' not set or incorrect"))
  (let ((ac-url (concat url "archive-contents"))
        (ac-file (expand-file-name "archive-contents" name)))
    (url-copy-file ac-url ac-file t)
    (with-temp-buffer
      (insert-file-contents ac-file)
      (dolist (pkg (cdr (read (buffer-string))))
        (let ((pkg-name (car pkg))
              (pkg-version (mapconcat #'number-to-string
                                      (aref (cdr pkg) 0)
                                      "."))
              (pkg-type (if (eq 'tar (aref (cdr pkg) 3))
                            "tar" "el")))
          (princ (format "%s%s-%s.%s\n" url pkg-name pkg-version pkg-type)))))))

;;; extract-package-url.el ends here
