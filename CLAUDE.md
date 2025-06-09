# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Neovim設定の概要

この設定は、Packer.nvimを使用したモダンなNeovim設定です。LSP、補完、フォーマット機能が統合されており、特にGo、TypeScript、Luaでの開発に最適化されています。

## 主要なコマンド

### プラグイン管理
```bash
nvim +PackerSync +qall          # プラグインの同期とコンパイル
nvim +PackerInstall +qall       # 新しいプラグインのインストール
nvim +PackerCompile +qall       # 設定のコンパイル
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
- `lua/plugins.lua` - Packer.nvimによるプラグイン定義
- `lua/base.lua` - Neovimの基本設定（オプション、カラースキーム）
- `lua/maps.lua` - キーマッピング設定

### 設定の読み込み順序
1. プラグイン定義の読み込み
2. 基本設定の適用
3. キーマッピングの設定
4. LSP、補完、フォーマッターの設定

### 主要プラグイン
- **プラグインマネージャー**: Packer.nvim
- **ファイル検索**: fzf-lua
- **LSP**: nvim-lspconfig + Mason
- **補完**: nvim-cmp ecosystem
- **フォーマット**: prettier.nvim, null-ls.nvim
- **AI支援**: copilot.vim
- **ファイラー**: lir.nvim

## 言語設定

### 対応言語
- Go (包括的なスニペット、LSP設定)
- TypeScript/JavaScript (Prettier、ESLint統合)
- Lua (stylua設定、LSP)
- その他（Python、Rust等のLSP設定）


## 重要な設定

- リーダーキー: スペースキー
- 自動保存: 有効（auto-save.nvim）
- 自動フォーマット: ファイル保存時に実行
- インデント: 2スペース（stylua.toml設定）