{
  fetchFromGitea,
  gmp,
  iptables,
  jansson,
  lib,
  libmnl,
  libnftnl,
  nftables,
  pkg-config,
  rustPlatform,
  stdenv,
}:
rustPlatform.buildRustPackage rec {
  pname = "iocaine";
  version = "3.5.0";

  src = fetchFromGitea {
    domain = "git.madhouse-project.org";
    owner = "iocaine";
    repo = "iocaine";
    tag = "iocaine-${version}";
    hash = "sha256-adsQuSL4F1mfSsUtLwdgUtHVYessBM31tlBU8Rbbst4=";
  };

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
    allowBuiltinFetchGit = true;
  };

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    pkg-config
  ];

  buildInputs = [
    gmp
    iptables
    jansson
    libmnl
    libnftnl
    nftables
  ];

  checkPhase = ''
    runHook preCheck
    runHook cargoCheckHook
    TESTER_BIN="target/${stdenv.hostPlatform.rust.rustcTargetSpec}/$cargoCheckType/iocaine" \
      bash tests/test_request_handler.sh
    RUST_LOG=iocaine=error \
      target/${stdenv.hostPlatform.rust.rustcTargetSpec}/$cargoCheckType/iocaine \
      -c iocaine-powder/embeds/defaults/testsuite.kdl test suite
    runHook postCheck
  '';

  meta = {
    description = "The deadliest poison known to AI";
    homepage = "https://iocaine.madhouse-project.org/";
    license = lib.licenses.mit;
    mainProgram = "iocaine";
    platforms = lib.platforms.linux;
  };
}
