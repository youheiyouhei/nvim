---
title: "Neovim 0.12のビルトイン機能だけでどこまでいける？ プラグイン27個→13個への移行記録"
emoji: "🔧"
type: "tech"
topics: ["neovim", "vim", "lua"]
published: false
---

## はじめに

Neovim 0.12がリリースされました。ビルトイン補完、vim.pack（プラグインマネージャー）、LSPインライン補完など、これまでプラグインが必要だった機能が次々と本体に取り込まれています。

「どこまでプラグインを減らせるのか？」

この記事では、3回のセッションに分けてNeovim設定をビルトイン機能中心に移行した過程を記録します。Claude Codeと対話しながら進めました。

### 移行前の状態

Packer.nvimで管理していたプラグインは**27個**。典型的な「全部入り」構成でした。

```lua
-- 移行前のplugins.lua（抜粋）
use("hrsh7th/nvim-cmp")
use("hrsh7th/cmp-path")
use("hrsh7th/cmp-buffer")
use("hrsh7th/cmp-cmdline")
use("hrsh7th/cmp-nvim-lsp")
use("jose-elias-alvarez/null-ls.nvim")
use("terrortylor/nvim-comment")
use("nvim-lualine/lualine.nvim")
use("neovim/nvim-lspconfig")
use("williamboman/mason-lspconfig.nvim")
use("Pocco81/auto-save.nvim")
use("MunifTanjim/nui.nvim")
use("aznhe21/actions-preview.nvim")
-- ...他にも多数
```

## セッション1: ビルトイン機能への大移行

最初のセッションで一気に10個のプラグインを削除しました。

### nvim-cmp系（5個）→ vim.lsp.completion.enable()

Neovim 0.12ではLSP補完がビルトインです。nvim-cmpとその関連プラグイン5個をまるごと削除し、`LspAttach` autocmdで有効化するだけに。

```lua
-- before: nvim-cmp（設定だけで50行以上）
local cmp = require("cmp")
cmp.setup({
  sources = {
    { name = "nvim_lsp" },
    { name = "buffer" },
    { name = "path" },
  },
  mapping = cmp.mapping.preset.insert({ ... }),
  -- ...
})

-- after: たった3行
if client:supports_method("textDocument/completion") then
  vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
end
```

**削除したプラグイン:** nvim-cmp, cmp-nvim-lsp, cmp-buffer, cmp-path, cmp-cmdline

### null-ls → LspAttach autocmd

フォーマットのためだけにnull-lsを使っていましたが、`vim.lsp.buf.format()` を `BufWritePre` で呼ぶだけで十分でした。

```lua
if client:supports_method("textDocument/formatting") then
  vim.api.nvim_create_autocmd("BufWritePre", {
    buffer = bufnr,
    callback = function()
      vim.lsp.buf.format({ bufnr = bufnr })
    end,
  })
end
```

### nvim-comment → ビルトインgc/gcc

Neovim 0.10以降、コメントのトグルは `gc`（選択範囲）/ `gcc`（行）がビルトインで動きます。プラグイン不要。

### その他の整理

- **nvim-lspconfig** → `vim.lsp.config` API + `vim.lsp.enable()` に移行
- **mason-lspconfig.nvim** → mason.nvim単体で十分
- **auto-save.nvim**（アーカイブ済み）→ autocmdに置き換え
- **nui.nvim** → 依存なし
- **Packer.nvim → lazy.nvim** に移行

```lua
-- auto-save.nvimの代替（2行）
vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave" }, {
  command = "silent! wa",
})
```

このセッションだけで、27個 → 17個に削減。

## セッション2: さらなるスリム化

### lualine.nvim → デフォルトステータスライン

Neovim 0.12のデフォルトステータスラインは、診断カウント（`vim.diagnostic.status()`）やLSP進捗（`vim.ui.progress_status()`）を表示してくれます。lualineで表示していた情報はほぼカバーされていたので、削除。

### actions-preview.nvim → ビルトインcode action

`vim.lsp.buf.code_action()` のUIが改善されたので、プレビュー用プラグインも不要に。

```lua
vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
```

17個 → 15個に。

## セッション3: プラグインマネージャーもビルトインへ

最後のセッションでは、Neovim 0.12の新機能を調査しながら、さらに3つの移行を行いました。

### vim.lsp.completion.enable() → autocompleteオプション

セッション1で導入した `vim.lsp.completion.enable()` を、さらにシンプルなオプションに置き換え。

```lua
-- before: LspAttachのcallback内で条件分岐
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
    end
  end,
})

-- after: 1行
vim.opt.autocomplete = true
```

`autocomplete` オプションはLSPに限らず、バッファ内単語なども補完ソースにできるため、LSPが動いていないファイルでも補完が効くようになりました。

### lazy.nvim → vim.pack（ビルトイン）

Neovim 0.12の目玉機能のひとつ、ビルトインプラグインマネージャー `vim.pack`。API は `add` / `update` / `del` の3つだけ。

