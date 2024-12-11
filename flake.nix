{

  outputs = inputs@{ 
    self
    ,nixpkgs
    ,home-manager
    ,... 
  }: 

  let 

    pkgs = (import nixpkgs {
        system = systemSettings.system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = true;
        };
        overlays = [ ];
     });

    userSettings = rec {
      username = "lexon";
      name = "lexon";
      font = "JetBrains Mono";
      fontPkg = pkgs.noto-fonts;
    };

    systemSettings = {
        system = "x86_64-linux";
        hostname = "lexon";
        profile = "lexon";
        timezone = "Asia/Shanghai";
        locale = "en_US.UTF-8";
        version = "24.05";
        desktopUser = "lexon";
        i18n = "en_HK.UTF-8";
    };

    networkSettings = {
      ip = "192.168.2.131";
      prefixLength = 24;
      gateway = "192.168.2.2";
      interface = "ens33";
      dns = [ "192.168.1.200" "8.8.8.8" "4.2.2.2" ];
      allowTCPPorts = [
        22
        2017
        80
        52345
      ] ++ (pkgs.lib.range 6000 6063) ++ (pkgs.lib.range 8080 8100);
    };

  in
  {
    nixosConfigurations.lexon-nixos = nixpkgs.lib.nixosSystem {
      system = systemSettings.system;
      specialArgs = { 
        inherit inputs;
        inherit userSettings;
        inherit systemSettings;
        inherit networkSettings;
      };
      modules = [
        home-manager.nixosModules.home-manager
        ./os/configuration.nix   
        {
           home-manager.useGlobalPkgs = true;
           home-manager.useUserPackages = true;
           home-manager.users.lexon = import ./home/lexon;
           home-manager.extraSpecialArgs = {
               inherit userSettings;
               inherit networkSettings;
           };
        }
        ./user.nix
      ];
    };
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    gomod2nix.url = "github:nix-community/gomod2nix";
  };

}
