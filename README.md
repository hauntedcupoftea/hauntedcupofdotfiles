# hauntedcupof.dotfiles
> <small>(thanks for the name, syed)</small>

A repository containing nixOS configurations for all my funny little devices. Perpetual WIP, ofcourse, because the rice is never cooked enough :).

## Running it for yourself

Since I'm creating a flake, running this setup would be as simple as cloning, copying over your host configuration to a new folder and rebuilding flake with that host. (will update this with more clear instructions later).

current convention's I'm following:
- Home Manager imports \[user].nix instead of home.nix (to make multi-user management easier).
