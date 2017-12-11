(in-package :cl-user)
(defpackage ceramic.shell
  (:use :cl)
  (:shadow :close)
  (:import-from :ceramic.window
                :window-id)
  (:import-from :ceramic.driver
                :*driver*
                :sync-js)
  (:export :hello
           :open-external-links
           :open-all-external-links))
(in-package :ceramic.shell)

(defun hello ()
  (format t "yep !"))

(defun open-external-links (selector)
  (sync-js *driver*
           (format nil
                   "
                    const links = document.querySelectors('~a');
                    Array.prototype.forEach.call(links, function (link) {
                        const url = link.getAttribute('href');
                        if (url.indexOf('http') === 0) {
                            link.addEventListener('click', function (e) {
                              e.preventDefault();
                              shell.openExternal(url);
                            })
                        }
                    })
                    " selector)))

(defun open-all-external-links ()
  "Open all external links with an external application."
  (open-external-links "a[href]"))
