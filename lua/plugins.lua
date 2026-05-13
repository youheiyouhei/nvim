vim.loader.enable()

-- TSUpdate on install/update
vim.api.nvim_create_autocmd("User", {
  pattern = "PackChanged",
  callback = function(ev)
    if ev.data.name == "nvim-treesitter" and ev.data.kind ~= "delete" then
      vim.cmd("TSUpdate")
    end
  end,
})

-- プラグイン定義（依存プラグインを先に記述）
vim.pack.add({
  "https://github.com/folke/tokyonight.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/ibhagwan/fzf-lua",
  "https://github.com/windwp/nvim-autopairs",
  "https://github.com/williamboman/mason.nvim",
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/tamago324/lir.nvim", "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/github/copilot.vim",
  "https://github.com/kosayoda/nvim-lightbulb",
  "https://github.com/folke/snacks.nvim",
  "https://github.com/coder/claudecode.nvim",
  "https://github.com/MeanderingProgrammer/render-markdown.nvim",
})

-- Colorscheme
vim.cmd.colorscheme("tokyonight")

-- nvim-web-devicons
require("nvim-web-devicons").set_icon({
  lir_folder_icon = {
    icon = "",
    color = "#7ebae4",
    name = "LirFolderNode",
  },
})

-- nvim-autopairs
require("nvim-autopairs").setup({})

-- mason
require("mason").setup()

-- gitsigns
require("gitsigns").setup()

-- lir.nvim
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

-- nvim-treesitter
require("nvim-treesitter").setup({
  ensure_installed = { "go", "lua", "gomod", "markdown", "markdown_inline", "sql", "typescript", "vue", "json", "javascript", "kotlin", "php" },
  sync_install = false,
  auto_install = true,
})

-- nvim-lightbulb
require("nvim-lightbulb").setup({
  autocmd = { enabled = true },
  sign = { enabled = false },
  virtual_text = { enabled = true },
})

-- claudecode
require("claudecode").setup({})

-- render-markdown
require("render-markdown").setup({
  completions = { lsp = { enabled = true } },
})
