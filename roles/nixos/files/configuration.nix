# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices = [ {
    name = "pv-enc";
    device = "/dev/sda2";
    preLVM = true;
    allowDiscards = true;
  } ];
  boot.initrd.kernelModules = [
    "dm_snapshot"
  ];
  boot.cleanTmpDir = true;
  boot.extraModulePackages = [
    pkgs.linuxPackages.hidapplepatched
  ];
  boot.extraModprobeConfig = ''
    options libata.force=noncq
    options snd_hda_intel index=0 model=intel-mac-auto id=PCM
    options snd_hda_intel index=! model=intel-mac-auto id=HDMI
    options snd_hda_intel model=mbp101
    options hid_apple fnmode=2
    options hid_apple isolayout=0
    options hid_apple swap_fnleftctrl=1
  '';

  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  fileSystems."/home".options = [ "noatime" "nodiratime" "discard" ];

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "fr";
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "Europe/Paris";

  fonts.enableFontDir = true;
  fonts.enableCoreFonts = true;
  fonts.enableGhostscriptFonts = true;
  fonts.fonts = with pkgs; [
    corefonts
    inconsolata
    liberation_ttf
    dejavu_fonts
    bakoma_ttf
    gentium
    ubuntu_font_family
    terminus_font
  ];

  nix.useSandbox = true;
  nix.binaryCaches = [
    http://cache.nixos.org
  ];

  networking.hostName = "nixosjeremie";
  networking.firewall.enable = true;
  networking.networkmanager.enable = true;

  hardware.bluetooth.enable = false;
  hardware.facetimehd.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.opengl.extraPackages = [ pkgs.vaapiIntel ];

  environment.variables = {
    #MY_ENV_VAR = "\${HOME}/bla";
  };

  environment.systemPackages = with pkgs; [
    acpi
    curl
    customGit
    htop
    vim
    wget
    # i3
    i3status
    dmenu
    networkmanagerapplet
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.packageOverrides = pkgs: {
    linux = pkgs.linuxPackages.override {
      extraConfig = ''
        THUNDERBOLT m
      '';
      hidapplepatched = pkgs.callPackage ./pkgs/hidapplepatched.nix { };
    };
    customGit = pkgs.git.override {
      svnSupport = true;
      guiSupport = true;
    };
  };

  powerManagement.enable = true;

  programs.vim.defaultEditor = true;

  programs.light.enable = true;

  services.openssh.enable = true;

  services.locate.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  services.xserver.enable = true;
  services.xserver.enableTCP = false;
  services.xserver.layout = "fr";
  services.xserver.xkbOptions = "eurosign:e, terminate:ctrl_alt_bksp, ctrl:nocaps";

  services.xserver.multitouch.enable = true;

  services.xserver.synaptics = {
    enable = true;
    tapButtons = false;
    #buttonsMap = [ 1 3 2 ];
    twoFingerScroll = true;
    palmDetect = false;
    accelFactor = "0.001";
    additionalOptions = ''
      Option "SHMConfig" "on"
      Option "VertScrollDelta" "-100"
      Option "HorizScrollDelta" "-100"
      Option "Resolution" "370"
    '';
  };
  services.xserver.windowManager.i3.enable = true;

  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = true;

  users.defaultUserShell = pkgs.zsh;
  users.extraUsers.jeremie = {
    isNormalUser = true;
    uid = 1000;
    group = "users";
    extraGroups = [
      "wheel"
      "docker"
      "networkmanager"
      "messagebus"
      "systemd-journal"
      "disk"
      "audio"
      "video"
    ];
    createHome = true;
    home = "/home/jeremie";
  };

  programs.zsh.enable = true;
  programs.zsh.enableAutosuggestions = true;
  programs.zsh.enableCompletion = true;
  programs.zsh.enableSyntaxHighlighting = true;    

  system.stateVersion = "17.03";

  virtualisation.docker.enable = true;
  virtualisation.docker.enableOnBoot = true;
}
