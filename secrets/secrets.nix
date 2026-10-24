let
  laptop = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDSc+ofSlx2xQnIBCL68uIiLihZ/nB0NBienU1pcnL7tE76HH0697Zm5uV1TtwRkSxZhNo5AUHfxRNrh+CFoSnodFhg7OZ0d46TdLl9IyptjcpF/nPvPp6OwRonCLxw7WRfwe+5q7jGQJCqxaHPUX71Ng/qkk9HZ6LqTV7/PDjXhZ1zZR+GfCWW59H/emMZgUeTwBbwMD8aqWwautlYKOwURBXRxsViVP0epZGV4tIDDFlaM4eBOpsoashsX61bHAwXGV3HqcRGFVtXhsMks2cb8EvoRxxZp0IPbkbGh2Hokt1yy3KXk1zHo2eqzjo/7vwAih5dzf6cwaDMieQlYh+6y0Cm3KTlZX6eXb/2OW8PhQ1TkmVQAhUUxFm1JaNEhX/E2DWkoyCw2wjHk+J5RrLIkaOMi6eXMgTkff33ovB0JlDVFzSyt2e+YUX8ZXh7y3xu1cP5NVlTz935wnLPrlDG58ryxcNhQb3dtU3+Wj/toIOkWyygbY1HuzMZkUTNgMMU1K31SoFfijOtbYiIAiiwxynsYmsocidcrx7I+/HdgmWLaTkUgGONGa+ETuyvIfpuMSzfRfi/mIraiYRO0sCPX0YVVY+xOAjVLb6XwEZwNbuD1w9p8UPJmlg7Q1NdCtrWKx5QLVA/FfdZWRJEm0NNgKJcn/TnQpdqr0V3lt+3LQ== root@nixos-laptop";
  pc = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCchkITtPfJ3HSTL+BvGL721ZCO+POI3EMjpV2+1ixTwrCBo24lw6xlA7FGMZlByHpJeZ9KeaFtKMQkMZpm+DFR7uI5/r6qnizOADXDnufQ8OpRYEI6HjvgoRJnnFNFGjL10P1yjj+9aQ2fLhSZVMxvIfaFWEAhjBUfKQKEomR4FkfENiwlI+c7zj5aNnWs2t/UBtuWTjAO5tOkXCc8yVWnjgnJzxCHYuwGqDBka/isobxHEFKignoB9ub5wdztzpP5aQJX/nPLddA+IJffhKBN0JYGXDYQsG5ql3uxhJOgtq1zCxZp3q7wFifx74m3RoSxNR0rPTSDRLf1z/48XTlNvYz5Azv8MwkmwO5gooEwreaxca+N4uj9kz47trWUd266iSdVGF/dserFL3qv3QNR7Od0a4no774po1sHQzqvehLym/OhzDi76w5RvxsjWBi/L/LJd7E7n7lHwcbbofVUbXXLgU8Ftkqe73B7JHdN9rPSUhB0DLqZZS3gWLSOb710y6YcsWHllPoVCtGIVJc9bPshSovVd1gdVzjT+TEIQJLp2yevPVVzISacyrHNjU/U2UxqcIz8RATB9FryUnn9ex1yCd4HZmlM5tIIiruafvN1F/bmNIujSUB5HDUUWFMK8FxZ7kZpEhZo06O13Byj4ucM7iDPLh1jzq+tAOxwRw== root@nixos";
  home = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK8Pb5g5QNxTYL4sEMEaFbzVvXNYw5zr9PBSg+6gXFcx root@nixos-home";
  server = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIiItmdrSil8mpkC73aE5jZ7Tn4+yz7SXiKvxW0XMt5y root@debian-4gb-fsn1-1";
  users = import ./user-keys.nix;
  systems = [laptop pc home];
in {
  "bitwarden_clientid.age".publicKeys = users ++ systems;
  "bitwarden_clientsecret.age".publicKeys = users ++ systems;
  "bitwarden_password.age".publicKeys = users ++ systems;
  "hermes_env.age".publicKeys = users ++ systems;
  "github_authinfo.age".publicKeys = users ++ systems;
  "gonic_authinfo.age".publicKeys = users ++ systems;
  "gomuks_authinfo.age".publicKeys = users ++ systems;
  "mail_soliprem_accounts_password.age".publicKeys = users ++ systems;
  "mail_soliprem_password.age".publicKeys = users ++ systems;
  "server_caddy_env.age".publicKeys = users ++ [server];
  "server_storage_box_credentials.age".publicKeys = users ++ [server];
  "pc_slskd_env.age".publicKeys = users ++ [pc home];
  "pc_storage_box_webdav.age".publicKeys = users ++ [pc home];
  "server_livekit_keys.age".publicKeys = users ++ [server];
  "server_continuwuity_registration_token.age".publicKeys = users ++ [server];
  "server_karakeep_env.age".publicKeys = users ++ [server];
  "server_bookorbit_env.age".publicKeys = users ++ [server];
  "server_meilisearch_master_key.age".publicKeys = users ++ [server];
  "server_mautrix_signal_env.age".publicKeys = users ++ [server];
  "server_mautrix_whatsapp_env.age".publicKeys = users ++ [server];
  "server_microbin_env.age".publicKeys = users ++ [server];
  "server_stalwart_admin_password.age".publicKeys = users ++ [server];
  "server_stalwart_dkim_private_key.age".publicKeys = users ++ [server];
  "server_calendar_credentials.age".publicKeys = users ++ [server];
  "server_filebrowser_env.age".publicKeys = users ++ [server];
}
