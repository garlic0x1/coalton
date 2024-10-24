;;;; settings.lisp
;;;;
;;;; This file contains variables that can be used to control how
;;;; Coalton works.

(defpackage #:coalton-impl/settings
  (:use #:cl)
  (:export
   #:coalton-release-p                  ; FUNCTION
   #:*coalton-disable-specialization*   ; VARIABLE
   #:*coalton-print-unicode*            ; VARIABLE
   #:*emit-type-annotations*            ; VARIABLE
   #:*coalton-optimize*                 ; VARIABLE
   #:*coalton-optimize-library*         ; VARIABLE
   #:*compile-print-types*              ; VARIABLE
   ))

(in-package #:coalton-impl/settings)

(declaim (type boolean *coalton-print-unicode*))
(defvar *coalton-print-unicode* t
  "Whether to print coalton info using unicode symbols")

(defun coalton-release-p ()
  "Determines how redefinable code generated by Coalton is.

In development mode (i.e. (not (coalton-release-p))), Coalton turns all declare-type forms into CLOS objects
to support a repl based workflow.

In release mode Coalton compiles declare-type forms into frozen structs or even more optimal layouts which may
not support redefinition.

Development mode is the default.

Enable release mode either by setting the UNIX environment variable COALTON_ENV to \"release\", or by pushing
`:coalton-release' into `*features*'. Either of these must be done before loading Coalton.
"
  (uiop:featurep :coalton-release))

(when (string-equal (uiop:getenv "COALTON_ENV") "release")
  (pushnew :coalton-release *features*))

(when (coalton-release-p)
  (format t "~&;; COALTON starting in release mode~%"))

(declaim (type boolean *coalton-disable-specialization*))
(defvar *coalton-disable-specialization* nil)

(when (find (uiop:getenv "COALTON_DISABLE_SPECIALIZATION")
            '("t" "true" "1")
            :test #'string-equal)
  (format t "~&;; COALTON starting with specializations disabled")
  (setf *coalton-disable-specialization* t))

;; Configure the backend to remove type annotations from the generated code
(declaim (type boolean *emit-type-annotations*))
(defvar *emit-type-annotations* t)

(declaim (type boolean *compile-print-types*))
(defvar *compile-print-types* nil
  "Print types of definitions to standard output on compile.")

(defvar *coalton-optimize* '(optimize (speed 3) (safety 0)))

(defvar *coalton-optimize-library* '(optimize (speed 3) (safety 1)))
