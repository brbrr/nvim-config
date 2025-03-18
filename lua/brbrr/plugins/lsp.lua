return {
  -- LSP Plugins
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
      },
    },
  },
  { 'Bilal2453/luvit-meta', lazy = true },
  {
    'mrcjkb/rustaceanvim',
    version = '^5', -- Recommended
    lazy = false, -- This plugin is already lazy

    -- ft = { 'rust' },
    opts = {
      server = {
        on_attach = function(_, bufnr)
          vim.keymap.set('n', '<leader>cr', function()
            vim.cmd.RustLsp 'codeAction'
          end, { desc = 'Code Action', buffer = bufnr })
          vim.keymap.set('n', '<leader>dr', function()
            vim.cmd.RustLsp 'debuggables'
          end, { desc = 'Rust Debuggables', buffer = bufnr })
          -- Override default continue keymap
          -- vim.keymap.set('n', '<leader>dc', function()
          --   -- will fail if there is no rust-analyzer client
          --   local success = pcall(vim.cmd.RustLsp, 'debuggables')
          --   if not success then
          --     vim.cmd.DapContinue()
          --   end
          -- end)
        end,
        default_settings = {
          -- rust-analyzer language server configuration
          ['rust-analyzer'] = {
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              buildScripts = {
                enable = true,
              },
            },
            -- Add clippy lints for Rust if using rust-analyzer
            -- checkOnSave = diagnostics == 'rust-analyzer',
            -- -- Enable diagnostics if using rust-analyzer
            -- diagnostics = {
            --   enable = diagnostics == 'rust-analyzer',
            -- },
            procMacro = {
              enable = true,
              ignored = {
                ['async-trait'] = { 'async_trait' },
                ['napi-derive'] = { 'napi' },
                ['async-recursion'] = { 'async_recursion' },
              },
            },
            files = {
              excludeDirs = {
                '.direnv',
                '.git',
                '.github',
                '.gitlab',
                'bin',
                'node_modules',
                'target',
                'venv',
                '.venv',
              },
            },
          },
        },
      },
    },
    config = function(_, opts)
      --   -- if LazyVim.has 'mason.nvim' then
      --   local package_path = require('mason-registry').get_package('codelldb'):get_install_path()
      --   local codelldb = package_path .. '/extension/adapter/codelldb'
      --   local library_path = package_path .. '/extension/lldb/lib/liblldb.dylib'
      --   local uname = io.popen('uname'):read '*l'
      --   if uname == 'Linux' then
      --     library_path = package_path .. '/extension/lldb/lib/liblldb.so'
      --   end
      --   opts.dap = {
      --     adapter = require('rustaceanvim.config').get_codelldb_adapter(codelldb, library_path),
      --   }
      --   -- end
      --   vim.g.rustaceanvim = vim.tbl_deep_extend('keep', vim.g.rustaceanvim or {}, opts or {})
      --   if vim.fn.executable 'rust-analyzer' == 0 then
      --     LazyVim.error('**rust-analyzer** not found in PATH, please install it.\nhttps://rust-analyzer.github.io/', { title = 'rustaceanvim' })
      --   end
      --   vim.g.rustaceanvim.dap.autoload_configurations = true
    end,
  },
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      -- { 'j-hui/fidget.nvim', opts = {} },

      -- Allows extra capabilities provided by nvim-cmp
      -- 'hrsh7th/cmp-nvim-lsp',
      'saghen/blink.cmp',
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

          -- Jump to the type of the word under your cursor.
          --  Useful when ygu're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map('gy', require('telescope.builtin').lsp_type_definitions, 'Goto T[y]pe Definition')

          -- Find references for the word under your cursor.
          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          map('<leader>ss', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[S]search Dynamic Workspace [S]ymbols')
          map('<leader>sS', require('telescope.builtin').lsp_workspace_symbols, '[S]search Workspace [S]ymbols')

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- FIXME: Workaround to make python shift-K to work properly
          -- map('K', vim.lsp.buf.hover, '(LSP) Get definition')

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      -- local capabilities = vim.lsp.protocol.make_client_capabilities()
      -- capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      local servers = {
        clangd = {},
        gopls = {},
        -- rust_analyzer = {}, // is set up in rustaceanvim
        jsonls = {
          on_new_config = function(new_config)
            new_config.settings.json.schemas = new_config.settings.json.schemas or {}
            vim.list_extend(new_config.settings.json.schemas, require('schemastore').json.schemas())
          end,
          settings = {
            json = {
              format = {
                enable = true,
              },
              validate = { enable = true },
            },
          },
        },
        -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
        --
        -- Some languages (like typescript) have entire language plugins that can be useful:
        --    https://github.com/pmizio/typescript-tools.nvim
        --
        -- But for many setups, the LSP (`ts_ls`) will work just fine
        ts_ls = {
          filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
          init_options = {
            plugins = {
              {
                name = '@vue/typescript-plugin',
                location = vim.fn.stdpath 'data' .. '/mason/packages/vue-language-server/node_modules/@vue/language-server',
                -- languages = { 'vue' },
                languages = { 'javascript', 'typescript', 'vue' },
              },
            },
          },
        },
        --
        lua_ls = {
          -- cmd = {...},
          -- filetypes = { ...},
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
        ansiblels = {},
        zls = {},

        -- pyright = {},
        ruff = {},
        basedpyright = {},
        -- settings = {
        --   basedpyright = {
        --     analysis = {
        --       -- typeCheckingMode = 'off', -- off, basic, standard, strict, all
        --       autoSearchPaths = true,
        --       useLibraryCodeForTypes = true,
        --       autoImportCompletions = true,
        --       diagnosticsMode = 'openFilesOnly', -- workspace, openFilesOnly
        --       diagnosticSeverityOverrides = {
        --         reportUnknownMemberType = false,
        --         reportUnknownArgumentType = false,
        --         -- reportUnusedClass = "warning",
        --         -- reportUnusedFunction = "warning",
        --         reportUndefinedVariable = false, -- ruff handles this with F822
        --       },
        --     },
        --   },
        -- },
        -- },
        volar = {},
        -- LAZYVIM SETUP
        -- volar = {
        --   init_options = {
        --     vue = {
        --       hybridMode = true,
        --     },
        --   },
        -- },
        -- vtsls = {
        --   filetypes = { 'vue' },
        --   settings = {
        --     vtsls = {
        --       tsserver = {
        --         globalPlugins = {
        --           {
        --             name = '@vue/typescript-plugin',
        --             location = vim.fn.stdpath 'data' .. '/mason/packages/vue-language-server/node_modules/@vue/language-server',
        --             languages = { 'vue' },
        --             configNamespace = 'typescript',
        --             enableForWorkspaceTypeScriptVersions = true,
        --           },
        --         },
        --       },
        --     },
        --   },
        -- },
        tailwindcss = {},

        omnisharp = {
          handlers = {
            ['textDocument/definition'] = function(...)
              return require('omnisharp_extended').handler(...)
            end,
          },
          keys = {
            {
              'gd',
              BrHelp.has 'telescope.nvim' and function()
                require('omnisharp_extended').telescope_lsp_definitions()
              end or function()
                require('omnisharp_extended').lsp_definitions()
              end,
              desc = 'Goto Definition',
            },
          },
          enable_roslyn_analyzers = true,
          organize_imports_on_format = true,
          enable_import_completion = true,
        },
      }

      -- Ensure the servers and tools above are installed
      --  To check the current status of installed tools and/or manually install
      --  other tools, you can run
      --    :Mason
      --
      --  You can press `g?` for help in this menu.
      require('mason').setup()

      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
        'lua-language-server',

        'json-lsp',
        'markdownlint',
        'clangd',
        'codelldb',
        'gopls',
        'typescript-language-server',
        'eslint_d',
        'prettier',

        -- 'roslyn',
        'csharpier',
        'netcoredbg',
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup()
      -- require('mason-lspconfig').setup {
      -- handlers = {
      --   function(server_name)
      --     local server = servers[server_name] or {}
      --     -- This handles overriding only values explicitly passed
      --     -- by the server configuration above. Useful when disabling
      --     -- certain features of an LSP (for example, turning off formatting for ts_ls)
      --     server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
      --     require('lspconfig')[server_name].setup(server)
      --   end,
      -- },
      -- }

      local lspconfig = require 'lspconfig'
      for server, config in pairs(servers) do
        -- passing config.capabilities to blink.cmp merges with the capabilities in your
        -- `opts[server].capabilities, if you've defined it
        config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
        lspconfig[server].setup(config)
      end
    end,
  },
}
