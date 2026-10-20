{
  description = "My everyday fonts, packaged as a Nix flake";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      inherit (nixpkgs) lib;

      discoverPackages = import ./lib/discover-packages.nix;

      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      pkgsFor =
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

      packagesFor =
        pkgs:
        let
          packages = discoverPackages {
            inherit pkgs;
            dir = ./nix;
          };
        in
        packages
        // {
          default = pkgs.buildEnv {
            name = "fonts";
            paths = builtins.attrValues packages;
          };
        };
    in
    {
      packages = lib.genAttrs systems (system: packagesFor (pkgsFor system));

      lib = {
        inherit discoverPackages;
      };
    };
}
