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
    g = {
      o = {"<cmd>NvimTreeOpen<CR>","NvimTreeOpen"},
      c = {"<cmd>NvimTreeClose<CR>","NvimTreeClose"}
    },
    l = {
      e = {"<cmd>lua vim.diagnostic.open_float(nil,{focus=false})<CR>","to check the error"}
    }
  }
})

