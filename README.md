# NixOS Configurations

This repository contains my personal NixOS configurations, including setups for various tools and applications such as Neovim and Waybar.

## Usage

Follow these steps to clone the repository and apply the NixOS configurations:

### Step 1: Clone the Repository

First, clone this repository to your local machine:

```sh
git clone https://github.com/Takamatsu-Naoki/nixos.git
cd nixos
```

### Step 2: Apply NixOS Configurations

Use the following command to apply the NixOS configurations:

```sh
sudo nixos-rebuild switch --flake .
```

This command tells Nix to rebuild the system using the configuration defined in the current directory (.) as a flake.

## Customization
You can customize the configurations by editing the respective files:

Edit `configuration.nix` for system-wide configurations.
Edit `home.nix` for user-specific configurations managed by Home Manager.
Edit files in `neovim/` and `waybar/` directories for specific tool configurations.
