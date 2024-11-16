{ pkgs, ... }: 
{
  users.users.lexon = {
    isNormalUser = true;
    home = "/home/lexon";
    group = "lexon";
    extraGroups = [ "networkmanager" "wheel" "docker"];

  };
  users.groups.lexon = {};
}
