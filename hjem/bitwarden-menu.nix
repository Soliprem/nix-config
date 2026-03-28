_: {
  files = {
    ".config/bwm/config.ini".text = ''
      [dmenu]
      dmenu_command=fuzzel --dmenu

      [dmenu_passphrase]
      obscure=True
      obscure_color=#222222

      [vault]
      server_1=vw.soliprem.eu
      email_1=accounts@soliprem.eu
      password_cmd_1=cat /run/agenix/bitwarden_password
      twofactor_1=0
      session_timeout_min=360
      autotype_default={USERNAME}{TAB}{PASSWORD}{ENTER}
    '';
  };
}
