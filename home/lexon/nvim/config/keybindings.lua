local map = vim.keymap.set
local opt = {noremap = true, silent = true }

map("n", "sv", ":vsp<CR>", opt)
map("n", "sh", ":sp<CR>", opt) -- have some problems
map("n", "sc", "<C-w>c", opt) -- have some problems
map("n", "so", "<C-w>o", opt) -- close others

map("n", "<C-u>", "9k", opt)
map("n", "<C-d>", "9j", opt)

map("n", "<A-h>", "<C-w>h", opt)
map("n", "<A-j>", "<C-w>j", opt)
map("n", "<A-k>", "<C-w>k", opt)
map("n", "<A-l>", "<C-w>l", opt)

map("n","<leader>fed","<cmd>lua vim.diagnostic.open_float(nil,{focus=false})<CR>",opt)

map("n","<leader>nto","<cmd>NvimTreeOpen<CR>",opt)
map("n","<leader>ntc","<cmd>NvimTreeClose<CR>",opt)

vim.g.mapleader = " "

local wk = require("which-key")

wk.setup({})

wk.register({
  ["<leader>"] = {
    n = {
      ['to'] = {"<cmd>NvimTreeOpen<CR>","NvimTreeOpen"},
      ['tc'] = {"<cmd>NvimTreeClose<CR>","NvimTreeClose"}
    },
    l = {
      j = {"<cmd>Lspsaga diagnostic_jump_next<CR>","jump next file"},
      p = {"<cmd>Lspsaga diagnostic_jump_prev<CR>","jump previous file"},
      c = {"<cmd>lua vim.diagnostic.open_float(nil,{focus=false})<CR>","to check the error"},
      k = {"<Cmd>Lspsaga hover_doc<CR>","hover doc"},
      ['gf'] = {"<Cmd>Lspsaga finder<CR>","finder"},
      ['sh'] = {"<Cmd>Lspsaga signature_help<CR>","signature help"},
      ['gd'] = {"<Cmd>Lspsaga peek_definition<CR>","preview definition"},
      ['rn'] = {"<Cmd>Lspsaga rename<CR>","rename"}
    },
    ["ot"] = {"<Cmd>Lspsaga term_toggle<CR>","open terminal"},
    t = {
      ['f'] = {"<cmd>tabnew","open the file on new tab"},
      n = {"<cmd>tabn<CR>","open the next tab"},
      p = {"<cmd>tabp<CR>","open the pervious tab"},
    },
    s = {
      p = {"<cmd>sp<CR>","Horizontal split window"},
      v = {"<cmd>vsp<CR>","Vertcal split window"},
    },
  }
})

