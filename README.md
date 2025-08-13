# System

This repository contains my personal nixos config and package exports. I try to keep everything as straightforward as possible, avoiding unnecessary indirection and dependencies, including home manager, stylix, and wrapper manager.

## Cool Stuff

[wrap.nix](./utils/wrap.nix) provides a wrapper function to wrap arbitrary packages with flags and environment variables. This allows for the configuring of packages in `./programs`.

## Copying

Feel free to use any part of this config for any purpose. I would appreciate being cited if anything is particularly useful.

## Eventual Goals

- [ ] actual sandboxing with bwrap/nixpak, maybe limit systemd permissions for apps launched by fuzzel
- [ ] wifi/power menus with fuzzel, maybe nushell
