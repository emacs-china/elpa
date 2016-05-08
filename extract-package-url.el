;;; extract-package-url.el --- Extract Package URL

;; Copyright (C) 2016  Chunyang Xu
;;
;; Package-Requires: ((emacs "24.4"))
;;
;; License: GPLv3

;;; Commentary:
;;
;; Usage: elpa=the-name-of-elpa emacs -Q --batch -l extract-package-url.el

;;; Code:

(require 'package)

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
  (if url
      (setq package-archives (list (cons name url)))
    (error "Environment variable 'elpa' not set or incorrect")))

(package-refresh-contents)

(dolist (elt package-archive-contents)
  (let* ((pkg-desc (cadr elt))
         (location (package-archive-base pkg-desc))
         (file (concat (package-desc-full-name pkg-desc)
                       (package-desc-suffix pkg-desc))))
    (princ (format "%s%s\n" location file))))

;;; extract-package-url.el ends here
