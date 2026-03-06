require("keymap.helpers")
local bind = require("keymap.bind")
local map_cr = bind.map_cr

local mappings = {
	core = {
		-- Package manager: lazy.nvim
		["n|<leader>ph"] = map_cr("Lazy"):with_silent():with_noremap():with_nowait():with_desc("插件: 显示"),
		["n|<leader>ps"] = map_cr("Lazy sync"):with_silent():with_noremap():with_nowait():with_desc("插件: 同步"),
		["n|<leader>pu"] = map_cr("Lazy update")
			:with_silent()
			:with_noremap()
			:with_nowait()
			:with_desc("插件: 更新"),
		["n|<leader>pi"] = map_cr("Lazy install")
			:with_silent()
			:with_noremap()
			:with_nowait()
			:with_desc("插件: 安装"),
		["n|<leader>pl"] = map_cr("Lazy log"):with_silent():with_noremap():with_nowait():with_desc("插件: 日志"),
		["n|<leader>pc"] = map_cr("Lazy check"):with_silent():with_noremap():with_nowait():with_desc("插件: 检查"),
		["n|<leader>pd"] = map_cr("Lazy debug"):with_silent():with_noremap():with_nowait():with_desc("插件: 调试"),
		["n|<leader>pp"] = map_cr("Lazy profile")
			:with_silent()
			:with_noremap()
			:with_nowait()
			:with_desc("插件: 性能分析"),
		["n|<leader>pr"] = map_cr("Lazy restore")
			:with_silent()
			:with_noremap()
			:with_nowait()
			:with_desc("插件: 还原"),
		["n|<leader>px"] = map_cr("Lazy clean"):with_silent():with_noremap():with_nowait():with_desc("插件: 清理"),
	},
}

bind.nvim_load_mapping(mappings.core)

-- Builtin & Plugin keymaps
require("keymap.completion")
require("keymap.editor")
require("keymap.lang")
require("keymap.tool")
require("keymap.ui")

-- User keymaps
local ok, def = pcall(require, "user.keymap.init")
if ok then
	require("modules.utils.keymap").replace(def)
end
