{pkgs, ...}:
{
    programs.neovim = {
      enable = true;

      plugins = with pkgs.vimPlugins; [
        nvim-lspconfig
        (nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars))
        
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
          "keybindings"
          "basic"
          "cmp"
          "tree"
          "treesitter"
        ]);
      in ''
        lua << EOF
        ${luaConfig}
        EOF
      '';
  };
}
