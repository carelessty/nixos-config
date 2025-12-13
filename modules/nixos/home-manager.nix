{ config, pkgs, lib, inputs, ... }:

let
  user = "tt";
  xdg_configHome  = "/home/${user}/.config";
  shared-programs = import ../shared/home-manager.nix { inherit config pkgs lib; };
  shared-files = import ../shared/files.nix { inherit config pkgs; };
  # kde-config = import ./kde-config.nix;

  # These files are generated when secrets are decrypted at build time
  gpgKeys = [
    # "/home/${user}/.ssh/pgp_github.key"
    # "/home/${user}/.ssh/pgp_github.pub"
  ];
in
{

  home = {
    enableNixpkgsReleaseCheck = false;
    username = "${user}";
    homeDirectory = "/home/${user}";
    packages = pkgs.callPackage ./packages.nix { inherit inputs config; };
    file = shared-files // import ./files.nix { inherit user pkgs; };
    stateVersion = "25.05";
    
    # Playwright environment variables for NixOS
    sessionVariables = {
      PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
      PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";
      PLAYWRIGHT_CHROMIUM_EXECUTABLE_PATH = "${pkgs.chromium}/bin/chromium";
    };
  };

  programs = shared-programs // { 
    gpg.enable = true;
    
    rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      theme = let
        inherit (config.lib.formats.rasi) mkLiteral;
      in {
        "*" = {
          # Plasma 6 Breeze Dark color scheme
          background = mkLiteral "#1e1e2e";
          background-alt = mkLiteral "#252536";
          foreground = mkLiteral "#eff1f5";
          selected = mkLiteral "#3daee9";
          selected-foreground = mkLiteral "#1e1e2e";
          active = mkLiteral "#7aa2f7";
          urgent = mkLiteral "#f38ba8";
          border-color = mkLiteral "#31363b";
          
          border-radius = mkLiteral "6px";
          font = "Inter 11";
        };
        
        "window" = {
          transparency = "real";
          background-color = mkLiteral "@background";
          text-color = mkLiteral "@foreground";
          border = mkLiteral "1px";
          border-color = mkLiteral "@border-color";
          border-radius = mkLiteral "8px";
          width = mkLiteral "650px";
          location = mkLiteral "center";
          x-offset = 0;
          y-offset = 0;
          padding = mkLiteral "2px";
        };
        
        "mainbox" = {
          background-color = mkLiteral "@background";
          border = mkLiteral "0";
          padding = mkLiteral "0";
        };
        
        "inputbar" = {
          children = mkLiteral "[ prompt,textbox-prompt-colon,entry,case-indicator ]";
          background-color = mkLiteral "@background-alt";
          text-color = mkLiteral "@foreground";
          expand = false;
          border = mkLiteral "0px 0px 1px 0px";
          border-radius = mkLiteral "6px 6px 0px 0px";
          border-color = mkLiteral "@border-color";
          margin = mkLiteral "0px";
          padding = mkLiteral "12px";
        };
        
        "prompt" = {
          enabled = true;
          background-color = mkLiteral "@background-alt";
          text-color = mkLiteral "@selected";
        };
        
        "textbox-prompt-colon" = {
          expand = false;
          str = ":";
          background-color = mkLiteral "@background-alt";
          text-color = mkLiteral "@foreground";
        };
        
        "entry" = {
          background-color = mkLiteral "@background-alt";
          text-color = mkLiteral "@foreground";
          placeholder-color = mkLiteral "@foreground";
          expand = true;
          horizontal-align = mkLiteral "0";
          placeholder = "Search...";
          padding = mkLiteral "0px 0px 0px 8px";
          blink = true;
        };
        
        "case-indicator" = {
          background-color = mkLiteral "@background-alt";
          text-color = mkLiteral "@foreground";
          spacing = mkLiteral "0";
        };
        
        "listview" = {
          background-color = mkLiteral "@background";
          columns = 1;
          lines = 10;
          spacing = mkLiteral "8px";
          cycle = true;
          dynamic = true;
          layout = mkLiteral "vertical";
          padding = mkLiteral "8px";
        };
        
        "element" = {
          background-color = mkLiteral "@background";
          text-color = mkLiteral "@foreground";
          orientation = mkLiteral "horizontal";
          border-radius = mkLiteral "6px";
          padding = mkLiteral "8px 12px";
          spacing = mkLiteral "8px";
        };
        
        "element-icon" = {
          background-color = mkLiteral "inherit";
          text-color = mkLiteral "inherit";
          size = mkLiteral "24px";
          border = mkLiteral "0px";
        };
        
        "element-text" = {
          background-color = mkLiteral "inherit";
          text-color = mkLiteral "inherit";
          expand = true;
          horizontal-align = mkLiteral "0";
          vertical-align = mkLiteral "0.5";
          margin = mkLiteral "0px 2.5px 0px 2.5px";
        };
        
        "element selected" = {
          background-color = mkLiteral "@selected";
          text-color = mkLiteral "@selected-foreground";
          border = mkLiteral "0px";
          border-radius = mkLiteral "6px";
        };
        
        "element alternate" = {
          background-color = mkLiteral "@background";
          text-color = mkLiteral "@foreground";
        };
        
        "mode-switcher" = {
          enabled = true;
          background-color = mkLiteral "@background-alt";
          expand = false;
          border = mkLiteral "1px 0px 0px 0px";
          border-radius = mkLiteral "0px 0px 6px 6px";
          border-color = mkLiteral "@border-color";
          padding = mkLiteral "12px";
          spacing = mkLiteral "8px";
        };
        
        "button" = {
          background-color = mkLiteral "@background-alt";
          text-color = mkLiteral "@foreground";
          cursor = mkLiteral "pointer";
          padding = mkLiteral "8px 12px";
          border-radius = mkLiteral "6px";
        };
        
        "button selected" = {
          background-color = mkLiteral "@selected";
          text-color = mkLiteral "@selected-foreground";
        };
        
        "message" = {
          enabled = true;
          background-color = mkLiteral "@background-alt";
          text-color = mkLiteral "@foreground";
          border = mkLiteral "1px 0px 0px 0px";
          border-radius = mkLiteral "0px 0px 6px 6px";
          border-color = mkLiteral "@border-color";
          padding = mkLiteral "12px";
        };
        
        "textbox" = {
          background-color = mkLiteral "@background-alt";
          text-color = mkLiteral "@foreground";
          vertical-align = mkLiteral "0.5";
          horizontal-align = mkLiteral "0.0";
        };
      };
      extraConfig = {
        show-icons = true;
        icon-theme = "breeze-dark";
        display-drun = "Applications";
        display-run = "Run";
        display-window = "Windows";
        drun-display-format = "{name}";
        disable-history = false;
        hide-scrollbar = true;
        sidebar-mode = true;
        matching = "fuzzy";
        sort = true;
      };
    };
  };

  xdg.configFile."niri/config.kdl".text = ''
    input {
        keyboard {
            xkb {
                layout "us"
            }
        }
        touchpad {
            tap
            natural-scroll
        }
    }

    output "DP-1" {
        mode "2560x1440@144.000"
        scale 1.0
        transform "normal"
        position x=0 y=0
    }

    layout {
        gaps 16
        center-focused-column "never"

        preset-column-widths {
            proportion 0.33333
            proportion 0.5
            proportion 0.66667
        }

        default-column-width { proportion 0.5; }

        focus-ring {
            width 4
            active-color "#7fc8ff"
            inactive-color "#505050"
        }
    }

    spawn-at-startup "waybar"
    spawn-at-startup "mako"
    spawn-at-startup "nm-applet"

    binds {
        Mod+Shift+Slash { show-hotkey-overlay; }

        Mod+Return { spawn "ghostty"; }
        Mod+D { spawn "rofi" "-show" "drun"; }
        Mod+W { spawn "rofi" "-show" "window"; }

        Mod+Q { close-window; }
        
        Mod+Left  { focus-column-left; }
        Mod+Down  { focus-window-down; }
        Mod+Up    { focus-window-up; }
        Mod+Right { focus-column-right; }
        Mod+H     { focus-column-left; }
        Mod+J     { focus-window-down; }
        Mod+K     { focus-window-up; }
        Mod+L     { focus-column-right; }

        Mod+Ctrl+Left  { move-column-left; }
        Mod+Ctrl+Down  { move-window-down; }
        Mod+Ctrl+Up    { move-window-up; }
        Mod+Ctrl+Right { move-column-right; }
        Mod+Ctrl+H     { move-column-left; }
        Mod+Ctrl+J     { move-window-down; }
        Mod+Ctrl+K     { move-window-up; }
        Mod+Ctrl+L     { move-column-right; }

        Mod+Home { focus-column-first; }
        Mod+End  { focus-column-last; }
        Mod+Ctrl+Home { move-column-to-first; }
        Mod+Ctrl+End  { move-column-to-last; }

        Mod+Shift+Left  { focus-monitor-left; }
        Mod+Shift+Down  { focus-monitor-down; }
        Mod+Shift+Up    { focus-monitor-up; }
        Mod+Shift+Right { focus-monitor-right; }
        Mod+Shift+H     { focus-monitor-left; }
        Mod+Shift+J     { focus-monitor-down; }
        Mod+Shift+K     { focus-monitor-up; }
        Mod+Shift+L     { focus-monitor-right; }

        Mod+Shift+Ctrl+Left  { move-column-to-monitor-left; }
        Mod+Shift+Ctrl+Down  { move-column-to-monitor-down; }
        Mod+Shift+Ctrl+Up    { move-column-to-monitor-up; }
        Mod+Shift+Ctrl+Right { move-column-to-monitor-right; }
        Mod+Shift+Ctrl+H     { move-column-to-monitor-left; }
        Mod+Shift+Ctrl+J     { move-column-to-monitor-down; }
        Mod+Shift+Ctrl+K     { move-column-to-monitor-up; }
        Mod+Shift+Ctrl+L     { move-column-to-monitor-right; }

        Mod+Page_Down      { focus-workspace-down; }
        Mod+Page_Up        { focus-workspace-up; }
        Mod+U              { focus-workspace-down; }
        Mod+I              { focus-workspace-up; }
        Mod+Ctrl+Page_Down { move-column-to-workspace-down; }
        Mod+Ctrl+Page_Up   { move-column-to-workspace-up; }
        Mod+Ctrl+U         { move-column-to-workspace-down; }
        Mod+Ctrl+I         { move-column-to-workspace-up; }

        Mod+Shift+Page_Down { move-workspace-down; }
        Mod+Shift+Page_Up   { move-workspace-up; }
        Mod+Shift+U         { move-workspace-down; }
        Mod+Shift+I         { move-workspace-up; }

        Mod+WheelScrollDown      cooldown-ms=150 { focus-workspace-down; }
        Mod+WheelScrollUp        cooldown-ms=150 { focus-workspace-up; }
        Mod+Ctrl+WheelScrollDown cooldown-ms=150 { move-column-to-workspace-down; }
        Mod+Ctrl+WheelScrollUp   cooldown-ms=150 { move-column-to-workspace-up; }

        Mod+WheelScrollRight      { focus-column-right; }
        Mod+WheelScrollLeft       { focus-column-left; }
        Mod+Ctrl+WheelScrollRight { move-column-right; }
        Mod+Ctrl+WheelScrollLeft  { move-column-left; }

        Mod+Shift+WheelScrollDown      { focus-column-right; }
        Mod+Shift+WheelScrollUp        { focus-column-left; }
        Mod+Ctrl+Shift+WheelScrollDown { move-column-right; }
        Mod+Ctrl+Shift+WheelScrollUp   { move-column-left; }

        Mod+1 { focus-workspace 1; }
        Mod+2 { focus-workspace 2; }
        Mod+3 { focus-workspace 3; }
        Mod+4 { focus-workspace 4; }
        Mod+5 { focus-workspace 5; }
        Mod+6 { focus-workspace 6; }
        Mod+7 { focus-workspace 7; }
        Mod+8 { focus-workspace 8; }
        Mod+9 { focus-workspace 9; }
        Mod+Ctrl+1 { move-column-to-workspace 1; }
        Mod+Ctrl+2 { move-column-to-workspace 2; }
        Mod+Ctrl+3 { move-column-to-workspace 3; }
        Mod+Ctrl+4 { move-column-to-workspace 4; }
        Mod+Ctrl+5 { move-column-to-workspace 5; }
        Mod+Ctrl+6 { move-column-to-workspace 6; }
        Mod+Ctrl+7 { move-column-to-workspace 7; }
        Mod+Ctrl+8 { move-column-to-workspace 8; }
        Mod+Ctrl+9 { move-column-to-workspace 9; }

        Mod+Comma  { consume-window-into-column; }
        Mod+Period { expel-window-from-column; }

        Mod+BracketLeft  { consume-column-into-row; }
        Mod+BracketRight { expel-column-from-row; }

        Mod+R { switch-preset-column-width; }
        Mod+Shift+R { reset-window-height; }
        Mod+F { maximize-column; }
        Mod+Shift+F { fullscreen-window; }
        Mod+C { center-column; }

        Mod+Minus { set-column-width "-10%"; }
        Mod+Equal { set-column-width "+10%"; }

        Mod+Shift+Minus { set-window-height "-10%"; }
        Mod+Shift+Equal { set-window-height "+10%"; }

        Print { screenshot; }
        Ctrl+Print { screenshot-screen; }
        Alt+Print { screenshot-window; }

        Mod+Shift+E { quit; }
        Mod+Shift+P { power-off-monitors; }
    }
  '';

  # This installs my GPG signing keys for Github
  systemd.user.services.gpg-import-keys = {
    Unit = {
      Description = "Import gpg keys";
      After = [ "gpg-agent.socket" ];
    };

    Service = {
      Type = "oneshot";
      ExecStart = toString (pkgs.writeScript "gpg-import-keys" ''
        #! ${pkgs.runtimeShell} -el
        ${lib.optionalString (gpgKeys != []) ''
        ${pkgs.gnupg}/bin/gpg --import ${lib.concatStringsSep " " gpgKeys}
        ''}
      '');
    };

    Install = { WantedBy = [ "default.target" ]; };
  };
}