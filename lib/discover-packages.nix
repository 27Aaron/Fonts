# Build an attrset of packages from `dir`. Both `<name>.nix` files and
# `<name>/default.nix` directories are supported.
{
  pkgs,
  dir,
}:
let
  inherit (pkgs) lib;

  packageEntries = lib.filterAttrs (
    name: type:
    !(lib.hasPrefix "_" name)
    && name != "default.nix"
    && (
      (type == "regular" && lib.hasSuffix ".nix" name)
      || (type == "directory" && builtins.pathExists (dir + "/${name}/default.nix"))
    )
  ) (builtins.readDir dir);

  packages = lib.listToAttrs (
    map (
      name:
      let
        entryType = packageEntries.${name};
        packageName = if entryType == "directory" then name else lib.removeSuffix ".nix" name;
      in
      {
        name = packageName;
        value = pkgs.callPackage (dir + "/${name}") { };
      }
    ) (builtins.attrNames packageEntries)
  );
in
packages
