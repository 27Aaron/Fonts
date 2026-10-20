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
          pingfang = pkgs.callPackage ./nix/pingfang.nix { };
        in
        {
          inherit dank-mono pingfang;

          default = pkgs.buildEnv {
            name = "fonts";
            paths = [
              dank-mono
              pingfang
            ];
          };
        };

      # One nixpkgs instantiation per system, shared by packages and formatter.
      perSystem =
        system:
        let
          pkgs = pkgsFor system;
        in
        {
          packages = packagesFor pkgs;

          # `nix fmt` with no arguments must format the whole tree, but bare
          # nixfmt-rs reads stdin instead, so wrap it in treefmt.
          formatter = pkgs.nixfmt-tree.override { nixfmtPackage = pkgs.nixfmt-rs; };
        };

      all = nixpkgs.lib.genAttrs systems perSystem;
    in
    {
      packages = nixpkgs.lib.mapAttrs (_: v: v.packages) all;

      formatter = nixpkgs.lib.mapAttrs (_: v: v.formatter) all;
    };
}
