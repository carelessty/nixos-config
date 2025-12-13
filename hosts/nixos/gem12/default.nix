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

  # Nvidia Configuration
  services.xserver.videoDrivers = [ "nvidia" ];
  
  hardware.graphics.enable = true;
  
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false; # GTX 1080Ti needs proprietary
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Networking
  networking.hostName = "gem12";
  networking.networkmanager.enable = true;

  # User
  users.users.${user} = {
    isNormalUser = true;
    description = "tt";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh;
  };

  # Basic Niri session
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "${user}";
  
  # Allow unfree packages (needed for Nvidia)
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "24.05"; 
}
