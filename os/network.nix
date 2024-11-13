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
  networking.firewall.checkReversePath = "loose";
  networking.firewall.allowedUDPPorts = [ 53 ];  # 允许 DNS 解析

  networking.firewall.extraCommands = ''iptables -t nat -A POSTROUTING -s 172.17.0.0/16 ! -o docker0 -j MASQUERADE'';
    
  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault false;
  # networking.interfaces.ens33.useDHCP = lib.mkDefault true;
}
