vim.keymap.set('n', 'Q', '<nop>')

-- Duplicate a line and comment out the first line
vim.keymap.set('n', 'yc', 'yy<cmd>normal gcc<CR>p')

local function lazykeys(keys)
  keys = vim.api.nvim_replace_termcodes(keys, true, false, true)
  return function()
    local old = vim.o.lazyredraw
    vim.o.lazyredraw = true
    vim.api.nvim_feedkeys(keys, 'nx', false)
    vim.o.lazyredraw = old
  end
end

vim.keymap.set('n', '<c-d>', lazykeys '<c-d>zz', { desc = 'Scroll down half screen' })
vim.keymap.set('n', '<c-u>', lazykeys '<c-u>zz', { desc = 'Scroll up half screen' })

-- vim.keymap.set('n', '<C-d>', '<C-d>zz')
-- vim.keymap.set('n', '<C-u>', '<C-u>zz')
-- vim.keymap.set('n', '<C-f>', '<C-f>zz')
-- vim.keymap.set('n', '<C-b>', '<C-b>zz')
