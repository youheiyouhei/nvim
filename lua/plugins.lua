local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("tokyonight")
    end,
  },
  { "ibhagwan/fzf-lua", dependencies = { "nvim-tree/nvim-web-devicons" } },
  {
    "nvim-tree/nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").set_icon({
        lir_folder_icon = {
          icon = "",
          color = "#7ebae4",
          name = "LirFolderNode",
        },
      })
    end,
  },
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup({})
    end,
  },
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },
  {
    "tamago324/lir.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local actions = require("lir.actions")
      local mark_actions = require("lir.mark.actions")
      local clipboard_actions = require("lir.clipboard.actions")

      require("lir").setup({
        show_hidden_files = false,
        devicons = { enable = false },
        mappings = {
          ["l"] = actions.edit,
          ["<C-s>"] = actions.split,
          ["<C-v>"] = actions.vsplit,
          ["<C-t>"] = actions.tabedit,
          ["h"] = actions.up,
          ["q"] = actions.quit,
          ["K"] = actions.mkdir,
          ["N"] = actions.newfile,
          ["R"] = actions.rename,
          ["@"] = actions.cd,
          ["Y"] = actions.yank_path,
          ["."] = actions.toggle_show_hidden,
          ["D"] = actions.delete,
          ["J"] = function()
            mark_actions.toggle_mark()
            vim.cmd("normal! j")
          end,
          ["C"] = clipboard_actions.copy,
          ["X"] = clipboard_actions.cut,
          ["P"] = clipboard_actions.paste,
        },
        float = {
          winblend = 0,
          curdir_window = {
            enable = false,
            highlight_dirname = false,
          },
        },
        hide_cursor = true,
        on_init = function()
          vim.api.nvim_buf_set_keymap(
            0, "x", "J",
            ':<C-u>lua require"lir.mark.actions".toggle_mark("v")<CR>',
            { noremap = true, silent = true }
          )
          vim.api.nvim_echo({ { vim.fn.expand("%:p"), "Normal" } }, false, {})
        end,
      })

      vim.keymap.set("n", "<C-n>", function()
        require("lir.float").toggle()
      end)
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({
        ensure_installed = { "go", "lua", "gomod", "markdown", "sql", "typescript", "vue", "json", "javascript" },
        sync_install = false,
        auto_install = true,
      })
    end,
  },
  "github/copilot.vim",
  {
    "kosayoda/nvim-lightbulb",
    config = function()
      require("nvim-lightbulb").setup({
        autocmd = { enabled = true },
        sign = { enabled = false },
        virtual_text = { enabled = true },
      })
    end,
  },
  "folke/snacks.nvim",
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    config = function()
      require("claudecode").setup({})
    end,
  },
})
