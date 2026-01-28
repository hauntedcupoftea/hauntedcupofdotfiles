# hauntedcupof.dotfiles

> <small>(thanks for the name,
> [SyedAhkam](https://github.com/SyedAhkam))</small>

A repository containing NixOS configurations for all my funny little devices.
Perpetual WIP, of course, because the rice is never cooked enough :).

## Using Custom Packages (Probably Why You're Here)

This flake exposes several custom packages that you can use in your own
configurations.

### Available Packages

#### Dungeondraft

A map making tool for Tabletop Roleplaying Games. This is a **paid
application** - you must purchase and download it yourself.

**To use:**

1. Purchase Dungeondraft from [dungeondraft.net](https://dungeondraft.net/)
2. Download the Linux `.deb` file (`Dungeondraft-1.2.0.1-Linux64.deb`)
3. Add it to your Nix store:

```bash
nix-store --add-fixed sha256 ~/Downloads/Dungeondraft-1.2.0.1-Linux64.deb
```

4. Add to your configuration:

```nix
environment.systemPackages = [
  inputs.hauntedcupofdotfiles.packages.${system}.dungeondraft
];
```

The package will fail with instructions if the file is not in your store.

#### emBridge

eMudhra's emBridge service for accessing crypto tokens (Digital Signature
Certificates) in Linux. Required for signing PDFs with Indian DSC tokens.

> [!WARNING]
> **Legal Disclaimer**: This package downloads and repackages the official
> eMudhra eMbridge software for use on NixOS.
>
> - This software is proprietary and owned by eMudhra
> - By using this package, you agree to eMudhra's
>   [end user license](https://emudhra.com/en/end-user-license)
> - This package is provided as-is with no warranty
> - The maintainers of this repository are not affiliated with eMudhra
> - Use at your own risk - ensure you have the right to use this software
> - If eMudhra requests removal of this package, it will be removed immediately
>
> For official support and licensing questions, contact
> [eMudhra](https://www.emudhra.com/)

**To use:**

1. Add to your configuration:

```nix
   # Import the module
   imports = [
     inputs.hauntedcupofdotfiles.nixosModules.embridge
   ];

   # Enable the service
   services.embridge.enable = true;
   
   # Optionally add the CLI tool
   environment.systemPackages = [
     inputs.hauntedcupofdotfiles.packages.${system}.embridge
   ];
```

2. The service will automatically start and listen on `https://127.0.0.1:26769`
3. Use with Okular or other PDF signing applications that support PKCS#11

**Note:** This package downloads the official eMudhra software and patches it
for NixOS. It requires `allowUnfree = true` in your nixpkgs config.

### Using in Your Flake

Add this repository as an input:

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hauntedcupofdotfiles.url = "github:yourusername/hauntedcupofdotfiles";
  };

  outputs = { self, nixpkgs, hauntedcupofdotfiles }: {
    nixosConfigurations.yourhost = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        # Your modules here
        ({ pkgs, ... }: {
          environment.systemPackages = [
            hauntedcupofdotfiles.packages.x86_64-linux.dungeondraft
            hauntedcupofdotfiles.packages.x86_64-linux.embridge
          ];
        })
      ];
    };
  };
}
```

## Running it for yourself

Since I'm creating a flake, running this setup would be as simple as cloning,
copying over your host configuration to a new folder and rebuilding flake with
that host. (will update this with more clear instructions later).

PLEASE NOTE that it is NOT RECOMMENDED to use this if you don't know what you
are doing. I will improve things over time, and at a certain point it will be
more user-friendly. The ultimate goal here is to make a setup that anyone can
use.

> [!WARNING]
> If you're running this for the first time and your linux kernel is not set to
> `latest`, it is recommended to use `sudo nixos-rebuild boot --flake .#HOST`
> instead of the `switch` command. Changing the kernel always requires a reboot
> to activate successfully so switch will fail with an error. Everything else
> will be updated, and a simple restart will update the kernel as well, but if
> you dislike errors like me it's recommended.

## Conventions I'm following

- Home Manager imports /[user].nix instead of home.nix (to make multi-user
  management easier).
- Even though the organization of this repo might be a bit unconventional
  compared to standard, I aimed for a "buffet" approach with my configuration.
  This should make it easy to simply pick and choose what you require by
  commenting/uncommenting stuff in the various `default.nix` files scattered
  around.

## Wallpaper Credits

- Fern: [nest_virgo](https://www.instagram.com/p/C0Sh_5gP-xu/)
- Malenia:
  [Espen Olsen Saetervik](https://x.com/VideoArtGame/status/1698002847575769189)
  -# This is the only source I could find that credits this image, I cannot find
  the artist, if you know who they are, please tell me so I can credit them.

## Special Thanks

- [Vimjoyer](https://www.youtube.com/@vimjoyer) for making the switch from
  windows + wsl to NixOS easier for a wretch like me =D
- [fazzi](https://gitlab.com/fazzi/nixohess) for providing an extremely cool way
  of organizing a flake that I will slowly inch towards + wleave configuration
  and icons
- [soramane](https://github.com/caelestia-dots/shell) for inspiring quickshell
  layout + some of the functionalities
- [Rexiel](https://github.com/Rexcrazy804) for teaching me true nixlang and
  kurukuruDM
- All the flake providers and home manager contributors. We stand on the
  shoulders of giants, so we may one day see the sun for ourselves
