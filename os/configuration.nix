({ config, lib, pkgs,systemSettings, userSettings, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./network.nix
  ];

  # Enable experimental features for Nix
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Set the system timezone
  time.timeZone = systemSettings.timezone;

  # Select internationalisation properties.
  i18n.defaultLocale = systemSettings.i18n;

  
  # --- services start ---
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the XFCE Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
      layout = "us";
      variant = "";
  };

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = systemSettings.desktopUser;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
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

  # Enable the OpenSSH server
  services.openssh = {
    enable  = true;
    settings.X11Forwarding = true;
  };

  services.ntp = {
    enable = true;
    servers = [ "0.pool.ntp.org" "1.pool.ntp.org" "2.pool.ntp.org" "3.pool.ntp.org" ];
  };
  

  # --- services end ---

  # --- docker ---

  # enable docker service
  virtualisation.docker.enable = true;

  # allow user use docker
  virtualisation.docker.rootless.enable = true;

  # --- docker end ---

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # System packages to be installed
  environment.systemPackages = with pkgs; [
    wget
    curl
    unzip
    neovim
    vim
    home-manager
    tcpdump
    xclip
    nerdfonts
    docker
    openssl
  ];

  #fonts
  fonts = {
    packages = with pkgs; [
      pkgs.nerdfonts
      noto-fonts
      source-han-sans
      source-han-serif
      noto-fonts-cjk
      noto-fonts-emoji
      nerdfonts
      twemoji-color-font
    ];
  };

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  # Define your hostname.
  networking.hostName = systemSettings.hostname; 

  # Configure the NixOS release version
  system.stateVersion = systemSettings.version;  # This should match the NixOS version you are using

  # Additional documentation
  #services.nixosManual.showManual = true;  # Enable NixOS manual in the system
})
