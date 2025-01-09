{pkgs, pkgs24_05,...}:
{
    programs.neovim = {
      enable = true;

      plugins = with pkgs.vimPlugins; [
        tokyonight-nvim

        nvim-lspconfig
        (pkgs24_05.vimPlugins.nvim-treesitter.withPlugins (_: pkgs24_05.tree-sitter.allGrammars))
        pkgs24_05.vimPlugins.lspsaga-nvim

        #pkgs24_05.vimPlugins.nui-nvim
        nvim-notify
        pkgs24_05.vimPlugins.noice-nvim

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

        pkgs24_05.vimPlugins.rust-tools-nvim
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
