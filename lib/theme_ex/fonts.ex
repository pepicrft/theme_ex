defmodule ThemeEx.Fonts do
  @moduledoc """
  Font family definitions for Theme UI themes.
  
  This module defines font stacks used throughout the theme for different
  text elements, following the Theme UI specification for typography.

  ## Font Categories

  The following semantic font categories are supported:

  - `:body` - Default body text font
  - `:heading` - Font for headings (h1, h2, etc.)
  - `:monospace` - Monospace font for code
  - `:sans` - Sans-serif font family
  - `:serif` - Serif font family  
  - `:display` - Display/decorative font for large text

  ## Font Stack Format

  Fonts can be defined as:
  - Single font string: `"Georgia, serif"`
  - Font stack array: `["Helvetica Neue", "Arial", "sans-serif"]`

  ## Examples

      # String format
      %ThemeEx.Fonts{
        body: "system-ui, -apple-system, sans-serif",
        heading: "Georgia, serif",
        monospace: "Menlo, Monaco, monospace"
      }

      # Array format for explicit fallbacks
      %ThemeEx.Fonts{
        body: ["Helvetica Neue", "Arial", "sans-serif"],
        heading: ["Georgia", "Times", "serif"],
        monospace: ["SF Mono", "Monaco", "Inconsolata", "monospace"]
      }

      # Mixed formats
      %ThemeEx.Fonts{
        body: ["Inter", "system-ui", "sans-serif"],
        heading: "Georgia, serif",
        monospace: "Fira Code, monospace"
      }

  ## CSS Variable Generation

  Font definitions are converted to CSS variables with the pattern:
  - `--theme-fonts-body`
  - `--theme-fonts-heading`
  - `--theme-fonts-monospace`

  """

  defstruct [
    :body,
    :heading,
    :monospace,
    :sans,
    :serif,
    :display,
    :custom
  ]

  @type font_stack :: String.t() | list(String.t())

  @type t :: %__MODULE__{
          body: font_stack() | nil,
          heading: font_stack() | nil,
          monospace: font_stack() | nil,
          sans: font_stack() | nil,
          serif: font_stack() | nil,
          display: font_stack() | nil,
          custom: map() | nil
        }
end