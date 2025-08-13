/**
  Wraps a package with flags and env vars.

  The wrapper derivation has each specified binary in the original package replaced by a wrapper with the specified flags and environment variables.
  Every other file from the original derivation is symlinked to by the new derivation, except any file referencing the original $pkg will be cloned and have that reference replaced by the wrapper derivation's $out.

  # Example

  ```nix
  mkWrapper = import ./wrap.nix;
  editor = mkWrapper pkgs {
    pkg = pkgs.helix;
    hx = {
      env.idk = "hi";
      prependFlags = [
        "--config"
        "./helix.toml"
      ];
    };
  };
  ```

  # Type

  ```
  mkWrapper :: Pkgs -> {
    pkg : Derivation,
    pname? : String,
    additionalDependencies? : [Derivation],
    <bin> : {
      env? : AttrSet String,
      prependFlags? : [String]
      appendFlags? : [String]
    }
  } -> Derivation
  ```

  # Arguments

  pkgs
  : An instance of nixpkgs

  pkg
  : The derivation to wrap

  pname
  : An optional name for the wrapped package, defaults to `pkg.name`

  additionalDependencies
  : An optional list of additional derivations to include in the wrapped environment

  <bin>
  : Variadic number of attrsets in the form bin = { env?, flags? }, where `bin` is the name of the binary that `pkg` outputs that you want to wrap. `env` and `flags` are detailed below.

  env
  : An optional attrset specifying environment variables to set inside the wrapped environment, defaults to `{}`

  prependFlags
  : An optional list specifying flags to append to the wrapped binary, defaults to `[]`. These flags go before your arguments, in the form `bin --prepended $@`.

  appendFlags
  : An optional list specifying flags to append to the wrapped binary, defaults to `[]` These flags go after your arguments, in the form `bin $@ --appended`.
*/
pkgs:
let
  wrap =
    {
      pkg,
      pname ? pkg.pname,
      version ? pkg.version,
      additionalDependencies ? [ ],
      ...
    }@args:

    let
      lib = pkgs.lib;
    in

    assert lib.isDerivation pkg || throw "'pkg' must be a derivation (e.g. pkgs.hello)";
    assert lib.isString pname || throw "'name' must be a string";

    let
      # all keyword kwargs are bins
      binaries = builtins.removeAttrs args [
        "pkg"
        "pname"
        "version"
        "additionalDependencies"
      ];

      wrapCommands = lib.mapAttrsToList (
        bin:
        {
          prependFlags ? [ ],
          appendFlags ? [ ],
          env ? { },
        }:
        assert
          (lib.isList prependFlags && lib.all lib.isString prependFlags)
          || throw "'${bin}.addFlags' must be a list of strings";
        assert
          (lib.isList appendFlags && lib.all lib.isString appendFlags)
          || throw "'${bin}.addFlags' must be a list of strings";
        assert
          (lib.isAttrs env && lib.all lib.isString (lib.attrValues env))
          || throw "'${bin}.env' must be an attribute set of strings";
        let
          envArgs = lib.concatStringsSep " " (lib.mapAttrsToList (k: v: "--set '${k}' '${v}'") env);
        in
        ''
          wrapProgram $out/bin/${bin} \
            --add-flags "${builtins.toString prependFlags}" \
            --append-flags "${builtins.toString appendFlags}" \
            ${envArgs}
        ''
      ) binaries;

      # nasty script to replace all text references to ${pkg} with ${out}
      # this is necessary because some files that get symlinked into the new
      # package directory ($out) will still reference ${pkg}, leading to
      # unexpected behavior
      fixReferences = ''
        # iterate through every file/symlink in $out
        find "$out" \( -type l -o -type f \) | while read -r item; do
          # if item is a symlink, we want to (recursively) find the file it
          # points to, read it, and if it contains $pkg, overwrite the symlink
          # with a regular file to replace $pkg with $out
          if [ -L "$item" ]; then
            # redirection is to ignore broken symlinks
            target=$(readlink -f "$item" 2>/dev/null || true)

            # if our target is a nonempty file containing pkg, replace item with target
            if [ -n "$target" ] && [ -f "$target" ] && grep -F -q "${pkg}" "$target"; then
              rm "$item"
              cp "$target" "$item"
            # otherwise, skip the file replacement code
            else
              continue
            fi
          fi

          # $item is guaranteed to be a regular file
          if grep -F -q "${pkg}" "$item"; then
            # ensure $item is writeable
            [ -w "$item" ] || chmod +w "$item"
            # replace all occurances of $pkg with $out
            sed -i "s|${pkg}|$out|g" "$item" || true
          fi
        done
      '';
    in
    pkgs.symlinkJoin {
      inherit pname;
      inherit version;
      passthru = (pkg.passthru or { }) // {
        unwrapped = pkg;

        override =
          overrideArgs:
          let
            newPkg = pkg.override overrideArgs;
            newArgs = args // {
              pkg = newPkg;
            };
          in
          wrap newArgs;

        overrideAttrs =
          f:
          let
            newPkg = pkg.overrideAttrs f;
            newArgs = args // {
              pkg = newPkg;
            };
          in
          wrap newArgs;
      };
      meta = pkg.meta or { };
      paths = [ pkg ];
      buildInputs = [ pkgs.makeWrapper ] ++ additionalDependencies;
      postBuild = lib.concatStringsSep "\n" (wrapCommands ++ [ fixReferences ]);
    };
in
wrap
