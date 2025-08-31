# ThemeEx

[![Hex.pm](https://img.shields.io/hexpm/v/theme_ex.svg)](https://hex.pm/packages/theme_ex)
[![Documentation](https://img.shields.io/badge/docs-hexdocs-blue.svg)](https://hexdocs.pm/theme_ex)
[![CI](https://github.com/pepicrft/theme_ex/workflows/theme_ex/badge.svg)](https://github.com/pepicrft/theme_ex/actions)
[![License](https://img.shields.io/hexpm/l/theme_ex.svg)](https://github.com/pepicrft/theme_ex/blob/main/LICENSE)

An Elixir package that implements data structures for the [Theme UI theme specification](https://theme-ui.com/theme-spec) and provides utilities for parsing, validation, and CSS variable generation.

## Features

- **Theme Data Structures**: Complete Elixir structs modeling the Theme UI specification
- **JSON Parsing & Validation**: Parse and validate theme JSON with comprehensive error handling
- **JSON Schema Generation**: Generate JSON Schema from theme specifications
- **CSS Variables**: Convert themes to CSS custom properties following naming conventions
- **Type Safety**: Leverage Elixir's pattern matching and type system for theme validation
- **Color Modes**: Support for multiple color modes (light, dark, custom)
- **Responsive Design**: Handle breakpoints and responsive typography scales

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `theme_ex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:theme_ex, "~> 0.1.0"}
  ]
end
```

## Usage

### Basic Theme Creation

```elixir
# Create a theme struct
theme = %ThemeEx.Theme{
  colors: %ThemeEx.Colors{
    text: "#000000",
    background: "#ffffff",
    primary: "#0066cc",
    secondary: "#ff6600"
  },
  fonts: %ThemeEx.Fonts{
    body: "system-ui, sans-serif",
    heading: "Georgia, serif"
  },
  fontSizes: [12, 14, 16, 20, 24, 32, 48, 64]
}
```

### Parse from JSON

```elixir
json_theme = """
{
  "colors": {
    "text": "#000000",
    "background": "#ffffff",
    "primary": "#0066cc"
  },
  "fonts": {
    "body": "system-ui, sans-serif"
  }
}
"""

{:ok, theme} = ThemeEx.from_json(json_theme)
```

### Generate CSS Variables

```elixir
css_variables = ThemeEx.to_css_variables(theme)
# Returns CSS custom properties like:
# --theme-colors-text: #000000;
# --theme-colors-background: #ffffff;
# --theme-fonts-body: system-ui, sans-serif;
```

### Validation

```elixir
case ThemeEx.validate(theme) do
  {:ok, validated_theme} -> 
    # Theme is valid
  {:error, errors} -> 
    # Handle validation errors
end
```

### JSON Schema Generation

```elixir
schema = ThemeEx.json_schema()
# Returns a complete JSON Schema for theme validation
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/theme_ex>.

