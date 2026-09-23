-- helper to darken a hex color by `amount` (0.0–1.0)
local function darken(hex, amount)
  local r = tonumber(hex:sub(2,3), 16)
  local g = tonumber(hex:sub(4,5), 16)
  local b = tonumber(hex:sub(6,7), 16)

  r = math.floor(r * (1 - amount))
  g = math.floor(g * (1 - amount))
  b = math.floor(b * (1 - amount))

  return string.format("#%02X%02X%02X", r, g, b)
end

require("base16-colorscheme").setup {
  base00 = darken("{{colors.surface.default.hex}}", 0.02),  -- slightly darker
  base01 = "{{colors.surface_container.default.hex}}",
  base02 = "{{colors.surface_container_high.default.hex}}",
  base03 = "{{colors.outline.default.hex}}",
  base04 = "{{colors.on_surface_variant.default.hex}}",
  base05 = "{{colors.on_surface.default.hex}}",
  base06 = "{{colors.on_surface.default.hex}}",
  base07 = "{{colors.on_background.default.hex}}",
  base08 = "{{colors.error.default.hex}}",
  base09 = "{{colors.tertiary.default.hex}}",
  base0A = "{{colors.secondary.default.hex}}",
  base0B = "{{colors.primary.default.hex}}",
  base0C = "{{colors.tertiary_fixed_dim.default.hex}}",
  base0D = "{{colors.primary_fixed_dim.default.hex}}",
  base0E = "{{colors.secondary_fixed_dim.default.hex}}",
  base0F = "{{colors.error_container.default.hex}}",
}

