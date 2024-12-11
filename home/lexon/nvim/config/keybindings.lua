local map = vim.keymap.set
local opt = {noremap = true, silent = true }

map("n", "<C-u>", "9k", opt)
map("n", "<C-d>", "9j", opt)

vim.g.mapleader = " "

local wk = require("which-key")

wk.setup({})

wk.register({
  ["<leader>"] = {
    n = {
      name = "floder tree and message",
      n = {'<cmd>Noice<CR>',"Show the message history."},
      t = {
        name = "nvim tree",
        o = {"<cmd>NvimTreeOpen<CR>","NvimTreeOpen"},
        c = {"<cmd>NvimTreeClose<CR>","NvimTreeClose"}
      }
    },
    l = {
      name = "lsp tools",
      j = {"<cmd>Lspsaga diagnostic_jump_next<CR>","jump next file"},
      p = {"<cmd>Lspsaga diagnostic_jump_prev<CR>","jump previous file"},
      c = {"<cmd>lua vim.diagnostic.open_float(nil,{focus=false})<CR>","to check the error"},
      k = {"<Cmd>Lspsaga hover_doc<CR>","hover doc"},
      ['sh'] = {"<Cmd>Lspsaga signature_help<CR>","signature help"},
      g = {
        name = "lsp symbol help",
        d = {"<Cmd>Lspsaga peek_definition<CR>","preview definition"},
        f = {"<Cmd>Lspsaga finder<CR>","finder"},
        g = {"<cmd>lua vim.lsp.buf.definition()<CR>","go to the definition"}
      },
      ['rn'] = {"<Cmd>Lspsaga rename<CR>","rename"}
    },
    ["ot"] = {"<Cmd>Lspsaga term_toggle<CR>","open terminal"},
    t = {
      name = "tab",
      ['f'] = {"<cmd>tabnew","open the file on new tab"},
      n = {"<cmd>tabn<CR>","open the next tab"},
      p = {"<cmd>tabp<CR>","open the pervious tab"},
    },
    s = {
      name = "split window",
      p = {"<cmd>sp<CR>","Horizontal split window"},
      v = {"<cmd>vsp<CR>","Vertcal split window"},
    },
    r = {
      name = "rust",
      h = {":RustHoverActions<CR>","rust hover action"},
    }
  }
})

