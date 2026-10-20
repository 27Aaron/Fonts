{
  description = "My everyday fonts, packaged as a Nix flake";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      inherit (nixpkgs) lib;

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
          packageEntries = lib.filterAttrs (
            name: type:
            !(lib.hasPrefix "_" name)
            && name != "default.nix"
            && (
              (type == "regular" && lib.hasSuffix ".nix" name)
              || (type == "directory" && builtins.pathExists (./nix + "/${name}/default.nix"))
            )
          ) (builtins.readDir ./nix);

          packages = lib.listToAttrs (
            map (
              name:
              let
                entryType = packageEntries.${name};
                packageName = if entryType == "directory" then name else lib.removeSuffix ".nix" name;
              in
              {
                name = packageName;
                value = pkgs.callPackage (./nix + "/${name}") { };
              }
            ) (builtins.attrNames packageEntries)
          );
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
    };
}
