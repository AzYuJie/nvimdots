# lazysql 集成设计

## 概述

将 lazysql 终端工具集成到 Neovim 中，模仿 lazygit 的集成方式。

## 需求

- 使用 toggleterm.nvim 作为终端管理器
- 浮动窗口显示方式
- 快捷键 `<leader>gl` 触发
- 启动前检查命令是否存在

## 架构

**修改文件**：

| 文件 | 修改内容 |
|------|----------|
| `lua/keymap/helpers.lua` | 添加 `_toggle_lazysql()` 全局函数 |
| `lua/keymap/tool.lua` | 添加 `<leader>gl` 快捷键绑定 |

**无需新增插件**：复用现有的 `toggleterm.nvim`

## 实现细节

### helpers.lua 新增函数

```lua
local _lazysql = nil
_G._toggle_lazysql = function()
    if vim.fn.executable("lazysql") == 1 then
        if not _lazysql then
            _lazysql = require("toggleterm.terminal").Terminal:new({
                cmd = "lazysql",
                direction = "float",
                close_on_exit = true,
                hidden = true,
            })
        end
        _lazysql:toggle()
    else
        vim.notify("Command [lazysql] not found!", vim.log.levels.ERROR, { title = "toggleterm.nvim" })
    end
end
```

### tool.lua 新增快捷键

```lua
["n|<leader>gl"] = map_callback(function()
        _toggle_lazysql()
    end)
    :with_noremap()
    :with_silent()
    :with_desc("数据库: 切换 lazysql"),
```

## 快捷键映射

| 快捷键 | 功能 | 描述 |
|--------|------|------|
| `<leader>gg` | lazygit | Git: 切换 lazygit |
| `<leader>gl` | lazysql | 数据库: 切换 lazysql |

## 错误处理

- 启动前检查 `lazysql` 命令是否存在
- 若不存在，显示错误通知
