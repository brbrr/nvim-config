return {
  -- {
  --   'rmagatti/auto-session',
  --   lazy = false,
  --
  --   ---enables autocomplete for opts
  --   ---@module "auto-session"
  --   ---@type AutoSession.Config
  --   opts = {
  --     suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
  --     -- log_level = 'debug',
  --   },
  --   init = function()
  --     vim.o.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions'
  --   end,
  --   keys = {
  --     {
  --       '<leader>ws',
  --       function()
  --         require('auto-session').save()
  --       end,
  --       desc = 'Save session',
  --     },
  --     {
  --       '<leader>wr',
  --       function()
  --         require('auto-session').restore()
  --       end,
  --       desc = 'Restore session',
  --     },
  --     {
  --       '<leader>wd',
  --       function()
  --         require('auto-session').delete()
  --       end,
  --       desc = 'Delete session',
  --     },
  --   },
  -- },
  --

  {
    'folke/persistence.nvim',
    event = 'BufReadPre', -- this will only start session saving when an actual file was opened
    opts = {
      -- add any custom options here
    },
    keys = {
      {
        '<leader>qs',
        function()
          require('persistence').load()
        end,
        desc = 'Restore Session',
      },
      {
        '<leader>qS',
        function()
          require('persistence').select()
        end,
        desc = 'Select Session',
      },
      {
        '<leader>ql',
        function()
          require('persistence').load { last = true }
        end,
        desc = 'Restore Last Session',
      },
      {
        '<leader>qd',
        function()
          require('persistence').stop()
        end,
        desc = "Don't Save Current Session",
      },
    },
  },
}
