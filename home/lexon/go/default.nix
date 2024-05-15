{pkgs, ...}:
let
  goConfig = import ./config.nix;
in
{
    programs.go = {
      enable = true;
      package = pkgs.go_1_22;  # go version
      goPath =  goConfig.goPath;  
  };
}