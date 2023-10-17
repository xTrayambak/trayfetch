{
	description = "A lightweight and customizable fetching program written in Nim";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
	};

	packages = eachSystem (system: {
      		default = self.packages.${system}.hyprland;
      		inherit
        	(pkgsFor.${system})
        	nim
		nimble
		;
    	});

	outputs = { self, nixpkgs }:
	
	let
         forAllSystems = function:
            nixpkgs.lib.genAttrs [
            "x86_64-linux"
            "x86_64-darwin"
            "aarch64-linux"
            ] (system:
                function (import nixpkgs {
                inherit system;
            }));
    	in
    	{
        	packages = forAllSystems (pkgs: {
            		default = pkgs.stdenv.mkDerivation {
                	name = "trayfetch";
                	src = ./.;
                	buildPhase = ''
                    	nimble release
			cp trayfetch $out/bin
                	'';
            	};
        });
    };
}
