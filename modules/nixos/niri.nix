{ config, pkgs, lib, ... }:

{
  programs.niri.enable = true;

  environment.systemPackages = with pkgs; [
    niri
    waybar
    mako # notification daemon
    rofi-wayland
    swaybg # wallpaper
    xwayland
  ];

  # XDG Portal for Wayland
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
    config.common.default = "*";
  };
  
  # Optional: Keyring
  services.gnome.gnome-keyring.enable = true;
}
