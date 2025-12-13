{ agenix, config, pkgs, user, ... }:

{
  imports = [
    # ../../modules/darwin/secrets.nix # Disabled as secrets are removed
    ../../modules/darwin/home-manager.nix
    ../../modules/shared
    agenix.darwinModules.default
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  networking.hostName = "mbp21";

  # Setup user, packages, programs
  nix = {
    enable = false; # Managed by nix-installer usually on Darwin, or enable if using nix-darwin to manage nix
    package = pkgs.nix;
    settings = {
      trusted-users = [ "@admin" "${user}" ];
      substituters = [ "https://nix-community.cachix.org" "https://cache.nixos.org" ];
      trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
    };
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Load configuration that is shared across systems
  environment.systemPackages = with pkgs; [
    # agenix.packages."${pkgs.system}".default
  ] ++ (import ../../modules/shared/packages.nix { inherit pkgs; });

  system = {
    checks.verifyNixPath = false;
    # primaryUser = user; # Deprecated in newer nix-darwin? Check if valid. It was in the old config.
    stateVersion = 4;
    defaults = {
      LaunchServices = {
        LSQuarantine = false;
      };
      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        ApplePressAndHoldEnabled = false;
        KeyRepeat = 2;
        InitialKeyRepeat = 15;
        "com.apple.mouse.tapBehavior" = 1;
      };
      dock = {
        autohide = false;
        show-recents = false;
        tilesize = 48;
      };
    };
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };
  };
  
  users.users.${user}.home = "/Users/${user}";
}
