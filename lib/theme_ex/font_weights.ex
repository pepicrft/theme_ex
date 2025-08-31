defmodule ThemeEx.FontWeights do
  @moduledoc """
  Font weight definitions for Theme UI themes.
  
  This module defines font weights used for different text elements,
  providing semantic naming for consistent typography weight scales.

  ## Font Weight Categories

  The following semantic font weight categories are supported:

  - `:body` - Default body text font weight
  - `:heading` - Font weight for headings
  - `:bold` - Bold text weight
  - `:normal` - Normal/regular text weight
  - `:light` - Light text weight
  - `:medium` - Medium text weight
  - `:semibold` - Semi-bold text weight
  - `:black` - Black/heavy text weight

  ## Font Weight Values

  Font weights can be defined as:
  - Numeric values: `400`, `700`, `900`
  - String keywords: `"normal"`, `"bold"`, `"lighter"`

  ## Examples

      # Numeric weights
      %ThemeEx.FontWeights{
        body: 400,
        heading: 700,
        bold: 600,
        light: 300
      }

      # String weights  
      %ThemeEx.FontWeights{
        body: "normal",
        heading: "bold",
        bold: "bolder"
      }

      # Mixed values
      %ThemeEx.FontWeights{
        light: 300,
        normal: 400,
        medium: 500,
        semibold: 600,
        bold: 700,
        black: 900
      }

  ## CSS Variable Generation

  Font weights are converted to CSS variables with the pattern:
  - `--theme-fontWeights-body`
  - `--theme-fontWeights-heading`
  - `--theme-fontWeights-bold`

  """

  defstruct [
    :body,
    :heading,
    :bold,
    :normal,
    :light,
    :medium,
    :semibold,
    :black,
    :custom
  ]

  @type font_weight :: number() | String.t()

  @type t :: %__MODULE__{
          body: font_weight() | nil,
          heading: font_weight() | nil,
          bold: font_weight() | nil,
          normal: font_weight() | nil,
          light: font_weight() | nil,
          medium: font_weight() | nil,
          semibold: font_weight() | nil,
          black: font_weight() | nil,
          custom: map() | nil
        }
end