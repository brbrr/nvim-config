return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      ui_select = true,
      sources = {
        explorer = {
          hidden = true,
        },
        files = {
          hidden = true,
        },
        grep = {
          hidden = true,
        },
      },
      formatters = {
        file = {
          truncate = 200,
        },
      },
    },
  },
}
