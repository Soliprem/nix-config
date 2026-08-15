{pkgs, ...}: {
  files = {
    ".config/isyncrc".text = ''
      IMAPAccount unibo
      Host outlook.office365.com
      Port 993
      User francesco.solidoro@studio.unibo.it
      PassCmd "oama access francesco.solidoro@studio.unibo.it"
      AuthMechs XOAUTH2
      TLSType IMAPS
      CertificateFile /etc/ssl/certs/ca-certificates.crt

      IMAPStore unibo-remote
      Account unibo

      MaildirStore unibo-local
      SubFolders Verbatim
      Path ~/.local/share/mail/unibo/
      Inbox ~/.local/share/mail/unibo/INBOX

      Channel unibo
      Far :unibo-remote:
      Near :unibo-local:
      Patterns INBOX Archive Archives "Archives/*" "Deleted Items" Drafts Junk "Junk Email" Sent "Sent Items" Trash
      Create Both
      Expunge Both
      Sync All
      SyncState *

      IMAPAccount gmail
      Host imap.gmail.com
      Port 993
      User franci.solidoro@gmail.com
      PassCmd "oama access franci.solidoro@gmail.com"
      AuthMechs XOAUTH2
      TLSType IMAPS
      CertificateFile /etc/ssl/certs/ca-certificates.crt

      IMAPStore gmail-remote
      Account gmail

      MaildirStore gmail-local
      SubFolders Verbatim
      Path ~/.local/share/mail/gmail/
      Inbox ~/.local/share/mail/gmail/INBOX

      Channel gmail
      Far :gmail-remote:
      Near :gmail-local:
      Patterns *
      Create Both
      Expunge Both
      Sync All
      SyncState *
    '';

    ".config/msmtp/config".text = ''
      defaults
      auth xoauth2
      tls on
      tls_trust_file /etc/ssl/certs/ca-certificates.crt

      account unibo
      host smtp.office365.com
      port 587
      tls_starttls on
      from francesco.solidoro@studio.unibo.it
      user francesco.solidoro@studio.unibo.it
      passwordeval oama access francesco.solidoro@studio.unibo.it

      account gmail
      host smtp.gmail.com
      port 465
      tls_starttls off
      from franci.solidoro@gmail.com
      user franci.solidoro@gmail.com
      passwordeval oama access franci.solidoro@gmail.com

      account default : unibo
    '';

    ".config/oama/config.yaml".text = ''
      encryption:
        tag: GPG
        contents: 5B5C1ABDC222B3AAFDCF04F60CD53BE47CE39A04

      services:
        google:
          # Public credentials for Thunderbird's installed desktop OAuth app.
          client_id: 406964657835-aq8lmia8j95dhl1a2bvharmfk3t1hgqj.apps.googleusercontent.com
          client_secret: kSmqreRr0qwBWJgbf5Y-PjSU

        microsoft:
          # Public client ID for Thunderbird's installed desktop OAuth app.
          client_id: 9e5f94bc-e8a4-4e73-b8be-63364c29d753
          tenant: e99647dc-1b08-454a-bf8c-699181b389ab
          # Unibo Conditional Access blocks device-code authorization.
          auth_endpoint: https://login.microsoftonline.com/e99647dc-1b08-454a-bf8c-699181b389ab/oauth2/v2.0/authorize
    '';

    ".local/share/gnupg/gpg-agent.conf".text = ''
      pinentry-program ${pkgs.pinentry-qt}/bin/pinentry
      default-cache-ttl 3600
      max-cache-ttl 28800
    '';
  };
}
