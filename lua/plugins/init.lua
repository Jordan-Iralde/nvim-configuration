return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
    },

    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
    },

    {
        "nvim-lualine/lualine.nvim",
    },

    {
        "lewis6991/gitsigns.nvim",
    },
}
