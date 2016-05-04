;;; extract-package-url.el --- Extract Package URL

;; Copyright (C) 2016  Chunyang Xu
;;
;; License: GPLv3

;;; Commentary:
;;
;; Usage: emacs -Q --batch -l extract-package-url.el

;;; Code:

(require 'package)

(setq package-user-dir (expand-file-name "elpa" temporary-file-directory))

(package-refresh-contents)

(dolist (elt package-archive-contents)
  (let* ((pkg-desc (cadr elt))
         (location (package-archive-base pkg-desc))
         (file (concat (package-desc-full-name pkg-desc)
                       (package-desc-suffix pkg-desc))))
    (princ (format "%s%s\n" location file))))

;;; extract-package-url.el ends here
