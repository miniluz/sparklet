{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-compat = {
      url = "git+https://git.lix.systems/lix-project/flake-compat?rev=382052b74656a369c5408822af3f2501e9b1af81";
      flake = false;
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    typst-wrapper = {
      url = "github:miniluz/typst-wrapper";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    {
      nixpkgs,
      rust-overlay,
      typst-wrapper,
      ...
    }:
    let
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      devShells = forAllSystems (
        system:
        let
          overlays = [ (import rust-overlay) ];
          pkgs = import nixpkgs { inherit system overlays; };

          typst = typst-wrapper.lib.${pkgs.stdenv.hostPlatform.system}.wrapTypst { };

          rust = pkgs.rust-bin.fromRustupToolchainFile ./rust-toolchain.toml;

          ciPackages = with pkgs; [
            rust
            just
            prek
            typstyle
            cspell
            cargo-nextest
            mdbook
          ];

          userPackages = with pkgs; [
            rust
            cargo-binutils
            usbutils
            probe-rs-tools
            dfu-util
          ];
        in
        rec {
          default = development;

          ci = pkgs.mkShell {
            nativeBuildInputs = ciPackages;
            buildInputs = [ ];
          };

          user = pkgs.mkShell {
            nativeBuildInputs = userPackages;
            buildInputs = [ ];
          };

          development = pkgs.mkShell {
            allowSubstitutes = false;

            nativeBuildInputs =
              ciPackages
              ++ userPackages
              ++ (with pkgs; [
                cargo-expand
                cargo-bloat
                bacon

                (octave.withPackages (octavePackages: with octavePackages; [ signal ]))

                lldb

                typst
                drawio
                entr
                (python3.withPackages (
                  pythonPackages: with pythonPackages; [
                    numpy
                    matplotlib
                  ]
                ))

                vmpk
                qpwgraph
              ]);
            buildInputs = [ ];
          };
        }
      );
    };
}
