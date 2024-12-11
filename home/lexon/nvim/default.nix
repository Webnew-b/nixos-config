{pkgs, ...}:
{
    programs.neovim = {
      enable = true;

      plugins = with pkgs.vimPlugins; [
        nvim-lspconfig
        (nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars))
        lspsaga-nvim

        nui-nvim
        nvim-notify
        noice-nvim

        cmp-nvim-lsp
        cmp-buffer
        cmp-path
        cmp-cmdline
        cmp-treesitter
        nvim-cmp
        cmp-spell

        cmp-vsnip
        vim-vsnip
        nvim-tree-lua
        nvim-web-devicons
        which-key-nvim

        telescope-nvim
        telescope-fzy-native-nvim

        nvim-ts-autotag
        nvim-autopairs

        rust-tools-nvim
      ];

      extraPackages = with pkgs; [gcc ripgrep fd statix deadnix];
  
      extraConfig = let
        luaRequire = module:
          builtins.readFile (builtins.toString
            ./config
            + "/${module}.lua");
        luaConfig = builtins.concatStringsSep "\n" (map luaRequire [
          "plugins"
          "lsp"
          "lsp_rust"
          "keybindings"
          "basic"
          "cmp"
          "tree"
          "treesitter"
          "notice"
        ]);
      in ''
        set clipboard+=unnamedplus
        lua << EOF
        ${luaConfig}
        EOF
      '';
  };
}
