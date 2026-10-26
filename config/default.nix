{ pkgs, pluginSrcs, ... }:

{
    globals.mapleader = "\\";
    globals.maplocalleader = " ";
    
    plugins = {
        #UI
        which-key = {
            enable = true;
            settings = {
                delay = 100;
            };
        };
        rainbow-delimiters = {
            enable = true;
            settings = {
                strategy = {
                    "" = "rainbow-delimiters.strategy.global";
                    vim = "rainbow-delimiters.strategy.local";
                };
                query = {
                    "" = "rainbow-delimiters";
                    lua = "rainbow-blocks";
                };
                priority = {
                    "" = 110;
                    lua = 210;
                };
                highlight = [
                    "RainbowDelimiterWhite"
                    "RainbowDelimiterBlue"
                    "RainbowDelimiterRed"
                    "RainbowDelimiterOrange"
                    "RainbowDelimiterYellow"
                    "RainbowDelimiterGreen"
                    "RainbowDelimiterCyan"
                ];
            };
        };
        comment.enable = true;
        twilight = {
            enable = true;
            settings = {
                context = 60;
                treesitter = true;
                expand = [
                    "function"
                    "method"
                    "table"
                    "if_statement"
                ];
            };
        };
        zen-mode = {
            enable = true;
            settings = {
                window = {
                    backdrop = 0.5;
                    width = 0.6;
                    height = 1.0;
                    options = {
                        signcolumn = "no";
                        number = false;
                    };
                };
                plugins = {
                    twilight.enabled = false;
                    gitsigns.enabled = false;
                    todo.enabled = false;
                };
            };
        };
        toggleterm = {
            enable = true;
            settings.close_on_exit = true;
        };
        todo-comments = {
            enable = true;
            settings.keywords = {
                FIX = { icon = ""; color = "error"; alt = [ "FIXME" "BUG" "FIXIT" "ISSUE" "REMOVE" ]; };
                TODO = { icon = ""; color = "info"; };
                HACK = { icon = ""; color = "warning"; };
                WARN = { icon = ""; color = "warning"; alt = [ "WARNING" "XXX" ]; };
                PERF = { icon = ""; color = "default"; alt = [ "OPTIM" "PERFORMANCE" "OPTIMIZE" ]; };
                NOTE = { icon = ""; color = "hint"; alt = [ "INFO" ]; };
                REDO = { icon = "?"; color = "warning"; alt = [ "REFACTOR" "REMAKE" ]; };
            };
        };
        web-devicons.enable = true;
        telescope = {
            enable = true;
            settings = {
                defaults = {
                    file_ignore_patterns = [
                        "node_modules" "build" "%.git/" "x64" ".git"
                    ];
                };
            };
            extensions = {
                file-browser.enable = true;
                # telescope-tabs.enable = true;
            };
        };
        nvim-tree = {
            enable = true;
            settings = {
                sync_root_with_cwd = true;
                disable_netrw = true;
                hijack_netrw = true;
                view = { width = 30; };
                filters = { dotfiles = true; };
                git = { enable = false; };
                on_attach = {
                    __raw = ''
                        function(bufnr)
                        local api = require("nvim-tree.api")
                        api.config.mappings.default_on_attach(bufnr)
                        vim.keymap.set("n", "<C-t>", api.tree.toggle, { 
                            buffer = bufnr, 
                            noremap = true, 
                            silent = true,
                            desc = "Toggle nvim-tree"
                        })
                        end
                    '';
                };
            };
        };

        #UTILS
        fugitive.enable = true;
        undotree.enable = true;

        #MINI
        mini = {
            enable = true;
            modules = {
                surround = {};
                sessions = {
                    autowrite = true;
                };
                map = {};
                starter = {};
            };
        };

        #COLOR PICKER
        ccc = {
            enable = true;
            settings.highlighter = {
                auto_enable = true;
                lsp = true;
            };
        };

        treesitter = {
            enable = true;
            settings.highlight.enable = true;
        };
        trouble = {
            enable = true;
        };
        lspkind = {
            enable = true;
            settings = {
                mode = "symbol_text";
            };
        };
        lazydev = {
            enable = true;
        };
        lsp = {
            enable = true;
            servers = {
                clangd = {
                    enable = true;
                    cmd = [
                        "clangd"
                        "--background-index"
                        "--clang-tidy"
                        "--completion-style=detailed"
                        "--pch-storage=memory"
                        "--query-driver=/nix/store/*/bin/clang++,/nix/store/*/bin/g++"
                    ];
                    filetypes = [ "c" "cpp" "objc" "h" "hpp" "objcpp" "cuda" "proto" ];
                };
                lua_ls = {
                    enable = true;
                    settings = {
                        Lua = {
                            workspace = {
                                checkThirdParty = false;
                            };
                            completion = {
                                callSnippet = "Replace";
                            };
                            diagnostics = {
                                globals = [ "vim" ];
                            };
                        };
                    };
                };
                nixd.enable = true;
                cmake.enable = true;
            };
            keymaps = {
                lspBuf = {
                    K = "hover";
                    gd = "definition";
                    gD = "declaration";
                    gi = "implementation";
                    go = "type_definition";
                    gr = "references";
                    "<F2>" = "rename";
                    "<F4>" = "code_action";
                };
                diagnostic = {
                    gl = "open_float";
                    "[d" = "goto_prev";
                    "]d" = "goto_next";
                };
            };
        };
        cmp = {
            enable = true;
            settings = {
                performance.max_view_entries = 10; #show only n options
                completion.keyword_length = 2; #trigger only on second character typed
                snippet.expand = ''
                    function(args)
                    vim.fn["vsnip#anonymous"](args.body)
                    end
                    '';
                mapping = {
                    "<Tab>"     = "cmp.mapping.select_next_item()";
                    "<S-Tab>"   = "cmp.mapping.select_prev_item()";
                    "<CR>"      = "cmp.mapping.confirm({ select = true })";
                    "<C-Space>" = "cmp.mapping.complete()";
                };
                sources = [
                    { name = "nvim_lsp"; }
                    { name = "vsnip"; }
                    { name = "lazydev"; }
                    {
                        name = "buffer";
                        max_item_count = 5;
                        option.get_bufnrs.__raw = "function() return { vim.api.nvim_get_current_buf() } end";
                    }
                    { name = "path"; }
                ];
            };
        };
        lsp-signature = {
            enable = true;
            settings = {
                bind = true;
                floating_window = false;
                floating_window_above_cur_line = true;
                hint_enable = true;
                hint_prefix = {
                    above   = "↙ ";
                    current = "← ";
                    below   = "↖ ";
                };
                handler_opts.border = "single";
                max_width = 80;
                max_height = 8;
                transparency = 10;
                time_interval = 50;
                floating_window_off_y = -3;
            };
        };
        airline = {
            enable = true;
            settings = {
                theme = "vs2022";
                powerline_fonts = 1;
                left_sep = "";
                right_sep = "";
                section_b = "%f";
                section_c = "";
                section_x = "";
                section_y = "";
                section_z = "%l%c";
                section_warning = "";
                section_error = "";
                skip_empty_sections = 0;
                symbols = {
                    readonly = "";  
                };
                exclude_filetypes = [
                    "CakeLog"
                    "log"
                    "Scratch"
                    "notify"
                    "packer"
                    "fugitive"
                    "checkhealth"
                    "lspinfo"
                    "git"
                    "TelescopePrompt"
                ];
            };
        };
        nui.enable = true;
    };

    keymaps = [
        { mode = "n"; key = "<leader>ff"; action = "<cmd>Telescope find_files<cr>"; options = { noremap = true; silent = true; }; }
        { mode = "n"; key = "<leader>fg"; action = "<cmd>Telescope live_grep<cr>"; options = { noremap = true; silent = true; }; }
        { mode = "n"; key = "<leader>fb"; action = "<cmd>Telescope buffers<cr>"; options = { noremap = true; silent = true; }; }
        { mode = "n"; key = "<leader>fh"; action = "<cmd>Telescope help_tags<cr>"; options = { noremap = true; silent = true; }; }
        { mode = "n"; key = "<leader>ft"; action = "<cmd>Telescope telescope-tabs list_tabs<cr>"; options = { noremap = true; silent = true; }; }
        { mode = "n"; key = "<leader>fl"; action = "<cmd>Telescope file_browser<cr>"; options = { noremap = true; silent = true; }; }
        { mode = "n"; key = "<leader>fa"; action = "<cmd>Telescope file_browser path=%:p:h select_buffer=true<cr>"; options = { noremap = true; silent = true; }; }
    ];

    extraPlugins = with pkgs.vimPlugins; [
        nvim-origami
        vim-devicons
        nvim-notify

        tokyonight-nvim
        gruvbox-nvim
        catppuccin-nvim
        bamboo-nvim
        fluoromachine-nvim
        darkearth-nvim
        oxocarbon-nvim
        styler-nvim

        vim-vsnip
        cmp-vsnip
        cmp-path
        cmp-calc

        (pkgs.vimUtils.buildVimPlugin { name = "automkdir-nvim"; src = pluginSrcs.automkdir-nvim; })
        (pkgs.vimUtils.buildVimPlugin { name = "visimatch-nvim"; src = pluginSrcs.visimatch-nvim; })
        (pkgs.vimUtils.buildVimPlugin { name = "vs2022-nvim";    src = pluginSrcs.vs2022-nvim; })
    ];

    extraConfigLua = ''
        local nvim_dir = vim.fn.expand("~/.config/nvim")
        local config_file = nvim_dir .. "/config.lua"

        if vim.fn.filereadable(config_file) == 1 then
            package.path = package.path .. ";" .. nvim_dir .. "/lua/?.lua;" .. nvim_dir .. "/lua/?/init.lua"
            dofile(config_file)
        end
        
        --------------------------------------------------------------------------------
        --PREFERENCES
        --------------------------------------------------------------------------------

        --vs2022 Theme
        vim.cmd.colorscheme "vs2022"

        --config vars
        local target_cmdheight = 1

        --set basic vim options
        vim.o.number = true --enable number line
        vim.o.relativenumber = true --enable relative number line
        vim.o.mouse = "a" --enable mouse in all modes
        vim.o.scrolloff = 10 --set scroll offset
        vim.o.autoindent = true --auto indenting
        vim.o.tabstop = 4
        vim.o.shiftwidth = 4
        vim.o.expandtab = true
        vim.o.termguicolors = true
        vim.o.swapfile = false;
        vim.o.undofile = true;
        vim.o.undodir = vim.fn.stdpath("cache") .. "/undo"
        vim.o.guifont = "Fira Mono:h16"
        vim.o.wrap = false
        vim.o.showtabline = 1
        vim.o.lazyredraw = true
        vim.o.incsearch = true
        vim.o.hlsearch = false
        vim.o.cmdheight = target_cmdheight
        vim.g.lsp_semantic_tokens_priority = 1000

        --folding
        vim.o.foldenable = true
        vim.o.foldmethod = 'indent'
        vim.o.foldlevel = 99
        vim.o.foldlevelstart = 99
        vim.o.foldnestmax = 5 --prevent deeper folds
        vim.o.foldtext = [[v:lua.vim.fn.getline(vim.v.foldstart) .. "  ...  (" .. (vim.v.foldend - vim.v.foldstart + 1) .. " lines)"]]
        vim.opt.fillchars:append({ fold = " " })

        --neovide settings
        vim.g.neovide_scale_factor = 0.6

        --set file icons
        vim.cmd [[

            let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols = {} " needed
            let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['cpp'] = "\ue646"

            let g:WebDevIconsUnicodeGlyphDoubleWidth = 1

        ]]

        --stop auto comments when newlining
        vim.api.nvim_create_autocmd("BufEnter", {
            callback = function()
                vim.opt.formatoptions:remove({ "r", "o" })
            end,
        })

        --force cmd height
        vim.api.nvim_create_autocmd({ "CmdlineLeave", "TabEnter", "BufEnter", "VimResized" }, {
            callback = function()
                if vim.opt.cmdheight:get() ~= target_cmdheight then
                    vim.opt.cmdheight = target_cmdheight
                end
            end,
        })

        --stop sessions from forcing options on buffers
        vim.o.sessionoptions = "blank,buffers,curdir,folds,globals,help,tabpages,winsize,winpos,terminal,localoptions"
        vim.opt.sessionoptions:remove({ "options", "folds" }) --strip options and folds

        --------------------------------------------------------------------------------
        --KEYMAPS
        --------------------------------------------------------------------------------

        --mini sessions mappings
        local function get_ms()
            return require('mini.sessions')
        end
        local function default_name()
            return vim.fn.getcwd():gsub('[/:]', '%%')
        end

        vim.api.nvim_create_user_command('ProjectCreate', function(opts)
            local ms = get_ms()
            local name = opts.args ~= "" and opts.args or default_name()
            ms.write(name, { force = true })
        end, { nargs = '?' })

        vim.api.nvim_create_user_command('ProjectRead', function(opts)
            get_ms().read(opts.args ~= "" and opts.args or nil, { force = true })
        end, { nargs = '?' })

        vim.api.nvim_create_user_command('ProjectDelete', function(opts)
            get_ms().delete(opts.args ~= "" and opts.args or nil)
        end, { nargs = '?' })

        --scratch buffer
        vim.api.nvim_create_user_command('Scratch', function()
            vim.cmd('enew')
            vim.bo.buftype = 'nofile'
            vim.bo.bufhidden = 'wipe'
            vim.bo.swapfile = false
        end, {})

        --undo tree
        vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)

        --zen mode
        vim.keymap.set('n', 'Z', "<cmd>ZenMode<cr>")

        --twilight mode
        vim.keymap.set('n', 'T', "<cmd>Twilight<cr>")

        --moving lines
        vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
        vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
        
        --remove trailing whitespace
        vim.keymap.set("v", '<leader>rw', '<cmd>\'<,\'>s/\\s\\+$//e<cr>')

        --centering on jumps
        vim.keymap.set("n", "<C-d>", "<C-d>zz")
        vim.keymap.set("n", "<C-u>", "<C-u>zz")
        vim.keymap.set("n", "n", "nzzzv")
        vim.keymap.set("n", "N", "Nzzzv")
        
        --yank to system clipboard
        vim.keymap.set("n", "<leader>y", "\"+y")
        vim.keymap.set("v", "<leader>y", "\"+y")
        vim.keymap.set("n", "<leader>Y", "\"+Y")

        --paste from system clipboard
        vim.keymap.set("n", "<leader>p", "\"+p=`]")
        vim.keymap.set("v", "<leader>p", "\"+p=`]")
        vim.keymap.set("n", "<leader>P", "\"+P=`]")
        
        --delete without yank
        vim.keymap.set("n", "<leader>d", "\"_d")
        vim.keymap.set("v", "<leader>d", "\"_d")

        --nvim tree
        vim.keymap.set("n", "<leader>n", "<cmd>NvimTreeFocus<cr>", { noremap = true, silent = true})
        vim.keymap.set("n", "<C-n>", "<cmd>NvimTreeOpen<cr>", { noremap = true, silent = true})
        vim.keymap.set("n", "<C-t>", "<cmd>NvimTreeToggle<cr>", { noremap = true, silent = true})

        --remove help menu
        vim.keymap.set('n', '<F1>', '<Nop>')
        vim.keymap.set('i', '<F1>', '<Nop>')
        vim.keymap.set('v', '<F1>', '<Nop>')

        --toggling airline tabline
        vim.keymap.set("n", "<leader>q", function()
          if vim.o.showtabline == 0 then
            vim.o.showtabline = 2
            vim.notify("Tabline shown", vim.log.levels.INFO)
          else
            vim.o.showtabline = 0
            vim.notify("Tabline hidden", vim.log.levels.INFO)
          end
        end, { noremap = true, silent = true })

        --tab controls
        function try_tab(tabnum)
            local tabcount = vim.fn.tabpagenr('$')
            if tabnum <= tabcount then
                vim.cmd('tabn ' .. tabnum)
            else --create new tabs to this amount
                vim.cmd('tabn $')
                for _ = tabcount + 1, tabnum do
                    vim.cmd('tabnew')
                    vim.cmd('tabn $')
                end
                vim.cmd('tabn ' .. tabnum)
            end
        end

        vim.keymap.set('n', 'gt', ':tabnext<CR>')
        vim.keymap.set('n', 'gT', ':tabprev<CR>')
        vim.keymap.set('n', '<leader>1', function() try_tab(1) end)
        vim.keymap.set('n', '<leader>2', function() try_tab(2) end)
        vim.keymap.set('n', '<leader>3', function() try_tab(3) end)
        vim.keymap.set('n', '<leader>4', function() try_tab(4) end)
        vim.keymap.set('n', '<leader>5', function() try_tab(5) end)
        vim.keymap.set('n', '<leader>6', function() try_tab(6) end)
        vim.keymap.set('n', '<leader>7', function() try_tab(7) end)
        vim.keymap.set('n', '<leader>8', function() try_tab(8) end)
        vim.keymap.set('n', '<leader>9', function() try_tab(9) end)
        vim.keymap.set('n', '<leader>0', function() try_tab(10) end)

        vim.keymap.set('n', '<leader>sr', require('telescope.builtin').lsp_references, { noremap = true, silent = true })
        
        --------------------------------------------------------------------------------
        --SETUP
        --------------------------------------------------------------------------------

        --airline
        vim.g.airline_detect_encoding = 0
        vim.g.airline_detect_fileformat = 0
        vim.g.webdevicons_enable_airline_tabline = 0
        vim.g.webdevicons_enable_airline_statusline = 0

        --tabline
        vim.g["airline#extensions#tabline#enabled"] = 1
        vim.g["airline#extensions#tabline#show_close_button"] = 0
        vim.g["airline#extensions#tabline#tabs_label"] = ""
        vim.g["airline#extensions#tabline#buffers_label"] = ""
        vim.g["airline#extensions#tabline#fnamemod"] = ":t"
        vim.g["airline#extensions#tabline#show_tab_count"] = 0
        vim.g["airline#extensions#tabline#show_buffers"] = 0
        vim.g["airline#extensions#tabline#tab_min_count"] = 0
        vim.g["airline#extensions#tabline#show_splits"] = 0
        vim.g["airline#extensions#tabline#show_tab_nr"] = 0
        vim.g["airline#extensions#tabline#show_tab_type"] = 0
        vim.g["airline#extensions#tabline#left_sep"] = ""
        vim.g["airline#extensions#tabline#left_alt_sep"] = ""
        vim.g["airline#extensions#tabline#right_sep"] = ""
        vim.g["airline#extensions#tabline#right_alt_sep"] = ""

        --diagnostic text overlay
        vim.diagnostic.config({
            virtual_text = true,
            signs = true,
            underline = true,
            update_in_insert = false,
        })

        --highlighting matched text
        require("visimatch").setup({
            hl_group = "Visual",
            chars_lower_limit = 3,
        })

        --default notifier
        vim.notify = require("notify")

        --mini sessions
        require('mini.sessions').setup({
            directory = vim.fn.stdpath('data') .. '/sessions'
        })

        --different styles for different files
        require("styler").setup({
            themes = {
                help = { colorscheme = "catppuccin" },
                html = { colorscheme = "darkearth" },
                lua = { colorscheme = "oxocarbon" },
                json = { colorscheme = "darkearth" },
                js = { colorscheme = "gruvbox" },
                text = { colorscheme = "darkearth" },
                markdown = { colorscheme = "darkearth" },
            },
        })

        --automkdir
        require('automkdir').setup({})

        --folding
        require('origami').setup({
            autoFold = {
                enabled = false,
                kinds = { "comment", "imports" }, ---@type lsp.FoldingRangeKind[]
            },
        })
    '';

    extraConfigVim = ''
        function! LspSignatureStatus()
        return luaeval('require("lsp_signature").status_line().label or ""')
        endfunction
        let g:airline_section_c = '%{LspSignatureStatus()}'
    '';
}
