return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",

    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",

      {
        "L3MON4D3/LuaSnip",
        version = "v2.*",

        dependencies = {
          "rafamadriz/friendly-snippets",
        },

        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
        end,
      },
    },

    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        completion = {
          -- Show completion automatically while typing.
          autocomplete = {
            cmp.TriggerEvent.TextChanged,
          },

          keyword_length = 1,
          completeopt = "menu,menuone,noselect",
        },

        -- Do not select the first suggestion automatically.
        preselect = cmp.PreselectMode.None,

        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },

        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },

        mapping = cmp.mapping.preset.insert({
          -- Open completion manually.
          ["<C-Space>"] = cmp.mapping.complete(),

          -- Close completion.
          ["<C-e>"] = cmp.mapping.abort(),

          -- Next suggestion.
          ["<C-j>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item({
                behavior = cmp.SelectBehavior.Select,
              })
            else
              fallback()
            end
          end, { "i", "s" }),

          -- Previous suggestion.
          ["<C-k>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item({
                behavior = cmp.SelectBehavior.Select,
              })
            else
              fallback()
            end
          end, { "i", "s" }),

          -- Keep Ctrl+n and Ctrl+p as alternatives.
          ["<C-n>"] = cmp.mapping.select_next_item({
            behavior = cmp.SelectBehavior.Select,
          }),

          ["<C-p>"] = cmp.mapping.select_prev_item({
            behavior = cmp.SelectBehavior.Select,
          }),

          -- Scroll completion documentation.
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),

          -- Accept only the selected suggestion.
          ["<CR>"] = cmp.mapping.confirm({
            select = false,
          }),

          -- Tab moves forward through completion or snippets.
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item({
                behavior = cmp.SelectBehavior.Select,
              })
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),

          -- Shift+Tab moves backward.
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item({
                behavior = cmp.SelectBehavior.Select,
              })
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),

        sources = cmp.config.sources({
          {
            name = "nvim_lsp",
            priority = 1000,
            keyword_length = 1,
          },

          {
            name = "luasnip",
            priority = 750,
            keyword_length = 2,
          },

          {
            name = "path",
            priority = 500,
            keyword_length = 1,
          },
        }),

        formatting = {
          fields = {
            "kind",
            "abbr",
            "menu",
          },

          format = function(entry, item)
            local source_names = {
              nvim_lsp = "[LSP]",
              luasnip = "[Snippet]",
              path = "[Path]",
            }

            item.menu = source_names[entry.source.name] or ""
            return item
          end,
        },

        experimental = {
          ghost_text = false,
        },
      })
    end,
  },
}
