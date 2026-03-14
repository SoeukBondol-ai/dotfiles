return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  opts = {}, -- important: keep default opts or your custom ones
  config = function(_, opts)
    require("nvim-autopairs").setup(opts)

    -- Integrate with cmp → disable bracket-adding on confirm for python
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    local cmp = require("cmp")

    cmp.event:off("confirm_done", cmp_autopairs.on_confirm_done()) -- remove default handler if any

    cmp.event:on(
      "confirm_done",
      cmp_autopairs.on_confirm_done({
        -- Option A: disable completely for python files
        disable_filetype = { "python" },

        -- Option B: more surgical (recommended) – disable only for certain kinds
        -- handler = function(char, item, bufnr)
        --   if item.kind == "Class" or item.kind == "Module" or item.kind == "Constructor" then
        --     return false  -- don't add brackets
        --   end
        --   return true
        -- end,
      })
    )
  end,
}
