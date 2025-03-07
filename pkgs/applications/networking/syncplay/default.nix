{ lib
, stdenv
, fetchFromGitHub
, buildPythonApplication
, pyside6
, twisted
, certifi
, qt6
, appnope
, enableGUI ? true
}:

buildPythonApplication rec {
  pname = "syncplay";
  version = "1.7.0";

  format = "other";

  src = fetchFromGitHub {
    owner = "Syncplay";
    repo = "syncplay";
    rev = "v${version}";
    sha256 = "sha256-Te81yOv3D6M6aMfC5XrM6/I6BlMdlY1yRk1RRJa9Mxg=";
  };

  buildInputs = lib.optionals enableGUI [ (if stdenv.isLinux then qt6.qtwayland else qt6.qtbase) ];
  propagatedBuildInputs = [ twisted certifi ]
    ++ twisted.optional-dependencies.tls
    ++ lib.optional enableGUI pyside6
    ++ lib.optional (stdenv.isDarwin && enableGUI) appnope;
  nativeBuildInputs = lib.optionals enableGUI [ qt6.wrapQtAppsHook ];

  makeFlags = [ "DESTDIR=" "PREFIX=$(out)" ];

  postFixup = lib.optionalString enableGUI ''
    wrapQtApp $out/bin/syncplay
  '';

  meta = with lib; {
    homepage = "https://syncplay.pl/";
    description = "Free software that synchronises media players";
    license = licenses.asl20;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ Enzime ];
  };
}
