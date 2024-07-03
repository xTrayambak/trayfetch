{
  description = "a lightweight and customizable system fetch for POSIX compliant systems";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixpkgs-unstable;
  };

  outputs = { self, nixpkgs }:
    with nixpkgs.lib;
    let
      forAllSystems = fn:
        genAttrs platforms.unix (system:
          fn (import nixpkgs {
            inherit system;
          })
        );
    in
      {
        packages = forAllSystems (pkgs: {
          default = pkgs.buildNimPackage rec {
            name = "trayfetch";
            src = ./.;

            lockFile = ./package.lock;

            nativeBuildInputs = with pkgs; [
              makeBinaryWrapper
              nimble
            ];

            buildInputs = [];

            LD_LIBRARY_PATH = with pkgs; lib.makeLibraryPath [
              libGL
            ];

            wrapTrayfetch =
              let
                makeWrapperArgs = ''
                  --prefix LD_LIBRARY_PATH : ${LD_LIBRARY_PATH}
                '';
              in
              ''
                wrapProgram "$(pwd)"/trayfetch ${makeWrapperArgs}
              '';

            postInstall = ''
              cd $out/bin/
              ${wrapTrayfetch}
            '';

            shellHook = ''
              build-trayfetch () {
                nimble build $@
                ${wrapTrayfetch}
              }
            '';
          };
        });
      };
}
