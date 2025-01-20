vim.keymap.set('n', 'Q', '<nop>')

-- Duplicate a line and comment out the first line
vim.keymap.set('n', 'yc', 'yy<cmd>normal gcc<CR>p')
