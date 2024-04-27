{
  description = "game-of-life";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = { self, nixpkgs, flake-utils, rust-overlay, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
        buildInputs = with pkgs; [
          openssl.dev
          pkg-config
          zlib.dev
        ] ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
          libiconv
          CoreServices
          SystemConfiguration
        ]);
      in
      rec {
        packages.actix-web-example = pkgs.stdenv.mkDerivation {
          pname = "game-of-life";
          version = "0.1.0";
          src = ./.;

          buildInputs = buildInputs ++ (with pkgs; [
            (rust-bin.stable."1.76.0".default.override {
              extensions = [ "rust-src" ];
              targets = [ "wasm32-unknown-unknown" ];
            })
            wasm-pack
          ]);

          nativeBuildInputs = with pkgs; [ pkg-config ];

          buildPhase = ''
            wasm-pack build --target web
          '';

          installPhase = ''
            mkdir -p $out/bin
            cp -r pkg $out/bin
          '';
        };

        defaultPackage = packages.actix-web-example;

        devShell = pkgs.mkShell {
          inherit buildInputs;
          nativeBuildInputs = with pkgs; [
            cargo-edit
            cargo-generate
            (rust-bin.stable."1.76.0".default.override {
              extensions = [ "rust-src" ];
              targets = [ "wasm32-unknown-unknown" ];
            })
            rust-analyzer
            sccache
            pkg-config
            wasm-pack
          ];
          RUST_BACKTRACE = 1;
        };
      }
    );
}

