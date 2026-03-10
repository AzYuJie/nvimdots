# lazysql 集成实施计划

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** 将 lazysql 数据库终端工具集成到 Neovim，使用 `<leader>gl` 快捷键触发

**Architecture:** 复用现有 toggleterm.nvim 插件，添加全局切换函数和快捷键绑定，与 lazygit 集成方式完全一致

**Tech Stack:** Lua, toggleterm.nvim

---

## Task 1: 添加 lazysql 切换函数

**Files:**
- Modify: `lua/keymap/helpers.lua`

**Step 1: 添加 `_toggle_lazysql` 函数**

在 `_toggle_lazygit` 函数后添加以下代码：

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

位置：`lua/keymap/helpers.lua` 第 83 行之后（`_toggle_lazygit` 函数结束后）

---

## Task 2: 添加快捷键绑定

**Files:**
- Modify: `lua/keymap/tool.lua`

**Step 1: 添加 `<leader>gl` 快捷键**

在 lazygit 快捷键后添加 lazysql 快捷键：

```lua
		["n|<leader>gl"] = map_callback(function()
				_toggle_lazysql()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("数据库: 切换 lazysql"),
```

位置：`lua/keymap/tool.lua` 第 81 行之后（lazygit 快捷键定义之后）

---

## Task 3: 验证集成

**Step 1: 重新加载配置**

在 Neovim 中执行：
```vim
:source %
:source ~/.config/nvim/lua/keymap/helpers.lua
```

或者重启 Neovim。

**Step 2: 测试快捷键**

1. 按 `<leader>gl` 应该打开 lazysql 浮动终端
2. 再按一次应该关闭终端
3. 如果 lazysql 未安装，应显示错误通知

**Step 3: 验证 lazygit 仍正常工作**

按 `<leader>gg` 确认 lazygit 仍可正常切换。

---

## 完成标准

- [x] `_toggle_lazysql` 函数添加到 helpers.lua
- [x] `<leader>gl` 快捷键添加到 tool.lua
- [x] 按快捷键可正常打开/关闭 lazysql
- [x] lazysql 未安装时显示错误通知
- [x] lazygit 功能不受影响
