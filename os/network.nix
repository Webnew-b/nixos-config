{lib, networkSettings, ...}:
{
  networking.interfaces.ens33.ipv4.addresses = [{
    address = networkSettings.ip;
    prefixLength = networkSettings.prefixLength;
  }];

  networking.defaultGateway = {
    address = networkSettings.gateway;
    interface = networkSettings.interface;
  };

  networking.nameservers = networkSettings.dns;
  # open sshd service port
  networking.firewall.allowedTCPPorts = networkSettings.allowTCPPorts;
    
  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault false;
  # networking.interfaces.ens33.useDHCP = lib.mkDefault true;
}