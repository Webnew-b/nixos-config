local notify = require('notify')

notify.setup({
  -- 其他配置...
  timeout = 3000,  -- 设置为0使通知常驻
  stages = "static",
  on_open = nil,
  on_close = nil,
  fps = 1,
  render = "compact",
  background_colour = "Normal",
  max_width = math.floor(vim.api.nvim_win_get_width(0) / 2),
  max_height = math.floor(vim.api.nvim_win_get_height(0) / 4),
  -- minimum_width = 50,
  -- ERROR > WARN > INFO > DEBUG > TRACE
  level = "TRACE", 
})

require("noice").setup({
  lsp = {
      progress = {
          enabled = false,
      },
  },
  presets = {
      bottom_search = false,
      command_palette = true,
      long_message_to_split = true,
      inc_rename = false,
      lsp_doc_border = true,
  },
  messages = {
      enabled = true,
      view = "notify",
      view_error = "notify",
      view_warn = "notify",
      view_history = "messages",
      view_search = "virtualtext",
  },
  health = {
      checker = false,
  },
}) 

-- 重写 vim.notify 函数
vim.notify = notify 
