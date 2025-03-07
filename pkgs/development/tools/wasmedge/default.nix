{ lib
, fetchFromGitHub
, llvmPackages
, boost
, cmake
, gtest
, spdlog
, libxml2
, libffi
, Foundation
}:

let
  stdenv = llvmPackages.stdenv;
in
stdenv.mkDerivation rec {
  pname = "wasmedge";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "WasmEdge";
    repo = "WasmEdge";
    rev = version;
    sha256 = "sha256-4xoS9d5bV9CqYhYTK1wzlA2PKMbsOote6eAeT56ch08=";
  };

  nativeBuildInputs = [
    cmake
    llvmPackages.lld
  ];

  buildInputs = [
    boost
    spdlog
    llvmPackages.llvm
    libxml2
    libffi
  ] ++ lib.optionals stdenv.isDarwin [
    Foundation
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DWASMEDGE_BUILD_TESTS=OFF" # Tests are downloaded using git
  ] ++ lib.optionals stdenv.isDarwin [
    "-DWASMEDGE_FORCE_DISABLE_LTO=ON"
  ];

  meta = with lib; {
    homepage = "https://wasmedge.org/";
    license = with licenses; [ asl20 ];
    description = "A lightweight, high-performance, and extensible WebAssembly runtime for cloud native, edge, and decentralized applications";
    maintainers = with maintainers; [ dit7ya ];
    # error: no member named 'utimensat' in the global namespace
    broken = stdenv.isDarwin && stdenv.isx86_64;
  };
}
