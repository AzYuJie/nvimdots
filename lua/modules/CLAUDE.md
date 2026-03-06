[根目录](../../CLAUDE.md) > [lua](..) > **modules**

# 插件模块

负责插件声明、配置和工具函数。

## 模块职责

- 匉类别声明插件（使用 lazy.nvim）
- 提供插件配置
- 提供通用工具函数

## 入口与启动

插件通过 `lua/core/pack.lua` 自动加载，扫描以下目录：
- `lua/modules/plugins/*.lua` - 默认插件声明
- `lua/user/plugins/*.lua` - 用户自定义插件

## 目录结构

```
lua/modules/
├── plugins/          # 插件声明
│   ├── completion.lua  # LSP、补全、Copilot
│   ├── editor.lua     # Treesitter、注释、会话
│   ├── lang.lua       # 语言特定（Go、Rust、Markdown）
│   ├── tool.lua       # 文件树、终端、Git、DAP、AI
│   └── ui.lua         # 主题、状态栏、缓冲区
├── configs/          # 插件配置（与 plugins 对应）
│   ├── completion/
│   ├── editor/
│   ├── lang/
│   ├── tool/
│   └── ui/
└── utils/            # 工具函数
    ├── init.lua       # 通用工具（颜色、配置扩展）
    ├── icons.lua      # 图标定义
    ├── keymap.lua     # 快捷键工具
    └── dap.lua        # DAP 工具
```

## 插件类别

### completion（补全）

| 插件 | 用途 |
|------|------|
| `nvim-lspconfig` | LSP 配置 |
| `mason.nvim` | LSP/DAP/格式化工具管理 |
| `nvim-cmp` | 自动补全 |
| `LuaSnip` | 代码片段 |
| `copilot.lua` | GitHub Copilot |
| `lspsaga.nvim` | LSP UI 增强 |
| `none-ls.nvim` | 格式化工具 |

### editor（编辑器）

| 插件 | 用途 |
|------|------|
| `nvim-treesitter` | 语法高亮 |
| `Comment.nvim` | 注释 |
| `persisted.nvim` | 会话管理 |
| `hop.nvim` | 快速跳转 |
| `flash.nvim` | 快速跳转（增强） |
| `grug-far.nvim` | 搜索替换 |

### lang（语言）

| 插件 | 用途 |
|------|------|
| `go.nvim` | Go 开发 |
| `rustaceanvim` | Rust 开发 |
| `crates.nvim` | Cargo.toml 补全 |
| `render-markdown.nvim` | Markdown 渲染 |

### tool（工具）

| 插件 | 用途 |
|------|------|
| `nvim-tree.lua` | 文件树 |
| `toggleterm.nvim` | 终端 |
| `telescope.nvim` | 模糊搜索 |
| `nvim-dap` | 调试 |
| `trouble.nvim` | 诊断列表 |
| `codecompanion.nvim` | AI 聊天 |
| `vim-fugitive` | Git |

### ui（界面）

| 插件 | 用途 |
|------|------|
| `catppuccin` | 主题 |
| `lualine.nvim` | 状态栏 |
| `bufferline.nvim` | 缓冲区标签 |
| `alpha-nvim` | 启动页 |
| `gitsigns.nvim` | Git 状态标记 |
| `nvim-notify` | 通知 |

## 工具函数（utils/init.lua）

```lua
-- 扩展用户配置
M.extend_config(config, "user.options")

-- 加载插件（支持用户覆盖）
M.load_plugin(plugin_name, opts, vim_plugin, setup_callback)

-- 注册 LSP 服务器
M.register_server(server, config)

-- 颜色工具
M.get_palette()  -- 获取主题色板
M.blend(fg, bg, alpha)  -- 混合颜色
```

## 常见问题 (FAQ)

**Q> 如何添加新插件？**
A> 在 `lua/modules/plugins/` 对应类别文件中添加声明，然后在 `lua/modules/configs/` 下创建配置。

**Q> 如何覆盖默认配置？**
A> 在 `lua/user/configs/` 下创建同名文件，返回 table 或 function。

## 相关文件清单

- `plugins/*.lua` - 插件声明
- `configs/**/*.lua` - 插件配置
- `utils/*.lua` - 工具函数

## 变更记录 (Changelog)

| 日期 | 变更内容 |
|------|----------|
| 2026-03-06 | 初始化模块文档 |
