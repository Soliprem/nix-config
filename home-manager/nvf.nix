{
  pkgs,
  inputs,
  ...
}: {
  programs.nvf = {
    enable = true;
    enableManpages = true;
    settings = {
      vim = {
        searchCase = "smart";
        useSystemClipboard = true;
        viAlias = true;
        vimAlias = true;
        undoFile = {
          enable = true;
        };
        debugMode = {
          enable = false;
          level = 16;
          logFile = "/tmp/nvim.log";
        };
        lsp = {
          formatOnSave = false;
          lspkind.enable = false;
          lightbulb.enable = false;
          lspsaga.enable = false;
          otter-nvim = {
            enable = true;
            setupOpts.buffers.write_to_disk = true;
          };
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
          nim.enable = true;
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
          vala.enable = true;
          go.enable = true;
          elixir.enable = false;
          zig.enable = true;
          ocaml.enable = true;
          python.enable = true;
          dart.enable = false;
          lua.enable = true;
          bash.enable = true;
          tailwind.enable = false;
          typst.enable = true;
          julia.enable = true;
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
          nvim-web-devicons.enable = true;
          cellular-automaton.enable = true;
          fidget-nvim.enable = true;
          highlight-undo.enable = true;

          indent-blankline = {
            enable = true;
          };

          nvim-cursorline = {
            enable = true;
            setupOpts = {
              lineTimeout = 0;
            };
          };
        };

        statusline = {
          lualine = {
            enable = true;
            theme = "gruvbox";
          };
        };

        # luaConfigRC.basic = ''
        #   -- vim.opt.undofile = true
        # vim.g.nvim_ghost_use_script = 1
        # vim.g.nvim_ghost_python_executable = 'python'
        # '';

        theme = {
          enable = true;
          name = "gruvbox";
          style = "dark";
          transparent = false;
        };

        autopairs.nvim-autopairs.enable = true;

        autocomplete.nvim-cmp.enable = true;
        snippets.luasnip.enable = true;

        filetree = {
          nvimTree = {
            enable = false;
          };
        };

        tabline = {
          nvimBufferline.enable = false;
        };

        treesitter = {
          context.enable = true;
          grammars = [
            inputs.norg-meta.defaultPackage.${pkgs.system}
          ];
        };

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
          icon-picker.enable = true;
          surround.enable = true;
          diffview-nvim.enable = true;
          motion = {
            hop.enable = false;
            leap.enable = true;
            precognition.enable = false;
          };

          images = {
            image-nvim.enable = false;
          };
        };

        notes = {
          obsidian.enable = false; # FIXME: neovim fails to build if obsidian is enabled
          neorg = {
            enable = true;
            setupOpts = {
              load = {
                "core.defaults" = {};
                "core.concealer" = {};
                "core.completion" = {
                  config.engine = "nvim-cmp";
                };
                "core.export" = {};
                "core.summary" = {};
                "core.text-objects" = {};
                "core.dirman" = {
                  config = {
                    workspaces = {
                      notes = "~/Documents/neorg";
                    };
                  };
                };
              };
            };
          };
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
          # fastaction.enable = true;
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

        lazy.plugins = with pkgs.vimPlugins; {
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
          ${oil-nvim.pname} = {
            lazy = true;
            package = oil-nvim;
            setupModule = "oil";
            after = ''
              print('loaded oil')
            '';
            cmd = ["Oil"];
            keys = [
              {
                key = "-";
                action = ":Oil<CR>";
                mode = "n";
              }
            ];
          };
          ${zen-mode-nvim.pname} = {
            lazy = true;
            package = zen-mode-nvim;
            setupModule = "zen-mode-nvim";
            after = ''print('hello')'';
            cmd = ["ZenMode"];
          };
          ${eyeliner-nvim.pname} = {
            package = eyeliner-nvim;
            event = ["BufEnter"];
            after = ''print('hello')'';
          };
          ${quarto-nvim.pname} = {
            lazy = true;
            cmd = "QuartoPreview";
            after = ''print('hello')'';
            package = quarto-nvim;
          };
        };
        keymaps = [
          {
            key = "<esc>";
            mode = "n";
            action = ":noh<CR>";
            silent = true;
            desc = "removes search highlight when pressing esc";
          }
          {
            key = "<leader><leader>";
            mode = "n";
            action = ":Telescope find_files<CR>";
            silent = true;
            desc = "removes search highlight when pressing esc";
          }
        ];
      };
    };
  };
}
