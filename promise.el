(require 'cl-lib)

(defun promise-get-handler (pred-symbol)
  "get promise function for PRED-SYMBOL"
  (get pred-symbol 'promise-function))

(defun promise-set-handler (pred-symbol promise-function)
  "set promise function of PRED-SYMBOL to be PROMISE-FUNCTION"
  (put pred-symbol 'promise-function promise-function))

(defmacro promise (form &optional promise-fn)
  (declare (debug t))
  (let ((pred-fn (car form))
        (pred-args (cdr form))
        (args (cl-gensym "args-")))
    (cl-assert (symbolp pred-fn))
    (let ((promise-fn (or promise-fn
                          (promise-get-handler pred-fn)
                          (intern (format "promise-%s" pred-fn)))))
      (unless (promise-get-handler pred-fn)
        (promise-set-handler pred-fn promise-fn))
      `(let ((,args (list ,@pred-args)))
         (unless (apply #',pred-fn ,args)
           (apply #',promise-fn ,args))))))

(defun promise-file-exists-p (file)
  ""
  (with-temp-file file))


;; (macroexpand '(promise (file-exists-p "/tmp/ttt.log")))
;; (macroexpand '(promise (file-exists-p "/tmp/ttt1.log")
;;                        (lambda (file)
;;                          (message "create %s" file))))
;; (promise-set-handler 'file-exists-p 'create-file)
;; (macroexpand '(promise (file-exists-p "/tmp/ttt.log")))
