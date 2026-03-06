[根目录](../../CLAUDE.md) > [lua](..) > **core**

# 核心模块

负责 Neovim 的初始化、全局变量定义、选项设置和插件加载。

## 模块职责

- 初始化缓存目录和数据目录
- 设置 Leader 键
- 配置 GUI（Neovide 等）
- 配置剪贴板和 Shell
- 加载 Neovim 选项
- 加载插件管理器（lazy.nvim）

## 入口与启动

**入口文件**：`init.lua`

启动流程：
1. `init.lua` 检测是否在 VSCode 中运行
2. 调用 `require("core")` 加载核心模块
3. `core/init.lua` 执行：
   - 创建缓存目录
   - 设置 Leader 键为空格
   - 配置 GUI/Neovide/剪贴板/Shell
   - 加载选项、事件、插件和快捷键
   - 应用配色方案

## 对外接口

无直接对外接口，通过模块 require 机制提供功能。

## 关键依赖与配置

| 文件 | 职责 |
|------|------|
| `global.lua` | 定义全局变量（OS 检测、路径等） |
| `settings.lua` | 用户可配置项（主题、LSP、格式化等） |
| `options.lua` | Neovim 选项设置 |
| `pack.lua` | lazy.nvim 插件加载器 |
| `event.lua` | 自动命令 |

### 核心设置项（settings.lua）

```lua
settings["use_ssh"] = true           -- 使用 SSH 克隆插件
settings["use_copilot"] = true       -- 启用 Copilot
settings["format_on_save"] = true    -- 保存时格式化
settings["colorscheme"] = "catppuccin" -- 主题
settings["search_backend"] = "telescope" -- 搜索后端
settings["lsp_deps"] = { ... }       -- LSP 服务器列表
settings["dap_deps"] = { ... }       -- 调试适配器列表
settings["treesitter_deps"] = { ... } -- Treesitter 解析器列表
```

## 数据模型

无数据模型，使用全局变量表。

## 测试与质量

- 使用 GitHub Actions 进行 stylua 代码风格检查
- 无单元测试

## 常见问题 (FAQ)

**Q: 如何修改主题？**
A: 编辑 `lua/core/settings.lua` 中的 `settings["colorscheme"]`，可选值：`catppuccin`、`catppuccin-latte`、`catppuccin-mocha` 等。

**Q: 如何添加新的 LSP？**
A: 在 `settings.lua` 的 `lsp_deps` 数组中添加服务器名称，然后在 `lua/modules/configs/completion/servers/` 下创建配置文件。

**Q: 启动报错 "lazy.nvim not found"？**
A: 首次启动会自动克隆 lazy.nvim，确保网络畅通或设置 `use_ssh = false`。

## 相关文件清单

| 文件 | 描述 |
|------|------|
| `init.lua` | 核心入口 |
| `global.lua` | 全局变量 |
| `settings.lua` | 配置项 |
| `options.lua` | Neovim 选项 |
| `pack.lua` | 插件加载器 |
| `event.lua` | 自动命令 |

## 变更记录 (Changelog)

| 日期 | 变更内容 |
|------|----------|
| 2026-03-06 | 初始化模块文档 |
