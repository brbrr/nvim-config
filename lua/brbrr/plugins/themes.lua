return {

  { 'catppuccin/nvim', name = 'catppuccin', priority = 1000 },

  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    init = function()
      -- Load the colorscheme here.
      -- Like many other themes, this one has different styles, and you could load
      -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
      -- vim.cmd.colorscheme 'catppuccin'
      vim.cmd.colorscheme 'tokyonight-night'

      -- You can configure highlights by doing something like:
      -- vim.cmd.hi 'Comment gui=none'
    end,
    opts = {
      style = 'moon',
      on_colors = function(colors)
        -- colors.border = '#101010'
        colors.border = '#565f89'
      end,
    },
  },
}
