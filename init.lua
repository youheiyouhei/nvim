require("plugins")
require("base")
require("maps")

vim.keymap.set("n", "<leader>g", function()
  require("fzf-lua").git_files()
end)

vim.keymap.set("n", "<leader>r", function()
  require("fzf-lua").grep_project()
end)

-- LSP有効化（設定は lsp/ ディレクトリ）
vim.lsp.enable("ts_ls")
vim.lsp.enable("kotlin_lsp")
vim.lsp.enable("intelephense")

-- kotlin-lsp: 外部ライブラリ(jar/jrt)へのdefinitionジャンプを復元
-- (参考: https://github.com/Kotlin/kotlin-lsp/issues/44)
vim.api.nvim_create_autocmd("BufReadCmd", {
  pattern = { "jar:/*", "jrt:/*" },
  callback = function(args)
    local clients = vim.lsp.get_clients({ name = "kotlin_lsp" })
    if #clients == 0 then
      return
    end

    local ok, response = pcall(clients[1].request_sync, clients[1], "workspace/executeCommand", {
      command = "decompile",
      arguments = { args.match },
    }, 2000, args.buf)
    if not ok or not response or not response.result or type(response.result.code) ~= "string" then
      return
    end

    vim.api.nvim_buf_set_lines(args.buf, 0, -1, false, vim.split(response.result.code, "\n"))
    vim.bo[args.buf].filetype = response.result.language
    vim.bo[args.buf].modifiable = false
    vim.bo[args.buf].readonly = true
  end,
})

-- LspAttach: 補完・フォーマット・キーマッピング
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)

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
    vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
  end,
})

-- 補完メニューでEnterで確定
vim.keymap.set("i", "<CR>", function()
  if vim.fn.pumvisible() == 1 then
    return "<C-y>"
  end
  return "<CR>"
end, { expr = true })

-- 自動保存
vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave" }, {
  command = "silent! wa",
})

vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.autocomplete = true

-- Claude Code
vim.keymap.set("n", "<leader>cc", "<cmd>ClaudeCode<CR>", { desc = "Toggle Claude Code" })
vim.keymap.set("v", "<leader>cs", "<cmd>ClaudeCodeSend<CR>", { desc = "Send to Claude" })
vim.keymap.set("n", "<leader>cca", "<cmd>ClaudeCodeDiffAccept<CR>", { desc = "Accept Claude diff" })
vim.keymap.set("n", "<leader>ccd", "<cmd>ClaudeCodeDiffDeny<CR>", { desc = "Deny Claude diff" })
