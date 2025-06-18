{
  pkgs,
  inputs,
  ...
}: let
  norg = pkgs.tree-sitter.buildGrammar {
    language = "norg";
    version = "0.0.0+rev=d89d95a";

    src = pkgs.fetchFromGitHub {
      owner = "nvim-neorg";
      repo = "tree-sitter-norg";
      rev = "d89d95af13d409f30a6c7676387bde311ec4a2c8";
      hash = "sha256-z3h5qMuNKnpQgV62xZ02F5vWEq4VEnm5lxwEnIFu+Rw=";
    };

    meta.homepage = "https://github.com/nvim-neorg/tree-sitter-norg";
  };
  ghosttext-dependencies = pkgs.python313.withPackages (ps:
    with ps; [
      pynvim
      requests
      simple-websocket-server
    ]);
in {
  imports = [
    inputs.nvf.nixosModules.default
  ];
  programs.nvf = {
    enable = true;
    enableManpages = true;
    settings = {
      vim = {
        clipboard = {
          enable = true;
          registers = "unnamedplus";
          providers.wl-copy.enable = true;
        };
        options = {
          shiftwidth = 2;
          conceallevel = 1;
        };
        preventJunkFiles = true;
        searchCase = "smart";
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
          enable = true;
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
          nvim-docs-view.enable = false; # lags *horribly* whenever l is pressed
        };

        debugger = {
          nvim-dap = {
            enable = true;
            ui.enable = true;
          };
        };

        languages = {
          enableFormat = true;
          enableTreesitter = true;
          enableExtraDiagnostics = true;
          nim.enable = true;
          nix.enable = true;
          markdown = {
            enable = true;
            extensions.render-markdown-nvim.enable = true;
            format.type = "prettierd";
            # format.extraFiletypes = ["quarto" "rmarkdown"];
          };
          html.enable = true;
          css.enable = true;
          r = {
            enable = true;
            format.type = "styler";
          };
          sql.enable = true;
          java.enable = false;
          ts = {
            enable = true;
            extraDiagnostics.enable = false;
          };
          svelte.enable = false;
          vala.enable = true;
          go.enable = true;
          elixir.enable = false;
          zig.enable = true;
          ocaml.enable = true;
          nu.enable = true;
          python = {
            enable = true;
            lsp.server = "pyright";
          };
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
            theme = "tokyonight";
          };
        };

        luaConfigRC.basic = ''
          vim.g.nvim_ghost_use_script = 1
          vim.g.nvim_ghost_python_executable = '${ghosttext-dependencies}/bin/python'
        '';

        theme = {
          enable = true;
          name = "tokyonight";
          style = "night";
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
            norg
            pkgs.vimPlugins.nvim-treesitter-parsers.nu
            pkgs.vimPlugins.nvim-treesitter-parsers.kdl
          ];
        };

        binds = {
          whichKey.enable = true;
          cheatsheet.enable = true;
        };

        telescope.enable = true;

        git = {
          enable = true;
          gitsigns = {
            enable = true;
            codeActions.enable = false; # throws an annoying debug message
          };
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
            leap = {
              enable = true;
              mappings = {
                leapForwardTo = "s";
                leapBackwardTo = "S";
              };
            };
            precognition.enable = false;
          };

          images = {
            image-nvim.enable = false;
          };
        };

        notes = {
          obsidian = {
            enable = true;
            setupOpts = {
              workspaces = [
                {
                  name = "notes";
                  path = "~/Documents/Nextcloud/Notes/markdown";
                }
              ];
              templates = {
                folder = "templates";
                date_format = "%Y-%m-%d-%a";
                time_format = "%H:%M";
              };
            };
          };
          neorg = {
            enable = true;
            treesitter.enable = false;
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
              # go = ["90 130"];
            };
          };
        };

        assistant = {
          avante-nvim.enable = true;
          chatgpt.enable = false;
          codecompanion-nvim = {
            enable = true;
            setupOpts = {
              strategies = {
                chat = {
                  adapter = "ollama";
                };
                inline = {
                  adapter = "ollama";
                };
                cmd = {
                  adapter = "ollama";
                };
              };
            };
          };
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

        extraPlugins = {
          ghost-nvim = {
            package = pkgs.vimUtils.buildVimPlugin {
              name = "ghost-nvim";
              src = pkgs.fetchFromGitHub {
                owner = "subnut";
                repo = "nvim-ghost.nvim";
                rev = "v0.5.4";
                hash = "sha256-XldDgPqVeIfUjaRLVUMp88eHBHLzoVgOmT3gupPs+ao=";
              };
              setup = ''
                require('ghost').setup(),
              '';
            };
          };
        };

        lazy.plugins = with pkgs.vimPlugins; {
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
            package = quarto-nvim;
          };
          ${lazygit-nvim.pname} = {
            lazy = true;
            cmd = [
              "LazyGit"
              "LazyGitConfig"
              "LazyGitCurrentFile"
              "LazyGitFilter"
              "LazyGitFilterCurrentFile"
            ];
            package = lazygit-nvim;
            setupOpts = {
              open_cmd = "zen %s";
            };
            keys = [
              {
                key = "<leader>lg";
                action = "<cmd>LazyGit<cr>";
                mode = "n";
              }
            ];
          };
          ${typst-preview-nvim.pname} = {
            lazy = true;
            cmd = "TypstPreview";
            package = typst-preview-nvim;
            setupOpts = {
              open_cmd = "zen %s";
            };
          };
          ${harpoon2.pname} = {
            lazy = true;
            cmd = "TypstPreview";
            package = harpoon2;
            keys = [
              {
                key = "<leader>ad";
                mode = "n";
                action = '':lua require("harpoon"):list():add()<CR>'';
                silent = true;
                desc = "Harpoon add";
              }
              {
                key = "<leader>as";
                mode = "n";
                action = '':lua require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())<CR>'';
                silent = true;
                desc = "Harpoon switch";
              }
            ];
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
