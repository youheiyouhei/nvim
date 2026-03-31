# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Neovim設定の概要

この設定は、vim.pack（ビルトインプラグインマネージャー）を使用したモダンなNeovim 0.12設定です。ビルトインLSP、補完、フォーマット機能を活用しており、特にGo、TypeScript、Luaでの開発に最適化されています。

## 主要なコマンド

### プラグイン管理
```lua
-- Neovim起動時に未インストールのプラグインがあれば自動でプロンプト表示
-- :lua vim.pack.update()  でプラグインの更新
```

### LSPとツール管理
```bash
nvim +Mason +qall               # LSPサーバー管理UIを開く
nvim +TSUpdate +qall            # Treesitterパーサーの更新
```

### フォーマット
```bash
stylua lua/                     # Luaファイルのフォーマット
```

## アーキテクチャ

### ファイル構造
- `init.lua` - メインの設定ファイル、各モジュールを順番に読み込み
- `lua/plugins.lua` - vim.packによるプラグイン定義と設定
- `lua/base.lua` - Neovimの基本設定（オプション）
- `lua/maps.lua` - キーマッピング設定

### 設定の読み込み順序
1. プラグイン定義の読み込み
2. 基本設定の適用
3. キーマッピングの設定
4. LSP、補完、フォーマッターの設定

### 主要プラグイン
- **プラグインマネージャー**: vim.pack（ビルトイン）
- **ファイル検索**: fzf-lua
- **LSP**: ビルトイン (vim.lsp.config) + Mason
- **補完**: ビルトイン (vim.lsp.completion)
- **AI支援**: copilot.vim, claudecode.nvim
- **ファイラー**: lir.nvim

## 重要な設定

- リーダーキー: スペースキー
- 自動保存: 有効（autocmd: FocusLost/BufLeave）
- 自動フォーマット: ファイル保存時に実行（LSP）
- インデント: 2スペース（stylua.toml設定）
