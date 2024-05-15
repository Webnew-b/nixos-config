{pkgs, ...}:
{
    programs.neovim = {
      enable = true;

      plugins = with pkgs.vimPlugins; [
        nvim-lspconfig

        cmp-nvim-lsp
        cmp-buffer
        cmp-path
        cmp-cmdline
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
        ]);
      in ''
        lua << EOF
        ${luaConfig}
        EOF
      '';
  };
}