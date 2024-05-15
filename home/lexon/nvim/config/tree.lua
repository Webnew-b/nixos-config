
-- OR setup with some options
require("nvim-tree").setup({
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
  -- 不显示 git 状态图标
  git = {
    enable = false
  }
})

local ok, nvim_tree = pcall(require, "nvim-tree")
if not ok then
    return
end

-- 自动命令配置
vim.api.nvim_create_autocmd("BufEnter", {
    nested = true,
    callback = function()
        local win_count = #vim.api.nvim_list_wins()
        local filetype = vim.bo.filetype

        if win_count == 1 and filetype == "NvimTree" then
            vim.schedule(function()
                vim.cmd("quit")
            end)
        end
    end
})
