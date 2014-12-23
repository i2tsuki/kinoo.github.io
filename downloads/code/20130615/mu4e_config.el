(require 'mu4e)
(require 'smtpmail)

(setq mu4e-use-fancy-chars nil)
(setq mu4e-attachment-dir "~/Downloads")
(setq mu4e-view-show-images t
      mu4e-view-image-max-width 800)
(set-language-environment "UTF-8")
(setq message-kill-buffer-on-exit t)

(setq mu4e-maildir "~/Maildir")
(setq message-send-mail-function 'smtpmail-send-it)
(defvar my-mu4e-account-alist
      '(("Main"
	 (user-mail-address "kdkk-@main.co.jp")
	 (mu4e-inbox-folder "/Main/INBOX")
         (mu4e-sent-folder "/Main/Sent")
         (mu4e-drafts-folder "/Main/Drafts")
	 (mu4e-trash-folder  "/Main/Trash")
	 (mu4e-get-mail-command "offlineimap")
	 (mu4e-update-interval 300)
	 (user-full-name  "kdkk-")
	 (smtpmail-debug-info t) ; only to debug problems
	 (smtpmail-stream-type ssl)
	 (starttls-use-gnutls nil)
	 (smtpmail-smtp-server "main.co.jp")
	 (smtpmail-smtp-service 465)
	 (message-signature
	  (concat
	   "kdkk-<kdkk-@main.co.jp>"
	   "\n")))
        ("Gmail"
	 (mu4e-inbox-folder "/Gmail/INBOX")
	 (mu4e-drafts-folder "/[Gmail].Drafts")
	 (mu4e-sent-folder   "/[Gmail].Sent Mail")
	 (mu4e-trash-folder  "/[Gmail].Trash")
	 (mu4e-get-mail-command "offlineimap -a Gmail")
	 (mu4e-update-interval 300)
         (user-mail-address "****@gmail.com")
	 (starttls-use-gnutls t)
	 (smtpmail-default-smtp-server "smtp.gmail.com")
	 (smtpmail-smtp-server "smtp.gmail.com")
	 (smtpmail-smtp-service 587)
	 (message-signature
	  (concat
	   "kdkk-<****@gmail.com>"
	   "\n")))
))

(defun my-mu4e-set-account ()
  "Set the account for composing a message."
  (let* ((account
	  (if mu4e-compose-parent-message
	      (let ((maildir (mu4e-message-field mu4e-compose-parent-message :maildir)))
		(string-match "/\\(.*?\\)/" maildir)
		(match-string 1 maildir))
	    (completing-read (format "Compose with account: (%s) "
				     (mapconcat #'(lambda (var) (car var)) my-mu4e-account-alist "/"))
			     (mapcar #'(lambda (var) (car var)) my-mu4e-account-alist)
			     nil t nil nil (caar my-mu4e-account-alist))))
	 (account-vars (cdr (assoc account my-mu4e-account-alist))))
    (if account-vars
	(mapc #'(lambda (var)
		  (set (car var) (cadr var)))
	      account-vars)
      (error "No email account found"))))

(add-hook 'mu4e-compose-pre-hook 'my-mu4e-set-account)
;; don't save message to Sent Messages, Gmail/IMAP takes care of this
(setq mu4e-sent-messages-behavior 'delete)

;; setup some handy shortcuts
;; you can quickly switch to your Inbox -- press ``ji''
;; then, when you want archive some messages, move them to
;; the 'All Mail' folder by pressing ``ma''.
(setq mu4e-maildir-shortcuts
      '( ("/Main/INBOX" . ?i)
	 ("/Gmail/INBOX" . ?g)
))
;; Attach_File_with_Dired
(require 'gnus-dired)
(defun gnus-dired-mail-buffers ()
  "Return a list of active message buffers."
  (let (buffers)
    (save-current-buffer
      (dolist (buffer (buffer-list t))
     	(set-buffer buffer)
     	(when (and (derived-mode-p 'message-mode)
		   (null message-sent-message-via))
     	  (push (buffer-name buffer) buffers))))
    (nreverse buffers)))

(setq gnus-dired-mail-mode 'mu4e-user-agent)
(add-hook 'dired-mode-hook 'turn-on-gnus-dired-mode)
