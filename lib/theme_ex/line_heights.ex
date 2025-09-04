defmodule ThemeEx.LineHeights do
  @moduledoc """
  Line height definitions for Theme UI themes.

  This module defines line heights used for different text elements,
  providing semantic naming for consistent typography vertical spacing.

  ## Line Height Categories

  The following semantic line height categories are supported:

  - `:body` - Default body text line height
  - `:heading` - Line height for headings
  - `:solid` - Solid/tight line height (usually 1.0)
  - `:title` - Line height for titles
  - `:copy` - Line height for body copy/paragraphs

  ## Line Height Values

  Line heights can be defined as:
  - Unitless numbers: `1.5`, `1.25`, `2.0` (relative to font size)
  - String values with units: `"24px"`, `"1.5em"`, `"150%"`

  ## Examples

      # Unitless values (recommended)
      %ThemeEx.LineHeights{
        body: 1.5,
        heading: 1.25,
        solid: 1.0,
        title: 1.125
      }

      # String values with units
      %ThemeEx.LineHeights{
        body: "1.5",
        heading: "24px",
        solid: "1em"
      }

      # Mixed values
      %ThemeEx.LineHeights{
        solid: 1.0,
        title: 1.125,
        copy: 1.5,
        body: "1.6"
      }

  ## CSS Variable Generation

  Line heights are converted to CSS variables with the pattern:
  - `--theme-lineHeights-body`
  - `--theme-lineHeights-heading`
  - `--theme-lineHeights-solid`

  ## Best Practices

  - Use unitless values when possible for better scaling
  - Body text typically uses line heights between 1.4-1.6
  - Headings often use tighter line heights (1.1-1.3)
  - Large display text may use solid line height (1.0)

  """

  defstruct [
    :body,
    :heading,
    :solid,
    :title,
    :copy,
    :custom
  ]

  @type line_height :: number() | String.t()

  @type t :: %__MODULE__{
          body: line_height() | nil,
          heading: line_height() | nil,
          solid: line_height() | nil,
          title: line_height() | nil,
          copy: line_height() | nil,
          custom: map() | nil
        }
end
