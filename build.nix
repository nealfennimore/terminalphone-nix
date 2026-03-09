{
  pkgs ? import <nixpkgs> { },
}:
let
  buildInputs = with pkgs; [
    alsa-utils
    openssl
    opusTools
    qrencode
    snowflake
    socat
    sox
    tor
  ];
in
pkgs.stdenv.mkDerivation {
  pname = "terminalphone";
  version = "1.1.5.1";
  src = pkgs.fetchFromGitLab {
    owner = "here_forawhile";
    repo = "terminalphone";
    rev = "eb98d1fbc7acddeab3464282e9a4b9610ff28445";
    sha256 = "sha256-jrG1oSKk1Pjeffd7JCBJbL7STSWYStmawwTlEuuOB38=";
  };
  inherit buildInputs;
  nativeBuildInputs = [ pkgs.makeWrapper ];
  patches = [
    # Nix store is readonly, so allow for .terminalphone to load from $HOME dir
    ./patches/home-dir.patch
  ];
  installPhase = ''
    mkdir -p $out/{bin,lib}

    # Snowflake is `client` instead of `snowflake-client`
    ln -s ${pkgs.snowflake}/bin/client $out/lib/snowflake-client

    chmod u+x terminalphone.sh
    cp terminalphone.sh $out/bin/terminalphone.sh

    wrapProgram $out/bin/terminalphone.sh \
      --prefix PATH : ${pkgs.lib.makeBinPath buildInputs} \
      --prefix PATH : $out/lib
  '';
}
