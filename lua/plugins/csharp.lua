return {
  -- {
  --   "seblj/roslyn.nvim",
  --   ft = "cs",
  --   opts = {},
  -- },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- omnisharp = {
        --   enabled = false,
        -- },
        ["omnisharp-mono"] = {
          enabled = false,
        },
      },
    },
  },

  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        cs = {},
      },
      formatters = {
        csharpier = {
          command = "dotnet-csharpier",
          args = { "--write-stdout" },
        },
      },
    },
  },
  {
    "Cliffback/netcoredbg-macOS-arm64.nvim",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      local dap = require("dap")
      require("netcoredbg-macOS-arm64").setup(dap)
      -- dap.adapters.netcoredbg = dap.adapters.coreclr
      -- dap.adapters.coreclr = nil

      -- dap.adapters.coreclr.args =
      --   { "--interpreter=vscode", "--engineLogging=/Users/brbrr/.local/state/nvim_lazy/csharp.log", "--log" }
    end,
  },

  -- {
  --   "mfussenegger/nvim-dap",
  --   opts = function()
  --     local dap = require("dap")
  --     dap.set_log_level("DEBUG") -- Options: TRACE, DEBUG, INFO, WARN, ERROR
  --     local adapter = "netcoredbg"
  --     -- local adapter = "coreclr"
  --     print("!!!! hello")
  --     -- if not dap.adapters[adapter] then
  --     -- dap.adapters[adapter] = {
  --     --   type = "executable",
  --     --   command = vim.fn.exepath(adapter),
  --     --   args = { "--interpreter=vscode", "--engineLogging=/Users/brbrr/.local/state/nvim_lazy/csharp.log", "--log" },
  --     --   options = {
  --     --     detached = false,
  --     --   },
  --     -- }
  --     -- -- end
  --     -- for _, lang in ipairs({ "cs", "fsharp", "vb" }) do
  --     --   if not dap.configurations[lang] then
  --     --     dap.configurations[lang] = {
  --     --       {
  --     --         type = adapter,
  --     --         name = "Launch file",
  --     --         request = "launch",
  --     --         ---@diagnostic disable-next-line: redundant-parameter
  --     --         program = function()
  --     --           return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/", "file")
  --     --         end,
  --     --         cwd = "${workspaceFolder}",
  --     --       },
  --     --     }
  --     --   end
  --     -- end
  --   end,
  -- },

  {
    "nvim-neotest/neotest",
    opts = {
      -- Can be a list of adapters like what neotest expects,
      -- or a list of adapter names,
      -- or a table of adapter names, mapped to adapter configs.
      -- The adapter will then be automatically loaded with the config.
      adapters = {
        ["neotest-dotnet"] = {
          dap = {
            -- Extra arguments for nvim-dap configuration
            -- See https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for values
            args = { justMyCode = false },
            -- Enter the name of your dap adapter, the default value is netcoredbg
            -- adapter_name = "netcoredbg",
            adapter_name = "coreclr",
          },
          -- dotnet_additional_args = {
          --   '--verbosity detailed',
          -- },
        },
      },
    },
  },
}
