{ lib
, stdenv
, fetchFromGitHub
, mkDerivation
, pkg-config
, cmake
, extra-cmake-modules
, callPackage
, qtbase
, qtkeychain
, wrapQtAppsHook
, qttools
, sqlite
, libsecret
}:

stdenv.mkDerivation rec {
  pname = "owncloud-client";
  version = "4.0.0";

  libregraph = callPackage ./libre-graph-api-cpp-qt-client.nix { };

  src = fetchFromGitHub {
    owner = "owncloud";
    repo = "client";
    rev = "refs/tags/v${version}";
    hash = "sha256-KZ/e8ISQ4FNgT/mtKSlOCa3WQ0lRSaqNIhQn6al6NSM=";
  };

  nativeBuildInputs = [ pkg-config cmake extra-cmake-modules wrapQtAppsHook qttools ];
  buildInputs = [ qtbase qtkeychain sqlite libsecret libregraph ];

  cmakeFlags = [
    "-UCMAKE_INSTALL_LIBDIR"
    "-DNO_SHIBBOLETH=1"
  ];

  meta = with lib; {
    description = "Synchronise your ownCloud with your computer using this desktop client";
    homepage = "https://owncloud.org";
    maintainers = with maintainers; [ qknight hellwolf ];
    platforms = platforms.unix;
    license = licenses.gpl2Plus;
    changelog = "https://github.com/owncloud/client/releases/tag/v${version}";
  };
}
