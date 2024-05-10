{
  description = "";
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixpkgs-unstable;
  };

  outputs = { self, nixpkgs }@inputs: {

    devShells.aarch64-darwin.default = let
      system = "aarch64-darwin";
      pkgs = import nixpkgs {
        inherit system;
      };
    in pkgs.mkShell {
      buildInputs = [
        pkgs.bash
        pkgs.ruby
        pkgs.bundler
      ];
    };

  };
}
