return {
  'github/copilot.vim',

  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'echasnovski/mini.nvim', -- if you use the mini.nvim suite
      -- 'echasnovski/mini.icons' -- if you use standalone mini plugins
      -- 'nvim-tree/nvim-web-devicons' -- if you prefer nvim-web-devicons
    },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      --   -- callout = {
      --   --   note = { raw = '[!NOTE]', rendered = 'U000f02fd Note', highlight = 'RenderMarkdownInfo' },
      --   --   -- Other callouts can be added similarly
      --   -- },
      --   html = {
      --     enabled = true,
      --     comment = {
      --       conceal = true,
      --       highlight = 'RenderMarkdownHtmlComment',
      --     },
      --   },
    },
  },
}
