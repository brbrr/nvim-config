vim.keymap.set('n', 'Q', '<nop>')

-- Duplicate a line and comment out the first line
vim.keymap.set('n', 'yc', 'yy<cmd>normal gcc<CR>p')

vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
-- vim.keymap.set('n', '<C-f>', '<C-f>zz')
-- vim.keymap.set('n', '<C-b>', '<C-b>zz')
