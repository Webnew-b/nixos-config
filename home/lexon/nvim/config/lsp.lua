local lsp = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local saga = require("lspsaga")
-- local util = require 'lspconfig.util'
--


local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'ga', '<Cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)

end

saga.setup({
    definition = {
      keys = {
        edit = 'o'
      }
    }
})

lsp.rust_analyzer.setup{
  settings = {
    ["rust-analyzer"] = {
        imports = {
          granularity = {
            group = "module",
          },
          prefix = "self",
        },
        cargo = {
          allFeatures = true,
        },
        procMacro = {
          enable = true,
        },
    },
  }
}

require('rust-tools').setup({
  tools = {
    autoSetHints = true,
    hover_with_actions = true,
  },
  server = {
    settings = {
      ["rust-analyzer"] = {
        assist = {
          importGranularity = "module",
          importPrefix = "by_crate",
        },
        cargo = {
          allFeatures = true,
        },
        procMacro = {
          enable = true,
        },
      }
    }
  },
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

lsp.tsserver.setup{
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


