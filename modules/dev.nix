{
  lib,
  pkgs,
  ...
}:
{
  programs.git = {
    enable = true;
    lfs.enable = true;
    config = {
      init.defaultBranch = "main";
      user.email = "asapaparo@gmail.com";
      user.name = "Asa Paparo";
    };
  };

  # tell shells over ssh that we are running a 256 bit color xterm
  programs.ssh.extraConfig = ''
    SetEnv TERM=xterm-256color
    SetEnv COLORTERM=truecolor
  '';

  virtualisation.containers = {
    enable = true;
    # ociSeccompBpfHook.enable = true;

    # tell shells inside containers that we are running a 256 bit color xterm
    containersConf.settings = {
      TERM = "xterm-256color";
      COLORTERM = "truecolor";
    };
  };

  # docker used instead of podman because podman is currently incompatible
  # with systemd-homed https://github.com/containers/podman/issues/20040#issuecomment-1731335711
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
    autoPrune.enable = true;
  };

  # virtualisation.podman = {
  #   enable = true;
  #   dockerCompat = true;
  #   dockerSocket.enable = true;
  # };

  programs.direnv.enable = true;

  # services.ollama = {
  #   enable = true;
  #   # radeon 780M igpu = gfx1103
  #   # gfx1100 is closest working target
  #   rocmOverrideGfx = "11.0.0";
  #   acceleration = "rocm";
  #   # loadModels = [
  #   #   "gemma3n:latest"
  #   # ];
  # };
}
