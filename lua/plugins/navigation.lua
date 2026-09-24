return {
  {
    "stevearc/oil.nvim",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("oil").setup()
    end,
  },

  {
    "stevearc/aerial.nvim",
    lazy = false,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("aerial").setup({
        backends = {
          "lsp",
          "treesitter",
          "markdown",
          "man",
        },
        layout = {
          default_direction = "left",
        },
      })
    end,
  },
}
