local lsp = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local saga = require("lspsaga")
-- local util = require 'lspconfig.util'
--


local function on_attach(client,buffer)
  local keymap_opts = { buffer = buffer }
-- Code navigation and shortcuts
  vim.keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>", keymap_opts) -- preview definition
  vim.keymap.set("n", "gh", "<cmd>Lspsaga hover_doc<CR>", keymap_opts) -- Displays hover information 
  vim.keymap.set("n", "gi", "<cmd>Lspsaga incoming_calls<CR>", keymap_opts) -- Displays function or object incoming
  vim.keymap.set("n", "go", "<cmd>Lspsaga outgoing_calls<CR>", keymap_opts) -- Displays function or object outgoing 
  vim.keymap.set("n", "gd", vim.lsp.buf.type_definition, keymap_opts) -- Displays type definition
  vim.keymap.set("n", "gw", vim.lsp.buf.workspace_symbol, keymap_opts) 
  vim.keymap.set("n", "ga", "<cmd>Lspsaga code_action<CR>", keymap_opts)
end

saga.setup({
  stmbols_in_winbar = {
      enable = true,
      folder_level = 2,
    },
  definition = {
    keys = {
      edit = 'o'
    }
  }
})




-- lsp.bufls.setup{
--   cmd = {"bufls","serve"},
--   filetypes = { 'proto' },
--   root_dir = function(fname)
--     return util.root_pattern('buf.work.yaml', '.git')(fname)
--   end,
--   description = [[https://github.com/bufbuild/buf-language-server]],
--   default_config = {
--     root_dir = [[root_pattern("buf.work.yaml", ".git")]],
--   },
--   on_attach = on_attach,
-- }

-- require'lspconfig'.clangd.setup{
--   cmd = { "clangd", "--background-index" },
--   filetypes = { "proto" },
--   root_dir = require'lspconfig'.util.root_pattern("buf.work.yaml", ".git"),
--   single_file_support = true,
--   on_attach = function(client)
--     client.resolved_capabilities.document_formatting = false
--   end
-- }

lsp.hls.setup{
  cmd = {"haskell-language-server-wrapper","--lsp"},
  settings = {
    haskell = {
      cabel = {
        cabelPath = "cabel",
        cabalV2Build = true,
        cabalSandboxConfig = nil,
        cabalConfig = nil,
      },
      ghc = {
        path = "ghc"
      }
    }
  }
}

lsp.gopls.setup{
  cmd = {'gopls'},
  -- for postfix snippets and analyzers
  capabilities = capabilities,
  settings = {
    gopls = {
      experimentalPostfixCompletions = true,
      analyses = {
          unusedparams = true,
          shadow = true,
      },
      staticcheck = true,
      completeUnimported = true,
      usePlaceholders = true,
    },
  },
  on_attach = on_attach,
}

lsp.ts_ls.setup{
  on_attach = function(client, bufnr)
    client.resolved_capabilities.document_formatting = false
    client.resolved_capabilities.document_range_formatting = false

    local ts_utils = require("nvim-lsp-ts-utils")
    ts_utils.setup({})
    ts_utils.setup_client(client)

    on_attach(client, bufnr)
  end,
}

lsp.bashls.setup{
    capabilities = capabilities
}

lsp.pyright.setup{
    capabilities = capabilities,
    settings = {
        pylsp = {
            plugins = {
                pycodestyle = {
                    enabled = true,
                    ignore = {'W391'},
                    maxLineLength = 100
                },
                pylsp_mypy = {
                    enabled = true,
                },
                pylsp_black = {
                    enabled = true,
                },
                pylsp_isort = {
                    enabled = true,
                },
            }
        }
    }
}

lsp.lua_ls.setup {
  capabilities = capabilities,
  on_init = function(client)
    local path = client.workspace_folders[1].name
    if vim.loop.fs_stat(path..'/.luarc.json') or vim.loop.fs_stat(path..'/.luarc.jsonc') then
      return
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        -- Tell the language server which version of Lua you're using
        -- (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT'
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME
          -- Depending on the usage, you might want to add additional paths here.
          -- "${3rd}/luv/library"
          -- "${3rd}/busted/library",
        }
        -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
        -- library = vim.api.nvim_get_runtime_file("", true)
      }
    })
  end,
  settings = {
    Lua = {}
  }
}


