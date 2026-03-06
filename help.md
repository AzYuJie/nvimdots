# nvimdots 帮助文档

> 来源：https://github.com/ayamir/nvimdots Wiki

---

## 目录

1. [前置要求](#前置要求)
2. [快捷键](#快捷键)
3. [插件](#插件)
4. [使用方法](#使用方法)
5. [知识库](#知识库)

---

## 前置要求

### SSH 密钥配置（可选）

仅当需要使用 SSH 克隆和更新插件时需要此步骤。

1. 添加 SSH 密钥到 GitHub 账户
2. 配置 SSH 密钥，在 `~/.ssh/config` 中添加：

```
Host github.com
    Hostname github.com
    User git
    IdentityFile ~/.ssh/id_rsa
```

### ArchLinux 必需包安装

```bash
# lazygit - TUI git 操作所需
# ripgrep - telescope 单词搜索引擎所需
# zoxide - telescope-zoxide 所需
# fd - telescope 文件搜索引擎所需
# yarn - markdown 预览所需
# ttf-jetbrains-mono-nerd - devicons 和 neovide 字体所需
# lldb - 调试 c/cpp/rust 程序所需
# nvm - node 版本管理器
# make - fzf 所需
# unzip - mason 所需
# neovim 版本 >= 0.7
# python-pynvim - neovim python 模块
paru -S git lazygit zoxide ripgrep fd yarn ttf-jetbrains-mono-nerd lldb nvm make unzip neovim python-pynvim

# nodejs - copilot.lua 所需
# node 版本必须 > 16.x（例如 18）
nvm install 18
nvm use 18

# cargo/rustc - sniprun 和 rustfmt 所需
paru -S rustup
rustup toolchain install nightly # 或 stable
```

### Ubuntu 22.04 必需包安装

```bash
sudo apt install git unzip make cmake gcc g++ clang zoxide ripgrep fd-find yarn lldb python3-pip python3-venv

# lazygit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin

# nvm
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
nvm install 18
nvm use 18

# cargo/rustc
curl https://sh.rustup.rs -sSf | sh
```

### MacOS 必需包安装（Apple M2 测试）

```bash
brew install git lazygit zoxide ripgrep fd yarn nvm make unzip neovim

nvm install 18
nvm use 18
rustup toolchain install stable

# 安装所需字体
p10k configure # 仅适用于 iterm2
# 如果不使用 iterm2，可以从以下网站下载字体
# https://github.com/romkatv/powerlevel10k#meslo-nerd-font-patched-for-powerlevel10k
```

### 可选包

某些语言需要 `tree-sitter` 可执行文件的解析器生成器支持（`:TSInstallFromGrammar`）：

```bash
brew install tree-sitter
yarn global add tree-sitter-cli
cargo install tree-sitter-cli
```

### 推荐终端

- wezterm
- kitty

需要设置 `nerd font`（如 `JetBrainsMono Nerd Font`）作为终端字体以显示图标。

### 推荐GUI应用

- neovide
- goneovim
- nvui

### 插件工具

- 使用 `:MasonInstall` 安装语言服务器
  - `:MasonInstall rust-analyzer` - rust
  - `:MasonInstall json-lsp` - json

- 格式化/代码检查工具：
  - `:MasonInstall vint` - vimscript
  - `:MasonInstall stylua` - lua
  - `:MasonInstall clang-format` - c/cpp
  - `:MasonInstall black` - python
  - `:MasonInstall eslint` - ts/js
  - `:MasonInstall prettier` - vue/ts/js/html/yaml/css/scss/markdown
  - `:MasonInstall shfmt` - shell
  - `:MasonInstall shellcheck` - shell

- 使用 `:checkhealth` 检查所有模块是否正常工作
- 使用 `:Tutor dots` 查看内置教程

---

## 快捷键

默认 `<leader>` 键是 `<Space>`。

### 模式说明

- `N` - 普通模式
- `I` - 插入模式
- `V` - 可视模式

### 快捷键表示

- `<C-p>` 表示同时按下 `<Ctrl>` 和 `p`
- `<A-d>` 表示同时按下 `<Alt>` 和 `d`
- `<leader>ps` 表示依次按下 `<leader>`、`p`、`s`

### macOS 用户

参考相关 issue 启用 `Alt` 键功能。

### 详细快捷键文件位置

- `lua/keymap/init.lua`
- `lua/keymap/completion.lua`
  - `lua/modules/configs/completion/cmp.lua` - 补全相关快捷键
- `lua/keymap/editor.lua`
- `lua/keymap/lang.lua`
- `lua/keymap/tool.lua`
- `lua/keymap/ui.lua`

### 编辑器内查看快捷键

1. 普通模式下按 `<C-p>`
2. 命令模式使用 `:WhichKey`
3. 输入感兴趣的前缀

---

## 插件

### 插件依赖关系图

插件依赖树结构（点击放大查看）：

- 箭头表示 "B 在 A 之后加载"
- 虚线箭头表示 "B 依赖于 A，或 A 必须在 B 之前加载"
- Neovim 从 `init` 开始加载
- 浅蓝色圆圈代表事件
- 深蓝色圆圈代表插件名称，八边形表示可选插件
- 绿色圆圈表示语言服务器的核心插件

### 插件分类

#### Completion（补全）

| 插件 | 说明 |
|------|------|
| neovim/nvim-lspconfig | Neovim 原生 LSP 配置 |
| williamboman/mason.nvim | LSP/DAP/linter/formatter 包管理器 |
| williamboman/mason-lspconfig.nvim | mason 与 nvim-lspconfig 桥接 |
| folke/neoconf.nvim | 管理全局和项目本地设置 |
| Jint-lzxy/lsp_signature.nvim | 函数参数签名提示 |
| glepnir/lspsaga.nvim | 更好的 LSP 功能 |
| nvim-tree/nvim-web-devicons | nerdfont 图标源 |
| stevearc/aerial.nvim | 代码大纲窗口 |
| DNLHC/glance.nvim | LSP 位置预览导航 |
| joechrisellis/lsp-format-modifications.nvim | 部分格式化修改代码 |
| nvimtools/none-ls.nvim | 通过 Lua 使用 Neovim 作为语言服务器 |
| nvim-lua/plenary.nvim | Lua 函数集合 |
| jay-babu/mason-null-ls.nvim | mason 与 null-ls 桥接 |
| hrsh7th/nvim-cmp | Neovim 自动补全插件 |
| L3MON4D3/LuaSnip | nvim-cmp 代码片段引擎 |
| rafamadriz/friendly-snippets | LuaSnip 代码片段源 |
| lukas-reineke/cmp-under-comparator | 下划线项排序优化 |
| saadparwaiz1/cmp_luasnip | luasnip 补全源 |
| hrsh7th/cmp-nvim-lsp | lsp 补全源 |
| hrsh7th/cmp-nvim-lua | lua 补全源 |
| andersevenrud/cmp-tmux | tmux 补全源 |
| hrsh7th/cmp-path | 路径补全源 |
| f3fora/cmp-spell | 拼写补全源 |
| hrsh7th/cmp-buffer | 缓冲区补全源 |
| kdheepak/cmp-latex-symbols | latex 符号补全源 |
| ray-x/cmp-treesitter | treesitter 补全源 |
| zbirenbaum/copilot.lua | copilot.vim 的 Lua 移植版 |
| zbirenbaum/copilot-cmp | copilot 补全源 |

#### Editor（编辑器）

| 插件 | 说明 |
|------|------|
| olimorris/persisted.nvim | 会话管理 |
| m4xshen/autoclose.nvim | 自动配对和关闭括号 |
| LunarVim/bigfile.nvim | 大文件编辑支持 |
| ojroques/nvim-bufdel | 配合 bufferline.nvim 温和关闭缓冲区 |
| folke/flash.nvim | 搜索标签导航代码 |
| numToStr/Comment.nvim | 更好的注释 |
| sindrets/diffview.nvim | git diff 视图 |
| echasnovski/mini.align | 交互式文本对齐 |
| smoka7/hop.nvim | 更好的动作跳转 |
| tzachar/local-highlight.nvim | 高亮光标下的单词 |
| brenoprata10/nvim-highlight-colors | 高亮颜色 |
| romainl/vim-cool | 搜索后自动清除高亮 |
| lambdalisue/suda.vim | 使用特权编辑文件 |
| tpope/vim-sleuth | 自动调整 shiftwidth 和 expandtab |
| MagicDuck/grug-far.nvim | 项目级查找替换 |
| mrjones2014/smart-splits.nvim | Neovim 和终端复用器分割导航 |
| nvim-treesitter/nvim-treesitter | 超强代码高亮器 |
| andymass/vim-matchup | 更好的 % 匹配 |
| mfussenegger/nvim-treehopper | 像 hop.nvim 一样选择文本对象 |
| nvim-treesitter/nvim-treesitter-textobjects | 在文本对象间移动 |
| windwp/nvim-ts-autotag | 更快的标签自动关闭 |
| nvim-treesitter-context | 显示当前可见缓冲区内容的上下文 |
| JoosepAlviste/nvim-ts-context-commentstring | 基于上下文的注释 |

#### Lang（语言）

| 插件 | 说明 |
|------|------|
| kevinhwang91/nvim-bqf | 更好的 quickfix |
| ray-x/go.nvim | golang 插件 |
| mrcjkb/rustaceanvim | rust 插件 |
| Saecki/crates.nvim | 管理 crates.io 依赖 |
| iamcco/markdown-preview.nvim | 渲染 markdown 预览 |
| chrisbra/csv.vim | csv 插件 |

#### Tool（工具）

| 插件 | 说明 |
|------|------|
| tpope/vim-fugitive | Neovim 内 git 操作 |
| Bekaboo/dropbar.nvim | winbar 面包屑导航 |
| nvim-tree/nvim-tree.lua | 更好的 netrw |
| ibhagwan/smartyank.nvim | tmux/OSC52 剪贴板支持 |
| michaelb/sniprun | 快速运行代码片段 |
| akinsho/toggleterm.nvim | 更好的终端 |
| folke/trouble.nvim | 显示代码错误 |
| folke/which-key.nvim | 快捷键提示 |
| gelguy/wilder.nvim | 命令模式补全 |
| romgrk/fzy-lua-native | wilder.nvim 的 fzy 支持 |
| nvim-telescope/telescope.nvim | 通用模糊查找器 |
| jvgrootveld/telescope-zoxide | 跳转到 zoxide 记录的目录 |
| debugloop/telescope-undo.nvim | 模糊查找撤销历史 |
| nvim-telescope/telescope-frecency.nvim | 频繁和最近文件跳转 |
| nvim-telescope/telescope-live-grep-args.nvim | live_grep 参数支持 |
| nvim-telescope/telescope-fzf-native.nvim | fzf 搜索 |
| FabianWirth/search.nvim | telescope 集合面板 |
| aharonhallaert/advanced-git-search.nvim | 模糊查找 git 内容 |
| mfussenegger/nvim-dap | Neovim DAP 客户端实现 |
| rcarriga/nvim-dap-ui | DAP UI |
| nvim-neotest/nvim-nio | 异步 IO 库 |
| jay-babu/mason-nvim-dap.nvim | mason 与 nvim-dap 桥接 |

#### UI（界面）

| 插件 | 说明 |
|------|------|
| goolord/alpha-nvim | 更好的启动页 |
| akinsho/bufferline.nvim | 标签和缓冲区管理 |
| Jint-lzxy/nvim | catppuccin 主题 |
| j-hui/fidget.nvim | 显示 lsp 实时状态 |
| lewis6991/gitsigns.nvim | statuscolumn 显示 git 状态 |
| lukas-reineke/indent-blankline.nvim | 不同级别缩进显示 |
| nvim-lualine/lualine.nvim | 状态栏 |
| zbirenbaum/neodim | 淡化未使用的符号 |
| karb94/neoscroll.nvim | 平滑滚动 |
| rcarriga/nvim-notify | 动画通知 |
| folke/paint.nvim | 轻松添加额外高亮 |
| folke/todo-comments.nvim | 高亮注释中的特定关键词 |
| dstein64/nvim-scrollview | 可滚动滚动条 |

---

## 使用方法

### 通用设置

所有常用配置项都在 `settings.lua` 中实现。

### 目录结构

`init.lua` 是配置入口点，加载 `lua` 目录中的配置。

```
init.lua
   └── lua/
       └── modules/
           ├── plugins/
           │   ├── completion.lua
           │   ├── editor.lua
           │   ├── lang.lua
           │   ├── tool.lua
           │   └── ui.lua
           ├── configs/
           │   ├── completion/
           │   ├── editor/
           │   ├── lang/
           │   ├── tool/
           │   └── ui/
           └── utils/
               ├── dap.lua
               ├── icons.lua
               ├── keymap.lua
               └── init.lua
```

### scope 定义

- `completion` - 代码补全相关插件
- `editor` - 改进原生 nvim 能力的插件
- `lang` - 特定编程语言相关插件
- `tool` - 使用外部工具并改变默认布局的插件
- `ui` - 渲染界面无用户操作的插件

### 用户自定义配置

用户自定义配置放在 `lua/user` 目录下：

- `plugins/{scope}.lua` - 用户添加的插件
- `configs/{plugin-name}.lua` - 默认插件配置覆盖
- `configs/dap-clients/` - DAP 客户端设置
- `configs/lsp-servers/` - LSP 服务器设置
- `keymap/` - 自定义快捷键
- `event.lua` - 自定义用户事件
- `options.lua` - 原生 nvim 选项覆盖
- `settings.lua` - 设置覆盖

### 修改插件配置

1. 在 `user/configs/<plugin-name>.lua` 添加配置
2. 如果是 Lua 插件：
   - 返回 table 替换部分配置
   - 返回 function 完全替换配置
   - 返回 `false` 不调用 setup 函数
3. 如果是 Vimscript 插件：
   - 返回包含 `vim.g.<options> = foobar` 的 function

### 添加新插件

在 `user/plugins/<scope>.lua` 中添加：

```lua
local custom = {}

custom["folke/todo-comments.nvim"] = {
    lazy = true,
    event = "BufRead",
    config = require("configs.editor.todo-comments"),
}

return custom
```

### 禁用插件

在 `user/settings.lua` 中添加：

```lua
settings["disabled_plugins"] = {
    "karb94/neoscroll.nvim",
    "dstein64/nvim-scrollview",
}
```

### 修改快捷键

在 `user/keymap/<scope>.lua` 中修改：

```lua
local bind = require("keymap.bind")
local map_cr = bind.map_cr

return {
    -- 移除默认快捷键
    ["n|<leader>nf"] = "",
    ["n|<leader>nr"] = false,
}
```

### 修改 LSP/linter/formatter

- 添加/移除 LSP 服务器：修改 `user/settings` 中的 `settings[lsp_deps]`
- 添加/移除 linter/formatter：修改 `user/settings` 中的 `settings[null_ls_deps]`

### 修改 DAP 客户端

修改 `user/settings` 中的 `settings[dap_deps]`，然后在 `user/configs/dap-clients` 添加配置。

### 切换配色方案

在 `user/settings.lua` 中修改：

```lua
settings["colorscheme"] = "catppuccin-latte"
```

### Catppuccin 配色方案指南

Catppuccin 是一个社区驱动的柔和主题，有四种风格：
- `latte` - 浅色
- `frappe` - 深色
- `macchiato` - 深色
- `mocha` - 深色（默认）

---

## 知识库

### Neovim 深入

- `<C-v>` 粘贴大量文本时冻结 nvim
- 如何使用跳转列表遍历函数？
- 如何直接跳转到下一个/上一个 live_grep 结果？

### LSP 相关问题

#### clangd 相关

- clangd 找不到标准库头文件
- clangd: 第三方头文件未找到
- clang-format: 使用样式配置文件
- 不支持 c++11，包含我的头文件错误
- 为 clangd 禁用 clang-tidy
- 如何清理 C++20 的错误
- 如何使用 clangd 通过 gd/gD 跳转到 var 和 struct 定义？
- 如何修改 clangd.lua 以支持 C++20？
- Clangd 的 C++23 支持

#### pyright 相关

- pyright 无法解析子模块

#### pylsp 相关

- 向 pylsp 自动补全添加第三方模块

#### 其他

- 如何配置不由 mason.nvim 管理的语言服务器如 glsl-analyzer？
- 为什么引入 server_formatting_block_list？
- diffview 中 "DocumentURI scheme is not 'file'"

### Tree-sitter 相关问题

- Treesitter 高亮因 `query: invalid node type` 损坏
- Treesitter 在大文件上会稳定吗？

### DAP 相关问题

- 如何使用 nvim-dap 调试 C++？
- 调试前自动编译文件

---

## 常用命令速查

| 命令 | 说明 |
|------|------|
| `:checkhealth` | 检查所有模块状态 |
| `:Mason` | 打开包管理器 |
| `:MasonInstall <package>` | 安装包 |
| `:Tutor dots` | 查看内置教程 |
| `:WhichKey` | 查看快捷键 |
| `:FormatToggle` | 启用/禁用保存时格式化 |
| `:Lazy` | 打开插件管理器 |
