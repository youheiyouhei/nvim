vim.cmd([[packadd packer.nvim]])

require("packer").startup(function(use)
  use("wbthomason/packer.nvim")
  use({ "ibhagwan/fzf-lua", requires = { "kyazdani42/nvim-web-devicons" } })
  use("kyazdani42/nvim-web-devicons")
  use("terrortylor/nvim-comment")
  use("nvim-lualine/lualine.nvim")
  use("neovim/nvim-lspconfig")
  use("hrsh7th/nvim-cmp")
  use("hrsh7th/cmp-path")
  use("hrsh7th/cmp-buffer")
  use("hrsh7th/cmp-cmdline")
  use("hrsh7th/cmp-nvim-lsp")
  use("windwp/nvim-autopairs")
  use("williamboman/mason.nvim")
  use("williamboman/mason-lspconfig.nvim")
  use("Pocco81/auto-save.nvim")
  use("folke/tokyonight.nvim")
  use("lewis6991/gitsigns.nvim")
  use("tamago324/lir.nvim")
  use("nvim-lua/plenary.nvim")
  use({
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
  })
  use("jose-elias-alvarez/null-ls.nvim")
  use("MunifTanjim/nui.nvim")
  use("github/copilot.vim")
  use({
    "kosayoda/nvim-lightbulb",
    config = function()
      require("nvim-lightbulb").setup({
        autocmd = { enabled = true },
        -- 行番号ではなく行末に出す
        sign = { enabled = false },
        virtual_text = { enabled = true },
      })
    end,
  })
  use({
    "aznhe21/actions-preview.nvim",
    config = function()
      -- vim.keymap.set({ "v", "n" }, "gf", require("actions-preview").code_actions)
      vim.keymap.set({ "v", "n" }, "<leader>ca", require("actions-preview").code_actions)
    end,
  })
  use("folke/snacks.nvim")
  use({
    "coder/claudecode.nvim",
    requires = { "folke/snacks.nvim" },
    config = function()
      require("claudecode").setup({})
    end,
  })
end)

vim.cmd([[colorscheme tokyonight]])
