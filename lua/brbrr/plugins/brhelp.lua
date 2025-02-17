return {
  {
    dir = '~/.config/nvim/lua/brbrr/brhelp',
    name = 'brhelp', -- A unique name for your plugin
    config = function()
      require('brbrr.brhelp').setup()
    end,
    dependencies = { 'nvim-lua/plenary.nvim' },
  },
}
