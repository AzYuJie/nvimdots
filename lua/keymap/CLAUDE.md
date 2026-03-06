[根目录](../../CLAUDE.md) > [lua](..) > **keymap**

# 快捷键模块

负责管理所有快捷键映射，按功能分类组织。

## 模块职责

- 定义统一的快捷键绑定 API
- 按类别组织快捷键（核心、编辑、工具、UI、LSP、语言）
- 支持用户自定义覆盖

## 入口与启动

**入口文件**：`init.lua`

加载流程：
1. 加载辅助函数（`helpers.lua`）
2. 加载核心快捷键（插件管理）
3. 加载分类快捷键（completion、editor、lang、tool、ui）
4. 加载用户自定义快捷键

## 对外接口

### 快捷键绑定 API（bind.lua）

```lua
-- 映射命令（带 CR）
map_cr("SomeCommand"):with_silent():with_noremap():with_desc("描述")

-- 映射命令（带 <C-u>）
map_cu("SomeCommand"):with_silent():with_noremap()

-- 映射原始命令
map_cmd("<Esc>")

-- 映射回调函数
map_callback(function()
    -- 回调逻辑
end):with_desc("描述")

-- 模式前缀格式: "模式|快捷键"
-- 例如: "n|<leader>ff" 表示普通模式
--      "nv|<leader>w" 表示普通和可视模式
--      "xo|af" 表示可视和操作待决模式
```

### 快捷键分类

| 文件 | 功能类别 | 示例 |
|------|----------|------|
| `init.lua` | 插件管理（Lazy） | `<leader>ph`, `<leader>ps` |
| `completion.lua` | LSP、格式化 | `gd`, `K`, `ga`, `gr` |
| `editor.lua` | 编辑、会话、跳转 | `<C-s>`, `gcc`, `<leader>w` |
| `tool.lua` | 终端、Git、调试、AI | `<C-\>`, `<leader>gg`, `<F6>` |
| `ui.lua` | 缓冲区、窗口 | `<A-i>`, `<C-h>` |
| `lang.lua` | 语言特定 | `<F1>`, `<F12>` |

## 关键依赖与配置

- 依赖 `keymap.bind` 模块提供绑定 API
- 依赖 `keymap.helpers` 提供辅助函数
- 用户覆盖：`lua/user/keymap/` 下同名文件

## 常见问题 (FAQ)

**Q> 如何修改现有快捷键？**
A> 在 `lua/user/keymap/init.lua` 中使用 `require("modules.utils.keymap").replace()` 覆盖。

**Q> 如何添加新的快捷键分类？**
A> 在 `lua/keymap/` 下创建新文件，然后在 `init.lua` 中 require。

## 相关文件清单

| 文件 | 描述 |
|------|------|
| `init.lua` | 入口，加载所有分类 |
| `bind.lua` | 快捷键绑定 API |
| `helpers.lua` | 辅助函数 |
| `completion.lua` | LSP/补全快捷键 |
| `editor.lua` | 编辑器快捷键 |
| `tool.lua` | 工具快捷键 |
| `ui.lua` | UI 快捷键 |
| `lang.lua` | 语言特定快捷键 |

## 变更记录 (Changelog)

| 日期 | 变更内容 |
|------|----------|
| 2026-03-06 | 初始化模块文档 |
