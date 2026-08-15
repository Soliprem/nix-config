{
  pkgs,
  flakeInputs,
  ...
}: let
  configRoot = ./..;
in {
  config.vim = {
    repl = {
      conjure.enable = true;
    };
    spellcheck = {
      enable = true;
      programmingWordlist.enable = true;
      languages = [
        "en"
        "it"
      ];
    };
    clipboard = {
      enable = true;
      registers = "unnamedplus";
      providers.wl-copy.enable = true;
    };
    options = {
      shiftwidth = 2;
      conceallevel = 1;
      scrolloff = 1;
    };
    preventJunkFiles = true;
    extraPackages = [pkgs.zk];
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
      inlayHints.enable = true;
      servers = {
        nil.settings.nil = {
          formatting.command = ["alejandra"];
        };
        nixd.settings.nixd = {
          nixpkgs.expr = "import (builtins.getFlake (builtins.toString ./.)).inputs.nixpkgs { }";
          formatting.command = "alejandra";
          options = {
            nixos.expr = ''(builtins.getFlake ${configRoot}).nixosConfigurations.nixos-pc.options'';
          };
        };
      };
      otter-nvim = {
        enable = true;
        setupOpts.buffers.write_to_disk = true;
      };
      trouble.enable = true;
      lspSignature.enable = false; # doesn't work with blink
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
      nim.enable = false;
      java.enable = false;
      svelte.enable = false;
      vala.enable = false;
      qml.enable = false;
      dart.enable = false;
      elixir.enable = false;
      haskell.enable = false;
      nix = {
        enable = true;
        lsp.servers = ["nixd" "nil"];
      };
      markdown.enable = true;
      html.enable = false;
      css.enable = true;
      r = {
        enable = true;
        format.type = ["styler"];
      };
      sql.enable = false;
      typescript = {
        enable = true;
        extraDiagnostics.enable = false;
      };
      go.enable = false;
      zig.enable = false;
      ocaml.enable = false;
      nu.enable = false;
      python = {
        enable = true;
        lsp.servers = ["pyright"];
      };
      lua.enable = true;
      bash.enable = true;
      typst.enable = true;
      julia.enable = true;
      clang = {
        enable = true;
        lsp.servers = ["clangd"];
      };

      rust = {
        enable = true;
        extensions.crates-nvim.enable = true;
      };
    };

    visuals = {
      nvim-web-devicons.enable = true;
      cellular-automaton.enable = false;
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
      };
    };

    # luaConfigRC.basic = ''
    #   vim.g.nvim_ghost_use_script = 1
    #   vim.g.nvim_ghost_python_executable = '${ghosttext-dependencies}/bin/python'
    # '';

    theme = {
      enable = true;
      name = "gruber-darker";
      style = "dark";
      transparent = false;
    };

    autopairs.nvim-autopairs.enable = true;

    autocomplete.blink-cmp = {
      enable = true;
      friendly-snippets.enable = true;
      setupOpts = {
        signature.enabled = true;
        cmdline = {
          keymap.preset = "cmdline";
          completion.menu.auto_show = true;
        };
      };
    };
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
      grammars = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        nu
        kdl
        rnoweb
        yaml
        markdown
        markdown_inline
        r
        hyprlang
        toml
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
      alpha = {
        enable = true;
        theme = "theta";
      };
    };

    notify = {
      nvim-notify.enable = true;
    };

    projects = {
      project-nvim.enable = false;
    };

    utility = {
      oil-nvim.enable = true;
      csvview.enable = true;
      undotree.enable = true;
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
        img-clip.enable = true;
      };
    };

    notes = {
      obsidian = {
        enable = false;
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
          legacy_commands = false;
        };
      };
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
      todo-comments.enable = true;
    };

    terminal = {
      toggleterm = {
        enable = false;
        lazygit.enable = true;
      };
    };

    ui = {
      borders.enable = true;
      noice.enable = false;
      ui2.enable = true;
      colorizer.enable = true;
      modes-nvim.enable = false; # the theme looks terrible with catppuccin
      illuminate.enable = true;
      fastaction.enable = false;
      breadcrumbs = {
        enable = false;
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
      avante-nvim = {
        enable = false;
        setupOpts = {
          provider = "ollama";
          providers = {
            openai = {
              endpoint = "https://api.openai.com/v1";
              model = "gemma4"; # your desired model (or use gpt-4o, etc.)
              timeout = 30000; # Timeout in milliseconds, increase this for reasoning models
              extra_request_body = {
                temperature = 0;
                max_completion_tokens = 8192; # Increase this to include reasoning tokens (for reasoning models)
                reasoning_effort = "medium"; # low|medium|high, only used for reasoning models
              };
            };
            groq = {
              __inherited_from = "openai";
              api_key_name = "groq";
              endpoint = "https://api.groq.com/openai/v1/";
              model = "llama-3.3-70b-versatile";
              # disable_tools = true;
              # extra_request_body = {
              #   temperature = 1;
              #   max_tokens = 32768; # remember to increase this value, otherwise it will stop generating halfway
              # };
            };
            ollama = {
              endpoint = "http://127.0.0.1:11434";
              model = "gemma4:latest";
            };
          };
        };
      };
      chatgpt.enable = false;
      codecompanion-nvim = {
        enable = false;
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
    };

    lazy.plugins = with pkgs.vimPlugins; {
      "R-nvim" = {
        lazy = true;
        event = ["UIEnter"];
        ft = ["markdown"];
        package = pkgs.vimUtils.buildVimPlugin {
          name = "R-nvim";
          pname = "R-nvim";
          src = flakeInputs.r-nvim;
          doCheck = false;
        };
        setupModule = "r";
      };
      "neowiki.nvim" = {
        lazy = true;
        event = ["UIEnter"];
        ft = ["markdown"];
        package = pkgs.vimUtils.buildVimPlugin {
          name = "neowiki-nvim";
          pname = "neowiki.nvim";
          src = flakeInputs.neowiki-nvim;
          doCheck = false;
        };
        setupModule = "neowiki";
        keys = [
          {
            key = "<leader>/";
            mode = "n";
            action = ":Cheatsheet<cr>";
            silent = true;
            desc = "Cheatsheet";
          }
          {
            key = "<leader>ww";
            mode = "n";
            action = ":lua require('neowiki').open_wiki()<cr>";
            silent = true;
            desc = "Open Wiki";
          }
          {
            key = "<leader>wW";
            mode = "n";
            action = ":lua require('neowiki').open_wiki_floating()<cr>";
            silent = true;
            desc = "Open Floating Wiki";
          }
          {
            key = "<leader>wT";
            mode = "n";
            action = ":lua require('neowiki').open_wiki_new_tab()<cr>";
            silent = true;
            desc = "Open Wiki in Tab";
          }
        ];
        setupOpts = {
          discover_nested_roots = true;
          wiki_dirs = [
            {
              name = "notes";
              path = "~/Documents/Nextcloud/Notes/markdown/";
            }
          ];
        };
      };
      ${zk-nvim.pname} = {
        lazy = true;
        package = zk-nvim;
        setupModule = "zk";
        setupOpts = {
          picker = "telescope";
          lsp = {
            config = {
              name = "zk";
              cmd = [
                "zk"
                "lsp"
              ];
              filetypes = ["markdown"];
            };
            auto_attach.enabled = true;
          };
          tags.multi_select_strategy = "AND";
        };
        cmd = [
          "ZkBacklinks"
          "ZkBuffers"
          "ZkCd"
          "ZkIndex"
          "ZkInsertLink"
          "ZkInsertLinkAtSelection"
          "ZkLinks"
          "ZkMatch"
          "ZkNew"
          "ZkNewFromContentSelection"
          "ZkNewFromTitleSelection"
          "ZkNotes"
          "ZkTags"
        ];
        ft = ["markdown"];
        keys = [
          {
            key = "<leader>zi";
            mode = "n";
            action = ":ZkIndex<cr>";
            silent = true;
            desc = "Zk index notebook";
          }
          {
            key = "<leader>zn";
            mode = "n";
            action = ":ZkNew<cr>";
            silent = true;
            desc = "Zk new note";
          }
          {
            key = "<leader>znt";
            mode = "x";
            action = ":'<,'>ZkNewFromTitleSelection<cr>";
            silent = true;
            desc = "Zk new from title";
          }
          {
            key = "<leader>znc";
            mode = "x";
            action = ":'<,'>ZkNewFromContentSelection<cr>";
            silent = true;
            desc = "Zk new from content";
          }
          {
            key = "<leader>zc";
            mode = "n";
            action = ":ZkCd<cr>";
            silent = true;
            desc = "Zk cd notebook";
          }
          {
            key = "<leader>z/";
            mode = "n";
            action = ":ZkNotes<cr>";
            silent = true;
            desc = "Zk notes";
          }
          {
            key = "<leader>zb";
            mode = "n";
            action = ":ZkBuffers<cr>";
            silent = true;
            desc = "Zk note buffers";
          }
          {
            key = "<leader>zlb";
            mode = "n";
            action = ":ZkBacklinks<cr>";
            silent = true;
            desc = "Zk backlinks";
          }
          {
            key = "<leader>zll";
            mode = "n";
            action = ":ZkLinks<cr>";
            silent = true;
            desc = "Zk links";
          }
          {
            key = "<leader>zli";
            mode = "n";
            action = ":ZkInsertLink<cr>";
            silent = true;
            desc = "Zk insert link";
          }
          {
            key = "<leader>zli";
            mode = "x";
            action = ":'<,'>ZkInsertLinkAtSelection<cr>";
            silent = true;
            desc = "Zk link selection";
          }
          {
            key = "<leader>zt";
            mode = "n";
            action = ":ZkTags<cr>";
            silent = true;
            desc = "Zk tags";
          }
          {
            key = "<leader>zf";
            mode = "n";
            action = ":ZkNotes { sort = { 'modified' }, match = { vim.fn.input('Search: ') } }<cr>";
            silent = false;
            desc = "Zk search notes";
          }
          {
            key = "<leader>zf";
            mode = "x";
            action = ":'<,'>ZkMatch<cr>";
            silent = true;
            desc = "Zk match selection";
          }
        ];
      };
      ${twilight-nvim.pname} = {
        lazy = true;
        package = twilight-nvim;
        setupModule = "twilight-nvim";
        cmd = ["Twilight"];
        keys = [
          {
            key = "<leader>ut";
            mode = "n";
            action = ":Twilight<CR>";
            silent = true;
            desc = "Toggle Twilight";
          }
        ];
      };
      ${zen-mode-nvim.pname} = {
        lazy = true;
        package = zen-mode-nvim;
        setupModule = "zen-mode-nvim";
        cmd = ["ZenMode"];
        keys = [
          {
            key = "<leader>uz";
            mode = "n";
            action = ":ZenMode<CR>";
            silent = true;
            desc = "Toggle ZenMode";
          }
        ];
      };
      ${eyeliner-nvim.pname} = {
        lazy = true;
        package = eyeliner-nvim;
        event = ["UIEnter"];
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
      };
      ${typst-preview-nvim.pname} = {
        lazy = true;
        cmd = "TypstPreview";
        package = typst-preview-nvim;
        setupOpts = {
          open_cmd = "zen %s";
        };
      };
      ${boole-nvim.pname} = {
        lazy = true;
        event = [
          "BufReadPost"
          "BufNewFile"
        ];
        package = boole-nvim;
        setupModule = "boole";
        setupOpts = {
          mappings = {
            increment = "<c-a>";
            decrement = "<c-x>";
          };
          additions = [
            [
              "Foo"
              "Bar"
            ]
            [
              "tic"
              "tac"
              "toe"
            ]
          ];
          allow_caps_additions = [
            [
              "enable"
              "disable"
            ]
          ];
        };
      };
      ${harpoon2.pname} = {
        lazy = true;
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
        desc = "Look for Files";
      }
      {
        key = "-";
        action = ":Oil<CR>";
        mode = "n";
        silent = true;
        desc = "Open Oil";
      }
      {
        key = "<leader>tc";
        mode = "n";
        action = ":TSContext toggle<CR>";
        silent = true;
        desc = "Toggle Treesitter Context";
      }
      {
        key = "<F5>";
        action = ":UndotreeToggle<CR>";
        mode = "n";
        silent = true;
        desc = "Toggle Undotree";
      }
      {
        key = "j";
        action = "gj";
        mode = [
          "n"
          "x"
          "v"
        ];
        silent = true;
        desc = "Toggle Undotree";
      }
      {
        key = "k";
        action = "gk";
        mode = [
          "n"
          "x"
          "v"
        ];
        silent = true;
        desc = "Toggle Undotree";
      }
      {
        key = "<leader>lc";
        mode = "n";
        lua = true;
        action =
          /*
          lua
          */
          ''
            function()
              require('conform').format({
                lsp_format = "fallback"
              })
            end
          '';
        desc = "format using Conform";
      }
    ];
  };
}
