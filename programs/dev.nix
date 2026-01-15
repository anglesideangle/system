{
  buildEnv,
  nushell,
  helix,
  lazygit,
  yazi,
}:
buildEnv {
  name = "personal-dev-env";
  paths = [
    nushell
    helix
    lazygit
    yazi
  ];
}
