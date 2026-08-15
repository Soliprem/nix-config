{
  cyrus-sasl-xoauth2,
  isync,
  lib,
  makeWrapper,
  symlinkJoin,
}:
symlinkJoin {
  name = "isync-oauth-${isync.version}";
  paths = [isync];
  nativeBuildInputs = [makeWrapper];

  postBuild = ''
    wrapProgram $out/bin/mbsync \
      --set SASL_PATH ${cyrus-sasl-xoauth2}/lib/sasl2
  '';

  meta =
    isync.meta
    // {
      description = "${isync.meta.description} with XOAUTH2 authentication";
      mainProgram = "mbsync";
    };
}
