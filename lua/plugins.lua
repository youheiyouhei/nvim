vim.cmd([[packadd packer.nvim]])

require("packer").startup(function(use)
	use("wbthomason/packer.nvim")
	use({ "ibhagwan/fzf-lua", requires = { "kyazdani42/nvim-web-devicons" } })
	use("kyazdani42/nvim-web-devicons")
	use("terrortylor/nvim-comment")
	use("nvim-lualine/lualine.nvim")
	use("lambdalisue/fern.vim")
	use("neovim/nvim-lspconfig")
	use("hrsh7th/nvim-cmp")
	use("hrsh7th/cmp-path")
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/cmp-cmdline")
	use("hrsh7th/cmp-nvim-lsp")
	use("windwp/nvim-autopairs")
	use("dcampos/nvim-snippy")
	use("dcampos/cmp-snippy")
	use("williamboman/mason.nvim")
	use("williamboman/mason-lspconfig.nvim")
	use("Pocco81/auto-save.nvim")
	use("folke/tokyonight.nvim")
	use("lewis6991/gitsigns.nvim")
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
	})
end)

vim.cmd([[colorscheme tokyonight]])
