{ config, pkgs, lib, networkSettings, ... }:

let
  goConfig = import ./go/config.nix;
in
{

  imports = [
    ./nvim
    ./go
  ];

  # 注意修改这里的用户名与用户目录
  home.username = "lexon";
  home.homeDirectory = lib.mkForce "/home/lexon";
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # 直接将当前文件夹的配置文件，链接到 Home 目录下的指定位置
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # 递归将某个文件夹中的文件，链接到 Home 目录下的指定位置
  # home.file.".config/nvim" = {
  #   source = ./nvim;
  #   recursive = true;   # 递归整个文件夹
  #   executable = true;  # 将其中所有文件添加「执行」权限
  # };

  # 直接以 text 的方式，在 nix 配置文件中硬编码文件内容
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  # 设置鼠标指针大小以及字体 DPI（适用于 4K 显示器）
  xresources.properties = {
    "Xcursor.size" = 16;
    "Xft.dpi" = 96;
  };

  # 通过 home.packages 安装一些常用的软件
  # 这些软件将仅在当前用户下可用，不会影响系统级别的配置
  # 建议将所有 GUI 软件，以及与 OS 关系不大的 CLI 软件，都通过 home.packages 安装
  home.packages = with pkgs;[
    # 如下是我常用的一些命令行工具，你可以根据自己的需要进行增删
    neofetch
    nnn # terminal file manager

    # archives
    zip
    xz
    unzip
    p7zip

    # utils
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processor https://github.com/mikefarah/yq
    eza # A modern replacement for ‘ls’
    fzf # A command-line fuzzy finder
    zlib
    pkg-config

    # networking tools
    mtr # A network diagnostic tool
    iperf3
    dnsutils  # `dig` + `nslookup`
    ldns # replacement of `dig`, it provide the command `drill`
    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    socat # replacement of openbsd-netcat
    nmap # A utility for network discovery and security auditing
    ipcalc  # it is a calculator for the IPv4/v6 addresses
    v2ray #proxy client
    v2raya

    # misc
    cowsay
    file
    which
    tree
    gnused
    gnutar
    gawk
    zstd
    gnupg

    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor

    # productivity
    glow # markdown previewer in terminal

    btop  # replacement of htop/nmon
    iotop # io monitoring
    iftop # network monitoring

    # system call monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files

    cmake
    

    # system tools
    sysstat
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb 

    # lsp
    lua-language-server
    nodePackages.typescript-language-server
    buf-language-server
    buf
    haskellPackages.haskell-language-server

    #env
    #docker
    docker
    docker-compose
    #python
    python3
    python311Packages.python-lsp-server
    nodePackages.pyright
    #go
    gopls
    protobuf
    protoc-gen-go
    protoc-gen-go-grpc
    #haskell
    haskellPackages.ghc
    haskellPackages.cabal-install
    haskellPackages.stack
    haskellPackages.hoogle
    #node
    nodejs
    nodePackages.typescript
    nodePackages.bash-language-server
    nodePackages.pnpm
    #c
    clang
    clang-tools
    #rust
    rustc
    cargo
    rust-analyzer
    #solana
    solana-cli
    anchor
    #yarn
    yarn
  ];

  # git 相关配置
  programs.git = {
    enable = true;
    userName = "lexon";
    userEmail = "lexonnewb@foxmail.com";
  };

  # 启用 starship，这是一个漂亮的 shell 提示符
  programs.starship = {
    enable = true;
    # 自定义配置
    settings = {
      add_newline = false;
      aws.disabled = true;
      gcloud.disabled = true;
      line_break.disabled = true;
    };
  };

  # alacritty - 一个跨平台终端，带 GPU 加速功能
  programs.alacritty = {
    enable = true;
    # 自定义配置
    settings = {
      env.TERM = "xterm-256color";
      font = {
        size = 12;
        draw_bold_text_with_bright_colors = true;
      };
      scrolling.multiplier = 5;
      selection.save_to_clipboard = true;
    };
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    # TODO 在这里添加你的自定义 bashrc 内容
    bashrcExtra = ''
    export PATH="$PATH:$HOME/bin:$HOME/.local/bin:${goConfig.goRoot}/bin"
    export CARGO_HOME="$HOME/.cargo";
    export RUSTUP_HOME="$HOME/.rustup";
    export GOPATH="${goConfig.goPath}";
    export GO111MODULE="${goConfig.goModule}";
    export GOBIN="${goConfig.goBin}";
    export GOPROXY="${goConfig.goProxy}";
    export PKG_CONFIG_PATH="${pkgs.openssl.dev}/lib/pkgconfig";

    if ! pgrep -u "$USER" ssh-agent > /dev/null; then
      eval "$(ssh-agent -s)"
    fi
    '';

    # TODO 设置一些别名方便使用，你可以根据自己的需要进行增删
    shellAliases = {
      k = "kubectl";
      urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
      urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
    };
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
