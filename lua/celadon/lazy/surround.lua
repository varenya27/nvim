return {
    "kylechui/nvim-surround",
    version = "*", -- use latest stable
    event = "VeryLazy", -- lazy-load on user events
    config = function()
        require("nvim-surround").setup({
            -- Default mappings: use "ys", "ds", "cs"
            -- You can customize here if desired
            mappings_style = "surround",
            surrounds = {
                ["d"] = {
                    add = function() return {"<div>", "</div>"} end,
                    find = "<div>.-</div>",
                    delete = "^<div>(.*)</div>$",
                    change = "^<div>(.*)</div>$"
                },
            },
        })
    end
}
