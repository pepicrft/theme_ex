defmodule ThemeEx.Colors do
  @moduledoc """
  Color palette structure for Theme UI themes.
  
  This module defines the color system following the Theme UI specification,
  supporting semantic colors, color scales, and multiple color modes for
  implementing features like dark/light themes.

  ## Semantic Colors

  The following semantic colors are supported:

  - `:text` - Default text color
  - `:background` - Default background color  
  - `:primary` - Primary brand color
  - `:secondary` - Secondary brand color
  - `:accent` - Accent color for highlighting
  - `:highlight` - Background color for highlighted text
  - `:muted` - Muted color for less prominent elements
  - `:success` - Success state color (usually green)
  - `:warning` - Warning state color (usually yellow/orange)
  - `:error` - Error state color (usually red)
  - `:info` - Information state color (usually blue)
  - `:border` - Default border color
  - `:surface` - Surface/card background color

  ## Color Values

  Colors can be defined as:
  - Single color strings: `"#0066cc"`, `"rgb(0, 102, 204)"`, `"blue"`
  - Color scales (arrays): `["#e3f2fd", "#bbdefb", "#90caf9", "#64b5f6"]`

  ## Color Modes

  The `:modes` property supports multiple color modes for responsive theming:

      colors: %ThemeEx.Colors{
        text: "#000000",
        background: "#ffffff",
        modes: %{
          "dark" => %{
            "text" => "#ffffff", 
            "background" => "#000000"
          },
          "high-contrast" => %{
            "text" => "#000000",
            "background" => "#ffffff"
          }
        }
      }

  ## Examples

      # Basic colors
      %ThemeEx.Colors{
        text: "#000000",
        background: "#ffffff",
        primary: "#0066cc"
      }

      # Color scales  
      %ThemeEx.Colors{
        primary: ["#e3f2fd", "#bbdefb", "#90caf9", "#64b5f6", "#42a5f5"]
      }

      # With color modes
      %ThemeEx.Colors{
        text: "#000000",
        background: "#ffffff", 
        primary: "#0066cc",
        modes: %{
          "dark" => %{
            "text" => "#ffffff",
            "background" => "#000000",
            "primary" => "#66ccff"
          }
        }
      }

  """

  defstruct [
    :text,
    :background,
    :primary,
    :secondary,
    :accent,
    :highlight,
    :muted,
    :modes,
    # Additional common colors
    :success,
    :warning,
    :error,
    :info,
    # UI element colors
    :border,
    :surface,
    # Custom color extensions
    :custom
  ]

  @type color_value :: String.t() | list(String.t())

  @type t :: %__MODULE__{
          text: color_value() | nil,
          background: color_value() | nil,
          primary: color_value() | nil,
          secondary: color_value() | nil,
          accent: color_value() | nil,
          highlight: color_value() | nil,
          muted: color_value() | nil,
          modes: map() | nil,
          success: color_value() | nil,
          warning: color_value() | nil,
          error: color_value() | nil,
          info: color_value() | nil,
          border: color_value() | nil,
          surface: color_value() | nil,
          custom: map() | nil
        }
end