{ agenix, config, lib, pkgs, modulesPath, user, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ../../modules/shared
    ../../modules/nixos/niri.nix
    ../../modules/nixos/systemd.nix
    agenix.nixosModules.default
    # ./hardware-configuration.nix # User must generate this
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # YubiKey & Security
  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # VMware Guest
  virtualisation.vmware.guest.enable = true;
  
  # Networking
  networking.hostName = "vm";
  networking.networkmanager.enable = true;

  # User
  users.users.${user} = {
    isNormalUser = true;
    description = "tt";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh;
  };

  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "${user}";
  
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "24.05";
}
