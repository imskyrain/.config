return {
	"HakonHarnes/img-clip.nvim",
	event = "VeryLazy",
	opts = {
		default = {
			embed_image_as_base64 = false,
			prompt_for_file_name = true,
			drag_and_drop = {
				insert_mode = true,
			},
			use_absolute_path = false,
		},
		filetypes = {
			markdown = {
				url_encode_path = true,
				template = "![$CURSOR]($FILE_PATH)",
				drag_and_drop = {
					download_images = false,
				},
			},
			html = {
				template = '<img src="$FILE_PATH" alt="$CURSOR">',
			},
			tex = {
				template = [[
\begin{figure}[h]
  \centering
  \includegraphics[width=0.8\textwidth]{$FILE_PATH}
  \caption{$CURSOR}
  \label{fig:$LABEL}
\end{figure}
        ]],
			},
		},
	},
	keys = {
		{ "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste image from clipboard" },
	},
}
