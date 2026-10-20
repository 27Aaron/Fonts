{
  description = "My everyday fonts, packaged as a Nix flake";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { nixpkgs, ... }:
    let
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
          dank-mono = pkgs.callPackage ./nix/dank-mono.nix { };
          monolisa = pkgs.callPackage ./nix/monolisa.nix { };
          pingfang = pkgs.callPackage ./nix/pingfang.nix { };
          zpix = pkgs.callPackage ./nix/zpix.nix { };
        in
        {
          inherit dank-mono monolisa pingfang zpix;

          default = pkgs.buildEnv {
            name = "fonts";
            paths = [
              dank-mono
              monolisa
              pingfang
              zpix
            ];
          };
        };
    in
    {
      packages = nixpkgs.lib.genAttrs systems (system: packagesFor (pkgsFor system));
    };
}
