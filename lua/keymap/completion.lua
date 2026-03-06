local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_callback = bind.map_callback

local mappings = {
	fmt = {
		["n|<A-f>"] = map_cr("FormatToggle"):with_noremap():with_silent():with_desc("格式化: 切换保存时格式化"),
		["n|<A-S-f>"] = map_cr("Format"):with_noremap():with_silent():with_desc("格式化: 手动格式化缓冲区"),
	},
}
bind.nvim_load_mapping(mappings.fmt)

--- The following code allows this file to be exported ---
---    for use with LSP lazy-loaded keymap bindings    ---

local M = {}

---@param buf integer
function M.lsp(buf)
	local map = {
		-- LSP-related keymaps, ONLY effective in buffers with LSP(s) attached
		["n|<leader>li"] = map_cr("LspInfo"):with_silent():with_buffer(buf):with_desc("LSP: 信息"),
		["n|<leader>lr"] = map_cr("LspRestart"):with_silent():with_buffer(buf):with_nowait():with_desc("LSP: 重启"),
		["n|go"] = map_cr("Trouble symbols toggle win.position=right")
			:with_silent()
			:with_buffer(buf)
			:with_desc("LSP: 切换大纲"),
		["n|gto"] = map_callback(function()
				if require("core.settings").search_backend == "fzf" then
					local prompt_position = require("telescope.config").values.layout_config.horizontal.prompt_position
					require("fzf-lua").lsp_document_symbols({
						fzf_opts = { ["--layout"] = prompt_position == "top" and "reverse" or "default" },
					})
				else
					require("telescope.builtin").lsp_document_symbols()
				end
			end)
			:with_silent()
			:with_buffer(buf)
			:with_desc("LSP: 在 Telescope 中显示大纲"),
		["n|g["] = map_cr("Lspsaga diagnostic_jump_prev")
			:with_silent()
			:with_buffer(buf)
			:with_desc("LSP: 上一个诊断"),
		["n|g]"] = map_cr("Lspsaga diagnostic_jump_next")
			:with_silent()
			:with_buffer(buf)
			:with_desc("LSP: 下一个诊断"),
		["n|<leader>lx"] = map_cr("Lspsaga show_line_diagnostics ++unfocus")
			:with_silent()
			:with_buffer(buf)
			:with_desc("LSP: 行诊断"),
		["n|gs"] = map_callback(function()
			vim.lsp.buf.signature_help()
		end):with_desc("LSP: 签名帮助"),
		["n|gr"] = map_cr("Lspsaga rename")
			:with_silent()
			:with_nowait()
			:with_buffer(buf)
			:with_desc("LSP: 文件内重命名"),
		["n|gR"] = map_cr("Lspsaga rename ++project")
			:with_silent()
			:with_buffer(buf)
			:with_desc("LSP: 项目内重命名"),
		["n|K"] = map_cr("Lspsaga hover_doc"):with_silent():with_buffer(buf):with_desc("LSP: 显示文档"),
		["nv|ga"] = map_cr("Lspsaga code_action")
			:with_silent()
			:with_buffer(buf)
			:with_desc("LSP: 代码操作"),
		["n|gd"] = map_cr("Glance definitions"):with_silent():with_buffer(buf):with_desc("LSP: 预览定义"),
		["n|gD"] = map_cr("Lspsaga goto_definition"):with_silent():with_buffer(buf):with_desc("LSP: 跳转到定义"),
		["n|gh"] = map_cr("Glance references"):with_silent():with_buffer(buf):with_desc("LSP: 显示引用"),
		["n|gm"] = map_cr("Glance implementations")
			:with_silent()
			:with_buffer(buf)
			:with_desc("LSP: 显示实现"),
		["n|gci"] = map_cr("Lspsaga incoming_calls")
			:with_silent()
			:with_buffer(buf)
			:with_desc("LSP: 显示入调用"),
		["n|gco"] = map_cr("Lspsaga outgoing_calls")
			:with_silent()
			:with_buffer(buf)
			:with_desc("LSP: 显示出调用"),
		["n|<leader>lv"] = map_callback(function()
				_toggle_virtuallines()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("LSP: 切换虚拟行"),
		["n|<leader>lh"] = map_callback(function()
				_toggle_inlayhint()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("LSP: 切换类型提示"),
	}
	bind.nvim_load_mapping(map)

	local ok, user_mappings = pcall(require, "user.keymap.completion")
	if ok and type(user_mappings.lsp) == "function" then
		require("modules.utils.keymap").replace(user_mappings.lsp(buf))
	end
end

return M
