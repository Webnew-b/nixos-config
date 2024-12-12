local lsp = require('lspconfig')

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

lsp.rust_analyzer.setup{
  root_dir = require('lspconfig/util').root_pattern('Cargo.toml', '.git'),
  settings = {
    ["rust-analyzer"] = {
      checkOnSave = {
        enable = true,
        command = "clippy"
      },
      imports = {
        granularity = {
          group = "module",
        },
        prefix = "self",
      },
      cargo = {
        allFeatures = true,
        loadOutDirsFromCheck = true,
        runBuildScripts = true,  -- 运行构建脚本以正确加载编译器生成的内容
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
    runnables = {
      use_telescope = true,
    },
    inlay_hints = {
      enable = true,
      auto = true,
      show_parameter_hints = false,
      parameter_hints_prefix = "<-",
      other_hints_prefix = "->",
    },
  },
  server = {
    on_attach = on_attach,
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


