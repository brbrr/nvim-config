-- return {}
return {
  -- 'github/copilot.vim',
  -- {
  --   'zbirenbaum/copilot.lua',
  --   cmd = 'Copilot',
  --   build = ':Copilot auth',
  --   event = 'InsertEnter',
  --   opts = {
  --     suggestion = {
  --       enabled = not vim.g.ai_cmp,
  --       auto_trigger = true,
  --       keymap = {
  --         accept = '<Tab>', -- handled by nvim-cmp / blink.cmp
  --         -- accept = false, -- handled by nvim-cmp / blink.cmp
  --         next = '<M-]>',
  --         prev = '<M-[>',
  --       },
  --     },
  --     -- panel = { enabled = false },
  --     -- filetypes = {
  --     --   markdown = true,
  --     --   help = true,
  --     -- },
  --   },
  -- },
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    branch = 'main',
    dependencies = {
      { 'github/copilot.vim' }, -- or zbirenbaum/copilot.lua
      -- { 'zbirenbaum/copilot.lua' },
      { 'nvim-lua/plenary.nvim', branch = 'master' }, -- for curl, log and async functions
    },
    build = 'make tiktoken', -- Only on MacOS or Linux
    opts = function()
      vim.g.copilot_filetypes = { ['*'] = false }
      return {
        -- See Configuration section for options
        chat_autocomplete = false,
      }
    end,
    keys = {
      { '<c-s>', '<CR>', ft = 'copilot-chat', desc = 'Submit Prompt', remap = true },
      { '<leader>a', '', desc = '+ai', mode = { 'n', 'v' } },
      {
        '<leader>aa',
        function()
          return require('CopilotChat').toggle()
        end,
        desc = 'Toggle (CopilotChat)',
        mode = { 'n', 'v' },
      },
      {
        '<leader>ax',
        function()
          return require('CopilotChat').reset()
        end,
        desc = 'Clear (CopilotChat)',
        mode = { 'n', 'v' },
      },
      {
        '<leader>aq',
        function()
          local input = vim.fn.input 'Quick Chat: '
          if input ~= '' then
            require('CopilotChat').ask(input)
          end
        end,
        desc = 'Quick Chat (CopilotChat)',
        mode = { 'n', 'v' },
      },
      -- Show prompts actions with telescope
      -- { "<leader>ap", M.pick("prompt"), desc = "Prompt Actions (CopilotChat)", mode = { "n", "v" } },
    },

    -- See Commands section for default commands if you want to lazy load on them
  },
}
