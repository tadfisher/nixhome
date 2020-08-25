{ config, lib, pkgs, ... }:

with lib;

let
  pass = config.programs.pass.stores.".local/share/pass/personal";

  cfgNotmuch = config.programs.notmuch;

  cfgEmail = config.accounts.email;

  notmuchAccounts = filter (a: a.notmuch.enable) (attrValues cfgEmail.accounts);

  # Enable prompting for sender if multiple accounts are defined.
  notmuchPromptFrom = if length notmuchAccounts > 1 then "'t" else "nil";

  elispMaildirPaths = let
    mkPath = account: ''("${account.address}" . "${account.maildir.absPath}")'';
  in '''(${concatMapStringsSep " " mkPath notmuchAccounts})'';

  elispFromAddress =
    ''(nth 1 (mail-extract-address-components (message-field-value "From")))'';

  # The host part of the `from` variable.
  elispFromHost = ''(nth 1 (split-string from "@"))'';

  messageSendHookFunction = ''
    (setq hm--message-maildir-paths ${elispMaildirPaths})

    (defun hm--message-send ()
      (make-local-variable 'message-user-fqdn)
      (make-local-variable 'message-sendmail-extra-arguments)
      (let* ((from ${elispFromAddress})
             (path (alist-get from hm--message-maildir-paths)))
        ; Set the host part of the Message-ID to the email address host.
        (setq message-user-fqdn ${elispFromHost})
        (when path
          (setq message-sendmail-extra-arguments '("send" "--quiet" "-t" "-C" path)))))
  '';

  # Advice the notmuch-draft-save function to save if the correct
  # draft folder and with the correct FQDN in Message-ID.
  notmuchDraftSaveAdviceFunction = let
    mkAddressEntry = maildir: folders: address: ''
      ((string-equal from "${address}") "${maildir.path}/${folders.drafts}")
    '';

    mkAccountEntries = account:
      concatMapStrings (mkAddressEntry account.maildir account.folders)
      ([ account.address ] ++ account.aliases);
  in ''
    (defun hm--notmuch-draft-folder (from)
      (cond ${concatMapStrings mkAccountEntries notmuchAccounts}))
    (defun hm--notmuch-draft-save (orig-fun &rest args)
      (let* ((from ${elispFromAddress})
             (notmuch-draft-folder (hm--notmuch-draft-folder from))
             (message-user-fqdn ${elispFromHost}))
        (apply orig-fun args)))
  '';

in {
  accounts.email = {
    maildirBasePath = "mail";

    accounts."tadfisher@gmail.com" = {
      address = "tadfisher@gmail.com";
      flavor = "gmail.com";
      gpg = {
        key = "tadfisher@gmail.com";
        signByDefault = true;
      };
      msmtp.enable = true;
      notmuch.enable = true;
      passwordCommand = "${pass.command} show mail.google.com/tadfisher@gmail.com";
      realName = "Tad Fisher";
      userName = "tadfisher@gmail.com";
    };
  };

  programs.notmuch = {
    enable = true;
    new = {
      ignore = [ ".*\.json" ];
    };
  };

  programs.emacs.init.usePackage = {
    message = {
      enable = true;
      package = "";
      defer = true;
      hook = [ "(message-send . hm--message-send)" ];
      config = ''
        ${messageSendHookFunction}

        (setq message-directory "${cfgEmail.maildirBasePath}")
      '';
    };

    notmuch = {
      after = [ "message" ];
      config = ''
       ;; See https://github.com/Schnouki/dotfiles/blob/0d6716a041e1db95a27fc393baa8f38b850c5a25/emacs/init-50-mail.el#L243
       ${notmuchDraftSaveAdviceFunction}
       (advice-add 'notmuch-draft-save :around #'hm--notmuch-draft-save)

       ;; gmi send automatially persists sent messages
       (setq notmuch-fcc-dirs nil
             notmuch-always-prompt-for-sender ${notmuchPromptFrom})
      '';
    };

    sendmail = {
      enable = true;
      package = ""; # built-in
      defer = true;
      config = ''
        (setq send-mail-function #'sendmail-send-it
              sendmail-program "${pkgs.gmailieer}/bin/gmi")
      '';
    };
  };
}
