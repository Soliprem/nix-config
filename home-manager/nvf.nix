{pkgs, inputs, ...}: {
  programs.nvf = {
    enable = true;
    enableManpages = true;
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
          formatOnSave = false;
          lspkind.enable = false;
          lightbulb.enable = true;
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
          enable = true;
          nvimWebDevicons.enable = true;
          cellularAutomaton.enable = true;
          fidget-nvim.enable = true;
          highlight-undo.enable = true;

          indentBlankline = {
            enable = true;
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
            package = oil-nvim;
            setup = "require('oil').setup()";
          };
          zen = {
            package = zen-mode-nvim;
            setup = ''require('zen-mode').setup()'';
          };
          eyeliner = {
            package = eyeliner-nvim;
            setup = "require('eyeliner').setup {
               -- highlight_on_key = true, -- show highlights only after key press
               -- dim = true, -- dim all other characters
            }";
          };
          quarto = {
            package = quarto-nvim;
            setup = ''
              require('quarto').setup()
            '';
          };
        };
        maps.normal = {
          "-" = {
            action = ":Oil<CR>";
            silent = true;
            desc = "Oil";
          };
          "<esc>" = {
            action = ":noh<CR>";
            silent = true;
            desc = "removes search highlight when pressing esc";
          };
        };
      };
    };
  };
}
