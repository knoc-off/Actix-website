{
  description = "actix-webserver";

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
        rustPlatform = pkgs.makeRustPlatform {
          cargo = pkgs.rust-bin.stable."1.76.0".default;
          rustc = pkgs.rust-bin.stable."1.76.0".default;
        };
        buildInputs = with pkgs; [
          openssl.dev
          pkg-config
          zlib.dev
          alsa-lib
          udev
        ] ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
          libiconv
          CoreServices
          SystemConfiguration
        ]);
      in
      rec {
        packages.actix-web-example = rustPlatform.buildRustPackage {
          pname = "actix-webserver";
          version = "0.1.0";
          src = ./.;
          cargoLock.lockFile = ./Cargo.lock;
          inherit buildInputs;
          nativeBuildInputs = with pkgs; [ pkg-config ];
        };

        defaultPackage = packages.actix-web-example;

        devShell = pkgs.mkShell {
          inherit buildInputs;
          nativeBuildInputs = with pkgs; [
            cargo-edit
            cargo-generate
            (rust-bin.stable."1.76.0".default.override {
              extensions = [ "rust-src" ];
            })
            rust-analyzer
            sccache
            pkg-config
          ];
          RUST_BACKTRACE = 1;
        };
      }
    );
}

