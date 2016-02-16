(require 'cl-lib)
(defmacro promise (form &optional promise-fn)
  (declare (debug t))
  (let* ((pred-fn (car form))
         (pred-args (cdr form))
         (args (cl-gensym "args-"))
         (promise-fn (or promise-fn
                         (intern (format "%s-promise" pred-fn)))))
    (cl-assert (symbolp pred-fn))
    `(let ((,args (list ,@pred-args)))
       (unless (apply #',pred-fn ,args)
         (apply #',promise-fn ,args)))))

(defun file-exists-p-promise (file)
  ""
  (with-temp-file file))


;; (macroexpand '(promise (file-exists-p "/tmp/ttt.log")))
;; (promise (file-exists-p "/tmp/ttt1.log")
;;          (lambda (file)
;;            (message "create %s" file)))
