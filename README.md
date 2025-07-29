# hauntedcupof.dotfiles

> <small>(thanks for the name, [SyedAhkam](https://github.com/SyedAhkam))</small>

A repository containing nixOS configurations for all my funny little devices. Perpetual WIP, ofcourse, because the rice is never cooked enough :).

## Running it for yourself

Since I'm creating a flake, running this setup would be as simple as cloning, copying over your host configuration to a new folder and rebuilding flake with that host. (will update this with more clear instructions later).

PLEASE NOTE that it is NOT RECOMMENDED to use this if you don't know what you are doing. I will improve things over time, and at a certain point it will be more user-friendly. The ultimate goal here is to make a setup that anyone can use.

> [!WARNING]
> If you're running this for the first time and your linux kernel is not set to `latest`, it is recommended to use `sudo nixos-rebuild boot --flake .#HOST` instead of the `switch` command. Changing the kernel always requires a reboot to activate successfully so switch will fail with an error. Everything else will be updated, and a simple restart will update the kernel as well, but if you dislike errors like me it's recommended.

## Conventions I'm following

- Home Manager imports /[user].nix instead of home.nix (to make multi-user management easier).
- Even though the organization of this repo might be a bit unconventional compared to standard, I aimed for a "buffet" approach with my configuration which should make it easy to simply pick and choose what you require by commenting/uncommenting stuff in the various `default.nix` files scattered around.

## Wallpaper Credits

- Fern: [nest_virgo](https://www.instagram.com/p/C0Sh_5gP-xu/)
- Malenia: [Espen Olsen Saetervik](https://x.com/VideoArtGame/status/1698002847575769189)
  -# This is the only source I could find that credits this image, I cannot find the artist, if you know who they are, please tell me so i can credit them.

## Special Thanks

- [Vimjoyer](https://www.youtube.com/@vimjoyer) for making the switch from windows + wsl to NixOS easier for a wretch like me =D
- [fazzi](https://gitlab.com/fazzi/nixohess) for providing an extremely cool way of organizing a flake that i will slowly inch towards + wleave configuration and icons
- [soramane](https://github.com/caelestia-dots/shell) for inspiring quickshell layout + some of the functionalities
- [Rexiel](https://github.com/Rexcrazy804) for pointing out factual errors in the warning above
- All the flake providers and home manager contributors. We stand on the shoulders of giants, so we may one day see the sun for ourselves
