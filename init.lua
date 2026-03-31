require("plugins")
require("base")
require("maps")

vim.api.nvim_set_keymap(
  "n",
  "<leader>g",
  "<cmd>lua require('fzf-lua').git_files()<CR>",
  { noremap = true, silent = true }
)

vim.api.nvim_set_keymap(
  "n",
  "<leader>r",
  "<cmd>lua require('fzf-lua').grep_project()<CR>",
  { noremap = true, silent = true }
)

-- LSP設定（vim.lsp.config API）
vim.lsp.config.ts_ls = {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  root_markers = { "package.json", "tsconfig.json", "jsconfig.json" },
}

vim.lsp.enable("ts_ls")

-- LspAttach: 補完・フォーマット・キーマッピング
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    -- ビルトイン補完を有効化
    if client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
    end

    -- フォーマット on save
    if client:supports_method("textDocument/formatting") then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr })
        end,
      })
    end

    -- キーマッピング
    local opts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, opts)
  end,
})

-- 補完メニューでEnterで確定
vim.keymap.set("i", "<CR>", function()
  if vim.fn.pumvisible() == 1 then
    return "<C-y>"
  end
  return "<CR>"
end, { expr = true })

-- プラグイン設定（初回はプラグイン未インストールのためpcallで保護）
local ok, _ = pcall(function()
  require("mason").setup()

  require("lualine").setup()
  require("auto-save").setup({})
  require("nvim-autopairs").setup({})
  require("gitsigns").setup()
  -- nvim-treesitter (new API)
  require("nvim-treesitter").setup({
    ensure_installed = { "go", "lua", "gomod", "markdown", "sql", "typescript", "vue", "json", "javascript" },
    sync_install = false,
    auto_install = true,
  })
  vim.treesitter.start = vim.treesitter.start or function() end

  local actions = require("lir.actions")
  local mark_actions = require("lir.mark.actions")
  local clipboard_actions = require("lir.clipboard.actions")

  require("lir").setup({
    show_hidden_files = false,
    devicons = {
      enable = false,
    },
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
      -- use visual mode
      vim.api.nvim_buf_set_keymap(
        0,
        "x",
        "J",
        ':<C-u>lua require"lir.mark.actions".toggle_mark("v")<CR>',
        { noremap = true, silent = true }
      )

      -- echo cwd
      vim.api.nvim_echo({ { vim.fn.expand("%:p"), "Normal" } }, false, {})
    end,
  })
  vim.api.nvim_set_keymap("n", "<C-n>", '<cmd>lua require("lir.float").toggle()<cr>', { noremap = true })

  -- custom folder icon
  require("nvim-web-devicons").set_icon({
    lir_folder_icon = {
      icon = "",
      color = "#7ebae4",
      name = "LirFolderNode",
    },
  })
end)

if not ok then
  vim.notify("Some plugins are not yet installed. Run :PackerSync", vim.log.levels.WARN)
end

vim.cmd("autocmd FileType go setlocal noexpandtab")
vim.cmd("autocmd FileType go setlocal tabstop=4")
vim.cmd("autocmd FileType go setlocal shiftwidth=4")

vim.opt.completeopt = "menu,menuone,noselect"

-- Claude Code
vim.api.nvim_set_keymap(
  "n",
  "<leader>cc",
  "<cmd>ClaudeCode<CR>",
  { noremap = true, silent = true, desc = "Toggle Claude Code" }
)

vim.api.nvim_set_keymap(
  "v",
  "<leader>cs",
  "<cmd>ClaudeCodeSend<CR>",
  { noremap = true, silent = true, desc = "Send to Claude" }
)

vim.api.nvim_set_keymap(
  "n",
  "<leader>cca",
  "<cmd>ClaudeCodeDiffAccept<CR>",
  { noremap = true, silent = true, desc = "Accept Claude diff" }
)

vim.api.nvim_set_keymap(
  "n",
  "<leader>ccd",
  "<cmd>ClaudeCodeDiffDeny<CR>",
  { noremap = true, silent = true, desc = "Deny Claude diff" }
)
