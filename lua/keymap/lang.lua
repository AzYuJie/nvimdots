local bind = require("keymap.bind")
local map_cr = bind.map_cr

local mappings = {
	plugins = {
		-- Plugin: render-markdown.nvim
		["n|<F1>"] = map_cr("RenderMarkdown toggle")
			:with_noremap()
			:with_silent()
			:with_desc("工具: 切换 nvim 内 Markdown 预览"),
		-- Plugin: MarkdownPreview
		["n|<F12>"] = map_cr("MarkdownPreviewToggle"):with_noremap():with_silent():with_desc("工具: 预览 Markdown"),
	},
}

bind.nvim_load_mapping(mappings.plugins)
