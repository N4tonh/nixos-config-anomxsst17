# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./gaming.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # --- HARDWARE & DRIVERS ---

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # zRam para optimizar RAM
  zramSwap.enable = true;

  # microcódigo de intel
  hardware.cpu.intel.updateMicrocode = true;

  # aceleración por hardware
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-vaapi-driver
      libvdpau-va-gl
    ];
  };

  # NVIDIA Drivers
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
  	modesetting.enable = true;
	powerManagement.enable = false;
	powerManagement.finegrained = false;
	open = false;
	nvidiaSettings = true;
	package = config.boot.kernelPackages.nvidiaPackages.legacy_470;
  };
  
  hardware.nvidia.prime = {
  	offload.enable = true;
	offload.enableOffloadCmd = true;
  	intelBusId = "PCI:0:2:0";
	nvidiaBusId = "PCI:1:0:0";
  };

  nixpkgs.config.nvidia.acceptLicense = true;


  # --- VIRTUALIZACIÓN Y CONTENEDORES ---

  # Virtualbox
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "anomxsst17" ];

  # Docker
  virtualisation.docker = {
    enable = true;
  };

  networking.hostName = "twarlien"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Caracas";

  # Select internationalisation properties.
  i18n.defaultLocale = "es_VE.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_VE.UTF-8";
    LC_IDENTIFICATION = "es_VE.UTF-8";
    LC_MEASUREMENT = "es_VE.UTF-8";
    LC_MONETARY = "es_VE.UTF-8";
    LC_NAME = "es_VE.UTF-8";
    LC_NUMERIC = "es_VE.UTF-8";
    LC_PAPER = "es_VE.UTF-8";
    LC_TELEPHONE = "es_VE.UTF-8";
    LC_TIME = "es_VE.UTF-8";
  };

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enabl
  
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
    config.common.default = "*";
  };
  
  # Enable hyprland, niri & DMS
  programs.niri.enable = true;
  programs.dms-shell = {
    enable = true;

    systemd = {
      enable = true;             # Systemd service for auto-start
      restartIfChanged = true;   # Auto-restart dms.service when dms-shell changes
    };

    # Core features
    enableSystemMonitoring = true;     # System monitoring widgets (dgop)
    enableVPN = true;                  # VPN management widget
    enableDynamicTheming = false;       # Wallpaper-based theming (matugen)
    enableAudioWavelength = true;      # Audio visualizer (cava)
    enableClipboardPaste = true;       # Pasting from the clipboard history (wtype)
  };

  # DMS Greeter
  services.displayManager.dms-greeter = {
    enable = true;
    compositor.name = "niri";  # Or "hyprland" or "sway"
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "es";
    variant = "winkeys";
  };

# Para que nautilus vea el fucking mierda de ceular
services.gvfs.enable = true;
services.udisks2.enable = true;


# XWAYLAND MALDITA SEAAAAAAAAAAAAAAAAAAAAA

programs.xwayland.enable = true;

# Configure console keymap
  console.keyMap = "es";

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.anomxsst17 = {
    isNormalUser = true;
    description = "ANOMXSST";
    extraGroups = [ "networkmanager" "wheel" "docker" "adbusers" "kvm" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Allow flatpak
  services.flatpak.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    neovim
    wireguard-tools
    protonvpn-gui
    fastfetch
    qemu
    distrobox
    kitty
    dsearch
    xwayland
    xwayland-satellite
    unzip
    jq
    nodejs_25
    android-tools
  ];
  
  # FISH SHELL
  users.users.anomxsst17.shell = pkgs.fish;
  programs.fish.enable = true;

  # nix-ld

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    openssl
    zlib
    # Añade aquí otras dependencias si la app las pide luego
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
