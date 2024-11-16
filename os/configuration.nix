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
  security.pki.certificates = [
    ''
-----BEGIN CERTIFICATE-----
MIIDcTCCAlmgAwIBAgIUami8ArYn2RAOvPFc/vm99ZcWoRQwDQYJKoZIhvcNAQEL
BQAwWTELMAkGA1UEBhMCQ04xCzAJBgNVBAgMAlNaMQswCQYDVQQHDAJTWjEXMBUG
A1UECgwObGV4b25kZWxveS50b3AxFzAVBgNVBAMMDmxleG9uZGVsb3kudG9wMB4X
DTI0MTExNTEyMzUyNloXDTI1MTExNTEyMzUyNlowWTELMAkGA1UEBhMCQ04xCzAJ
BgNVBAgMAlNaMQswCQYDVQQHDAJTWjEXMBUGA1UECgwObGV4b25kZWxveS50b3Ax
FzAVBgNVBAMMDmxleG9uZGVsb3kudG9wMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8A
MIIBCgKCAQEA8D5ZhVIJz0YjiaUAnOb9NmT9ZG2GUmM70cqtAzVPAhkSMD82XDQF
7tohQZkud2geYJydyHcB7phG5nIPXmrdQornfG9VD/M7Gj8hOtnpcz76Jg6NeOEu
vrzCDj507Z/IcX1OXGExY0lIpud3uAYrGO4vqTCmXFkrw+b5qJ/Yy5gAh24+D/G9
7xmMs5rjUvY1krfl7iORzjqr+fAoGZ3NeNMNsUjfs/cizj6vt8gsMX/2EMT7YskL
0zuCyneG5cyQDbeFF0Wzam/+i84MWbFSUmmsWPpb9VePd2qkh+Eu4fDdsjQPqLYX
88nks3nmQlwDD0JCPGNl4WIbzA5sUJvfPwIDAQABozEwLzAtBgNVHREEJjAkgg5s
ZXhvbmRlbG95LnRvcIISd3d3LmxleG9uZGVsb3kudG9wMA0GCSqGSIb3DQEBCwUA
A4IBAQAH2do0NmqeXa+pMyG5i21sowOKtPNMcduaoMfExY1stnMvTzZjI4UZeIyu
z+xLcc803t2hGZxOuJsxG0Pn320rylEt4nJyOOOukfmJM+jjy004BHxmVv1j8b2I
JsR6sOH6qWf+hOjHSrwLKPIyaqXEJ1b85BVlC8gxbyoCFzuA4taxdlXHuNJXeZKW
FEtYarJuaQzZlol1OuGTJ9CUDr1QW3YvLvib+Lf8P7EiBhmftKDWbfR8Z8wcot0c
rZ5DQE8M73lr5PEBm35L9cBqqwoaeVGjhaVPCg1fymC1ZF3gR9CwSd96DFPbubHN
4vs0pZqB+fEskHHIj6XbaF0caUdY
-----END CERTIFICATE-----
    ''
  ];

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
