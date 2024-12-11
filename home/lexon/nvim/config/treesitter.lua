require'nvim-treesitter.configs'.setup {  

  highlight = {
    enable = true,                -- 启用语法高亮
  },
  rainbow = {
    enable = true,
    extended_mode = true,
  },
  autotag = {
    enable = false,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
  fold = {
    enable = true,
  },

  parser_install_dir = vim.fn.stdpath('data') .. '/parsers',

  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
  },
}

vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
vim.o.foldenable = false
