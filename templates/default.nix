let
  entries = builtins.readDir ./.;

  names = builtins.attrNames entries;

  templateNames = builtins.filter (
    name: entries.${name} == "directory" && builtins.pathExists (./${name}/flake.nix)
  ) names;

in
builtins.listToAttrs (
  map (name: {
    name = name;
    value = {
      path = ./${name};
      description = (import ./${name}/flake.nix).description;
    };
  }) templateNames
)
