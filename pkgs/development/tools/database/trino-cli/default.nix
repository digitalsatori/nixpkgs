{ lib, stdenv, fetchurl, jre, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "trino-cli";
  version = "387";

  jarfilename = "${pname}-${version}-executable.jar";

  nativeBuildInputs = [ makeWrapper ];

  src = fetchurl {
    url = "mirror://maven/io/trino/${pname}/${version}/${jarfilename}";
    sha256 = "sha256-26TYtfxKLP3dW2uOoxc6rRnGXxnmbKG99xR0X7ntXDY=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -D "$src" "$out/share/java/${jarfilename}"

    makeWrapper ${jre}/bin/java $out/bin/trino \
      --add-flags "-jar $out/share/java/${jarfilename}"

    runHook postInstall
  '';

  meta = with lib; {
    description = "The Trino CLI provides a terminal-based, interactive shell for running queries";
    homepage = "https://github.com/trinodb/trino";
    license = licenses.asl20;
    maintainers = [ maintainers.regadas ];
  };
}
