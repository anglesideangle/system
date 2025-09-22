{ lib, pkgs, packages, ... }:
# let container-env = pkgs.buildFHSEnv {
#   name = "container-env";
#   targetPkgs = pkgs: [
#     pkgs.helix
#   ];
#   # paths = [ packages.helix-wrapped ];
#   # includeClosures = true;
#   # ignoreCollisions = true;
#   # pathsToLink = " /bin "
# };
# in
{
  programs.git = {
    enable = true;
    config = {
      init.defaultBranch = "main";
      user.email = "asapaparo@gmail.com";
      user.name = "Asa Paparo";
    };
  };

  # programs.ssh.startAgent = true;
  programs.ssh.extraConfig = "SetEnv TERM=xterm-256color";

  virtualisation.containers = {
    enable = true;

    # containersConf.settings = {
    #   containers = {
    #     volumes = [ "/nix/store:/nix/store:ro" ];
    #     env = [ "PATH=${lib.getBin container-env}:$\PATH" ];
    #   };
    # };
  };

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    dockerSocket.enable = true;
  };

  # Enable direnv
  programs.direnv.enable = true;

  # Configure helix for editor and viewing functionality
  environment.variables = {
    EDITOR = "${lib.getExe packages.helix-wrapped}";
    VISUAL = "${lib.getExe packages.helix-wrapped}";
  };

  # Set up local llms
  services.ollama = {
    enable = true;
    # radeon 780M igpu = gfx1103
    # gfx1100 is closest working target
    rocmOverrideGfx = "11.0.0";
    acceleration = "rocm";
    # loadModels = [
    #   "gemma3n:latest"
    # ];
  };
}