```lua
-- before: lazy.nvimのブートストラップ（10行）+ setup
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { "folke/tokyonight.nvim", lazy = false, priority = 1000, config = function() ... end },
  { "ibhagwan/fzf-lua", dependencies = { "nvim-tree/nvim-web-devicons" } },
  -- ...
})

-- after: vim.pack
vim.pack.add({
  "https://github.com/folke/tokyonight.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/ibhagwan/fzf-lua",
  -- ...
})
```

lazy.nvimの `dependencies`、`event`、`cmd`、`keys` のような宣言的な遅延読み込みはできません。が、プラグイン13個程度なら遅延読み込みの恩恵はほぼなく、シンプルさのメリットが上回ります。

treesitterの `build = ":TSUpdate"` は `PackChanged` イベントで代替:

```lua
vim.api.nvim_create_autocmd("User", {
  pattern = "PackChanged",
  callback = function(ev)
    if ev.data.name == "nvim-treesitter" and ev.data.kind ~= "delete" then
      vim.cmd("TSUpdate")
    end
  end,
})
```

### LSP設定を lsp/ ディレクトリ方式に

init.luaにインラインで書いていたLSP設定を、`lsp/` ディレクトリに分離。

```
~/.config/nvim/
  lsp/
    ts_ls.lua    -- 設定テーブルをreturnするだけ
  init.lua       -- vim.lsp.enable("ts_ls") の1行だけ
```

```lua
-- lsp/ts_ls.lua
return {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  root_markers = { "package.json", "tsconfig.json", "jsconfig.json" },
}
```

LSPサーバーを追加するときは、ファイルを1つ置いて `vim.lsp.enable()` を1行追加するだけ。

## 最終的な構成

### ファイル構造

```
~/.config/nvim/
  init.lua           -- 68行
  lua/
    plugins.lua      -- vim.pack + プラグイン設定
    base.lua         -- 基本オプション（11行）
    maps.lua         -- キーマッピング（22行）
  lsp/
    ts_ls.lua        -- LSPサーバー設定
```

### 残ったプラグイン（13個）

| プラグイン | 役割 | ビルトイン代替がない理由 |
|---|---|---|
| tokyonight.nvim | カラースキーム | 好みの問題 |
| nvim-web-devicons | アイコン | fzf-luaの依存 |
| fzf-lua | ファジーファインダー | ビルトイン代替なし |
| nvim-autopairs | 括弧自動閉じ | ビルトイン代替なし |
| mason.nvim | LSPサーバー管理 | 手動インストールは面倒 |
| gitsigns.nvim | Git差分表示 | ビルトイン代替なし |
| plenary.nvim | ユーティリティ | lir.nvimの依存 |
| lir.nvim | ファイラー | netrwより好み |
| nvim-treesitter | パーサー管理 | パーサーのインストールに必要 |
| copilot.vim | AI補完 | vim.lsp.inline_completionで代替可能（次の課題） |
| nvim-lightbulb | コードアクション表示 | 地味に便利 |
| snacks.nvim | ユーティリティ | claudecode.nvimの依存 |
| claudecode.nvim | Claude Code連携 | 開発に必須 |

### 削除したプラグイン（14個）

| プラグイン | 代替 |
|---|---|
| Packer.nvim | vim.pack |
| lazy.nvim | vim.pack |
| nvim-cmp | autocompleteオプション |
| cmp-nvim-lsp | autocompleteオプション |
| cmp-buffer | autocompleteオプション |
| cmp-path | autocompleteオプション |
| cmp-cmdline | autocompleteオプション |
| null-ls.nvim | vim.lsp.buf.format() |
| nvim-comment | ビルトインgc/gcc |
| nvim-lspconfig | vim.lsp.config API |
| mason-lspconfig.nvim | 不要 |
| lualine.nvim | デフォルトステータスライン |
| actions-preview.nvim | vim.lsp.buf.code_action() |
| auto-save.nvim | autocmd 2行 |

## 感想

Neovim 0.12は「プラグインなしでどこまでいけるか」の答えを大きく更新してくれました。特に以下が印象的です。

- **autocompleteオプション** — nvim-cmpの設定地獄から解放される。1行で自動補完が動く
- **vim.pack** — lazy.nvimほど高機能ではないが、プラグイン数が少ないなら十分。ブートストラップコードが不要なのが最高
- **lsp/ディレクトリ方式** — LSP設定が1ファイル1サーバーで整理される
- **デフォルトステータスライン** — 診断カウントとLSP進捗が表示される。lualineの出番が減った

次の課題は `copilot.vim` を `vim.lsp.inline_completion` + `copilot-language-server` に置き換えること。これが実現すれば、AI補完もビルトインLSPの仕組みに統合できます。

プラグインが少ないということは、壊れるものが少ないということ。Neovimのメジャーアップデートで設定が壊れて半日溶かす、あの苦行から少しずつ解放されていく気がします。
