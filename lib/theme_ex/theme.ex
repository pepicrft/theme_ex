defmodule ThemeEx.Theme do
  @moduledoc """
  Main theme structure based on the Theme UI specification.
  
  This module defines the complete theme structure including colors, fonts,
  typography scales, breakpoints, and other design tokens following the
  Theme UI specification (https://theme-ui.com/theme-spec).

  ## Theme Structure

  A theme consists of the following optional properties:

  - `:colors` - Color palette with semantic colors and modes
  - `:fonts` - Font family definitions for different text elements  
  - `:fontWeights` - Font weight specifications
  - `:lineHeights` - Line height definitions
  - `:fontSizes` - Typography scale as an array of sizes
  - `:space` - Spacing scale for margins, padding, and layout
  - `:sizes` - Size scale for widths, heights, and dimensions
  - `:radii` - Border radius scale
  - `:shadows` - Box shadow definitions
  - `:zIndices` - Z-index values for layering
  - `:breakpoints` - Media query breakpoints for responsive design
  - `:styles` - Component and element styles
  - `:variants` - Style variations and component variants

  ## Examples

      # Minimal theme
      %ThemeEx.Theme{
        colors: %ThemeEx.Colors{primary: "#0066cc"}
      }

      # Complete theme
      %ThemeEx.Theme{
        colors: %ThemeEx.Colors{
          text: "#000000",
          background: "#ffffff",
          primary: "#0066cc",
          modes: %{"dark" => %{"text" => "#ffffff", "background" => "#000000"}}
        },
        fonts: %ThemeEx.Fonts{
          body: "system-ui, sans-serif",
          heading: "Georgia, serif"
        },
        fontSizes: [12, 14, 16, 20, 24, 32, 48, 64],
        space: [0, 4, 8, 16, 32, 64, 128],
        breakpoints: ["40em", "52em", "64em"]
      }

  """

  defstruct [
    :colors,
    :fonts,
    :fontWeights,
    :lineHeights,
    :fontSizes,
    :space,
    :sizes,
    :radii,
    :shadows,
    :zIndices,
    :breakpoints,
    :styles,
    :variants
  ]

  @type t :: %__MODULE__{
          colors: ThemeEx.Colors.t() | nil,
          fonts: ThemeEx.Fonts.t() | nil,
          fontWeights: ThemeEx.FontWeights.t() | nil,
          lineHeights: ThemeEx.LineHeights.t() | nil,
          fontSizes: list(number()) | nil,
          space: list(number() | String.t()) | nil,
          sizes: list(number() | String.t()) | nil,
          radii: list(number() | String.t()) | nil,
          shadows: list(String.t()) | nil,
          zIndices: map() | nil,
          breakpoints: list(String.t()) | nil,
          styles: map() | nil,
          variants: map() | nil
        }
end