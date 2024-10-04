{pkgs, ...}: {
  programs.nvf = {
    enable = true;
    # your settings need to go into the settings attribute set
    # most settings are documented in the appendix
    settings = {
      vim = {
        searchCase = "smart";
        useSystemClipboard = true;
        viAlias = true;
        vimAlias = true;
        undoFile = {
          enable = true;
          # path = "/home/soliprem/.local/state/nvf/undo";
        };
        debugMode = {
          enable = false;
          level = 16;
          logFile = "/tmp/nvim.log";
        };

        spellcheck = {
          enable = true;
        };

        lsp = {
          formatOnSave = true;
          lspkind.enable = false;
          lightbulb.enable = true;
          lspsaga.enable = false;
          trouble.enable = true;
          lspSignature.enable = true;
          lsplines.enable = true;
          nvim-docs-view.enable = false; # lags *horribly* whenever l is pressed
        };

        debugger = {
          nvim-dap = {
            enable = true;
            ui.enable = true;
          };
        };

        languages = {
          enableLSP = true;
          enableFormat = true;
          enableTreesitter = true;
          enableExtraDiagnostics = true;

          # Nim LSP is broken on Darwin and therefore
          # should be disabled by default. Users may still enable
          # `vim.languages.vim` to enable it, this does not restrict
          # that.
          # See: <https://github.com/PMunch/nimlsp/issues/178#issue-2128106096>
          nim.enable = false;

          nix.enable = true;

          markdown = {
            enable = true;
            # format.extraFiletypes = ["quarto" "rmarkdown"];
          };
          html.enable = true;
          css.enable = true;
          r.enable = true;
          sql.enable = true;
          java.enable = false;
          ts.enable = true;
          svelte.enable = false;
          go.enable = true;
          elixir.enable = false;
          zig.enable = true;
          ocaml.enable = true;
          python.enable = true;
          dart.enable = false;
          bash.enable = true;
          tailwind.enable = false;
          typst.enable = true;
          clang = {
            enable = true;
            lsp.server = "clangd";
          };

          rust = {
            enable = true;
            crates.enable = true;
          };
        };

        visuals = {
          enable = true;
          nvimWebDevicons.enable = true;
          scrollBar.enable = false;
          smoothScroll.enable = true;
          cellularAutomaton.enable = true;
          fidget-nvim.enable = true;
          highlight-undo.enable = true;

          indentBlankline = {
            enable = true;
            # fillChar = null;
            # eolChar = null;
            # scope = {
            #   enabled = true;
            # };
          };

          cursorline = {
            enable = true;
            lineTimeout = 0;
          };
        };

        statusline = {
          lualine = {
            enable = true;
            theme = "catppuccin";
          };
        };

        # vim.g.nvim_ghost_use_script = 1
        # vim.g.nvim_ghost_python_executable = 'python'
        luaConfigRC.basic = ''
          -- vim.opt.undofile = true
        '';

        theme = {
          enable = true;
          name = "catppuccin";
          style = "mocha";
          transparent = false;
        };

        autopairs.enable = true;

        autocomplete = {
          enable = true;
          type = "nvim-cmp";
        };

        filetree = {
          nvimTree = {
            enable = false;
          };
        };

        tabline = {
          nvimBufferline.enable = false;
        };

        treesitter.context.enable = true;

        binds = {
          whichKey.enable = true;
          cheatsheet.enable = true;
        };

        telescope.enable = true;

        git = {
          enable = true;
          gitsigns.enable = true;
          gitsigns.codeActions.enable = false; # throws an annoying debug message
        };

        minimap = {
          minimap-vim.enable = false;
          codewindow.enable = false; # lighter, faster, and uses lua for configuration
        };

        dashboard = {
          dashboard-nvim.enable = false;
          alpha.enable = true;
        };

        notify = {
          nvim-notify.enable = true;
        };

        projects = {
          project-nvim.enable = false;
        };

        utility = {
          ccc.enable = false;
          vim-wakatime.enable = true;
          icon-picker.enable = false;
          surround.enable = true;
          diffview-nvim.enable = true;
          motion = {
            hop.enable = false;
            leap.enable = true;
          };

          images = {
            image-nvim.enable = false;
          };
        };

        notes = {
          obsidian.enable = false; # FIXME: neovim fails to build if obsidian is enabled
          orgmode.enable = false;
          mind-nvim.enable = false;
          todo-comments.enable = true;
        };

        terminal = {
          toggleterm = {
            enable = true;
            lazygit.enable = true;
          };
        };

        ui = {
          borders.enable = true;
          noice.enable = true;
          colorizer.enable = true;
          modes-nvim.enable = false; # the theme looks terrible with catppuccin
          illuminate.enable = true;
          fastaction.enable = true;
          breadcrumbs = {
            enable = true;
            navbuddy.enable = true;
          };
          smartcolumn = {
            enable = true;
            setupOpts.custom_colorcolumn = {
              # this is a freeform module, it's `buftype = int;` for configuring column position
              nix = "110";
              ruby = "120";
              java = "130";
              go = ["90 130"];
            };
          };
        };

        assistant = {
          chatgpt.enable = false;
          copilot = {
            enable = false;
            cmp.enable = true;
          };
        };

        session = {
          nvim-session-manager.enable = false;
        };

        gestures = {
          gesture-nvim.enable = false;
        };

        comments = {
          comment-nvim.enable = true;
        };

        presence = {
          neocord.enable = false;
        };

        extraPlugins = with pkgs.vimPlugins; {
          # ghost-nvim = {
          #   package = pkgs.vimUtils.buildVimPlugin {
          #     name = "ghost-nvim";
          #     src = pkgs.fetchFromGitHub {
          #       owner = "subnut";
          #       repo = "nvim-ghost.nvim";
          #       rev = "v0.5.4";
          #       hash = "sha256-XldDgPqVeIfUjaRLVUMp88eHBHLzoVgOmT3gupPs+ao=";
          #     };
          #     setup = ''
          #       require('ghost').setup(),
          #     '';
          #   };
          # };
          oil = {
            package = pkgs.vimPlugins.oil-nvim;
            setup = "require('oil').setup()";
          };
          zen = {
            package = pkgs.vimPlugins.zen-mode-nvim;
            setup = ''require('zen-mode').setup()'';
          };
          eyeliner = {
            package = pkgs.vimPlugins.eyeliner-nvim;
            setup = "require('eyeliner').setup {
               -- highlight_on_key = true, -- show highlights only after key press
               -- dim = true, -- dim all other characters
            }";
          };
          # neorg = {
          #   package = pkgs.vimPlugins.neorg;
          #   setup = ''
          #     require('neorg').setup {
          #       load = {
          #         ['core.defaults'] = {}, -- Loads default behaviour
          #         ['core.concealer'] = {}, -- Adds pretty icons to your documents
          #         ['core.export'] = {}, -- Adds export options
          #         ['core.integrations.telescope'] = {},
          #         ['core.integrations.image'] = {},
          #         -- ['core.typst.renderer'] = {
          #         --   config = {
          #         --     dpi = 1000,
          #         --     -- render_on_enter = true,
          #         --     scale = 2,
          #         --   },
          #         -- },
          #         ['core.dirman'] = { -- Manages Neorg workspaces
          #           config = {
          #             workspaces = {
          #               notes = '~/Documents/neorg',
          #             },
          #           },
          #         },
          #       },
          #     }
          #     vim.wo.foldlevel = 99
          #     vim.wo.conceallevel = 2
          #   '';
          # };
          # markview = {
          #   package = pkgs.vimUtils.buildVimPlugin {
          #     name = "markview.nvim";
          #     src = pkgs.fetchFromGitHub {
          #       owner = "OXY2DEV";
          #       repo = "markview.nvim";
          #       rev = "v19.0.0";
          #       hash = "sha256-c1iYZmJXrAOkhyV9K97xPQbHdS/RFoktwhwG5ngXzsk=";
          #     };
          #     setup = "require('markview').setup()";
          #   };
          # };
          mkdnflow = {
            package = mkdnflow-nvim;
            setup = ''
              require('mkdnflow').setup {
                modules = {
                  bib = true,
                  buffers = true,
                  conceal = true,
                  cursor = true,
                  folds = true,
                  links = true,
                  lists = true,
                  maps = true,
                  paths = true,
                  tables = true,
                  yaml = false,
                },
                filetypes = { md = true, rmd = true, markdown = true },
                create_dirs = true,
                perspective = {
                  priority = 'first',
                  fallback = 'current',
                  root_tell = false,
                  nvim_wd_heel = false,
                  update = false,
                },
                wrap = false,
                bib = {
                  default_path = nil,
                  find_in_root = true,
                },
                silent = false,
                links = {
                  style = 'markdown',
                  name_is_source = false,
                  conceal = false,
                  context = 0,
                  implicit_extension = nil,
                  transform_implicit = false,
                  transform_explicit = function(text)
                    text = text:gsub(' ', '-')
                    text = text:lower()
                    return text
                  end,
                },
                to_do = {
                  symbols = { ' ', '-', 'X' },
                  update_parents = true,
                  not_started = ' ',
                  in_progress = '-',
                  complete = 'X',
                },
                tables = {
                  trim_whitespace = true,
                  format_on_move = true,
                  auto_extend_rows = false,
                  auto_extend_cols = false,
                },
                yaml = {
                  bib = { override = false },
                },
                mappings = {
                  MkdnEnter = { { 'n', 'v' }, '<CR>' },
                  MkdnTab = false,
                  MkdnSTab = false,
                  MkdnNextLink = { 'n', '<Tab>' },
                  MkdnPrevLink = { 'n', '<S-Tab>' },
                  MkdnNextHeading = { 'n', ']]' },
                  MkdnPrevHeading = { 'n', '[[' },
                  MkdnGoBack = { 'n', '<BS>' },
                  MkdnGoForward = { 'n', '<Del>' },
                  MkdnCreateLink = false, -- see MkdnEnter
                  MkdnCreateLinkFromClipboard = { { 'n', 'v' }, '<leader>pp' }, -- see MkdnEnter
                  MkdnFollowLink = false, -- see MkdnEnter
                  MkdnDestroyLink = { 'n', '<M-CR>' },
                  MkdnTagSpan = { 'v', '<M-CR>' },
                  MkdnMoveSource = { 'n', '<F2>' },
                  MkdnYankAnchorLink = { 'n', 'ya' },
                  MkdnYankFileAnchorLink = { 'n', 'yfa' },
                  MkdnIncreaseHeading = { 'n', '+' },
                  MkdnDecreaseHeading = { 'n', '<C>-' },
                  MkdnToggleToDo = { { 'n', 'v' }, '<C-Space>' },
                  MkdnNewListItem = false,
                  MkdnNewListItemBelowInsert = { 'n', 'o' },
                  MkdnNewListItemAboveInsert = { 'n', 'O' },
                  MkdnExtendList = false,
                  MkdnUpdateNumbering = { 'n', '<leader>nn' },
                  MkdnTableNextCell = { 'i', '<Tab>' },
                  MkdnTablePrevCell = { 'i', '<S-Tab>' },
                  MkdnTableNextRow = false,
                  MkdnTablePrevRow = { 'i', '<M-CR>' },
                  MkdnTableNewRowBelow = { 'n', '<leader>ir' },
                  MkdnTableNewRowAbove = { 'n', '<leader>iR' },
                  MkdnTableNewColAfter = { 'n', '<leader>ic' },
                  MkdnTableNewColBefore = { 'n', '<leader>iC' },
                  MkdnFoldSection = { 'n', '<leader>f' },
                  MkdnUnfoldSection = { 'n', '<leader>F' },
                },
                new_file_template = {
                  template = [[
                # {{ title }}
                Date: {{ date }}
                Tags:
                ]],
                },
                }
            '';
          };
        };
        # startPlugins = with pkgs; [
        #   luajitPackages.lua-utils-nvim
        #   luajitPackages.rocks-nvim
        #   vimPlugins.nvim-nio
        #   luajitPackages.pathlib-nvim
        #   vimPlugins.plenary-nvim
        #   vimPlugins.nui-nvim
        # ];
        maps.normal = {
          "-" = {
            action = ":Oil<CR>";
            silent = true;
            desc = "Oil";
          };
        };
      };
    };
  };
}
