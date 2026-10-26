return {
	cmd = { "jdtls" },
	filetypes = { "java" },
	root_markers = { "pom.xml", "build.gradle", "build.gradle.kts" },
	before_init = function(_, config)
		local git = vim.fs.root(0, ".git")
		if not git then
			return
		end
		local profile = git .. "/itp/config/checkstyle/eclipse-java-google-style.xml" -- Specific project settings
		if vim.uv.fs_stat(profile) then
			config.settings = vim.tbl_deep_extend("force", config.settings or {}, {
				java = { format = { settings = { url = profile, profile = "GoogleStyle" } } },
			})
		end
	end,
}
