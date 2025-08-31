# ThemeEx

[![Hex.pm](https://img.shields.io/hexpm/v/theme_ex.svg)](https://hex.pm/packages/theme_ex)
[![Documentation](https://img.shields.io/badge/docs-hexdocs-blue.svg)](https://hexdocs.pm/theme_ex)
[![CI](https://github.com/pepicrft/theme_ex/workflows/theme_ex/badge.svg)](https://github.com/pepicrft/theme_ex/actions)
[![License](https://img.shields.io/hexpm/l/theme_ex.svg)](https://github.com/pepicrft/theme_ex/blob/main/LICENSE)

An Elixir package that implements data structures for the [Theme UI theme specification](https://theme-ui.com/theme-spec) and provides utilities for parsing, validation, and CSS variable generation.

## Features

- **Complete Theme UI Implementation**: Full support for Theme UI specification including colors, fonts, typography scales, and design tokens
- **Type-Safe Data Structures**: Elixir structs with proper type specifications for all theme components
- **JSON Parsing & Validation**: Parse theme JSON with comprehensive error handling and validation
- **Built-in JSON Schema Generation**: Generate JSON Schema for theme validation without external dependencies
- **CSS Variables Generation**: Convert themes to CSS custom properties with consistent naming conventions
- **Color Modes Support**: Handle multiple color modes (light, dark, custom) with nested color definitions
- **Responsive Design Tokens**: Support for breakpoints, typography scales, spacing, and size systems
- **Comprehensive Validation**: Custom validation logic that ensures theme integrity and type safety

## Installation

Add `theme_ex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:theme_ex, "~> 0.1.0"}
  ]
end
```

## Data Structures

ThemeEx implements the complete Theme UI specification with the following core structures:

- `ThemeEx.Theme` - Main theme container
- `ThemeEx.Colors` - Color palette with semantic colors and modes
- `ThemeEx.Fonts` - Font family definitions
- `ThemeEx.FontWeights` - Font weight specifications  
- `ThemeEx.LineHeights` - Line height definitions

## Usage

### Creating Themes

```elixir
# Create a complete theme
theme = %ThemeEx.Theme{
  colors: %ThemeEx.Colors{
    text: "#000000",
    background: "#ffffff", 
    primary: "#0066cc",
    secondary: "#ff6600",
    modes: %{
      "dark" => %{
        "text" => "#ffffff",
        "background" => "#000000",
        "primary" => "#66ccff"
      }
    }
  },
  fonts: %ThemeEx.Fonts{
    body: "system-ui, -apple-system, sans-serif",
    heading: "Georgia, serif",
    monospace: "Menlo, Monaco, monospace"
  },
  fontWeights: %ThemeEx.FontWeights{
    body: 400,
    heading: 700,
    bold: 600
  },
  fontSizes: [12, 14, 16, 20, 24, 32, 48, 64, 96],
  space: [0, 4, 8, 16, 32, 64, 128, 256],
  breakpoints: ["40em", "52em", "64em"]
}
```

### JSON Parsing

```elixir
# Parse from JSON string
json_theme = """
{
  "colors": {
    "text": "#000000",
    "background": "#ffffff",
    "primary": "#0066cc",
    "modes": {
      "dark": {
        "text": "#ffffff",
        "background": "#000000"
      }
    }
  },
  "fonts": {
    "body": ["system-ui", "sans-serif"],
    "heading": "Georgia, serif"
  },
  "fontSizes": [12, 14, 16, 20, 24, 32]
}
"""

{:ok, theme} = ThemeEx.from_json(json_theme)

# Or from a map
theme_map = %{
  "colors" => %{"primary" => "#0066cc"},
  "fontSizes" => [14, 16, 18, 24]
}

{:ok, theme} = ThemeEx.from_map(theme_map)
```

### CSS Variables Generation

```elixir
theme = %ThemeEx.Theme{
  colors: %ThemeEx.Colors{
    primary: "#0066cc",
    secondary: "#ff6600"
  },
  fonts: %ThemeEx.Fonts{
    body: "system-ui, sans-serif"
  },
  fontSizes: [12, 14, 16, 20]
}

css = ThemeEx.to_css_variables(theme)

# Output:
# :root {
#   --theme-colors-primary: #0066cc;
#   --theme-colors-secondary: #ff6600;
#   --theme-fonts-body: system-ui, sans-serif;
#   --theme-fontSizes-0: 12;
#   --theme-fontSizes-1: 14;
#   --theme-fontSizes-2: 16;
#   --theme-fontSizes-3: 20;
# }
```

### Theme Validation

```elixir
# Validate theme structure and types
case ThemeEx.validate(theme) do
  {:ok, validated_theme} -> 
    IO.puts("Theme is valid!")
    validated_theme
  {:error, errors} -> 
    IO.puts("Validation failed: #{inspect(errors)}")
end
```

### JSON Schema Generation

```elixir
# Generate JSON Schema for external validation
schema = ThemeEx.json_schema()

# Returns a complete JSON Schema following draft/2020-12 specification
%{
  "$schema" => "https://json-schema.org/draft/2020-12/schema",
  "title" => "Theme UI Theme",
  "type" => "object",
  "properties" => %{
    "colors" => %{...},
    "fonts" => %{...},
    # ... complete schema definition
  }
}
```

## Advanced Features

### Font Arrays and Stacks

```elixir
# Fonts can be defined as strings or arrays
fonts = %ThemeEx.Fonts{
  body: ["Helvetica Neue", "Arial", "sans-serif"],
  heading: "Georgia, serif"
}
```

### Color Arrays and Scales

```elixir
# Colors support both single values and scales
colors = %ThemeEx.Colors{
  primary: ["#e3f2fd", "#bbdefb", "#90caf9", "#64b5f6", "#42a5f5"],
  text: "#000000"
}
```

### Responsive Design Tokens

```elixir
theme = %ThemeEx.Theme{
  space: [0, 4, 8, 16, 32, 64, 128],        # Spacing scale
  sizes: [16, 32, 64, 128, 256, 512, 768],  # Size scale  
  radii: [0, 2, 4, 8, 16],                  # Border radius scale
  shadows: [                                # Box shadow definitions
    "none",
    "0 1px 3px rgba(0,0,0,0.12)",
    "0 4px 6px rgba(0,0,0,0.16)"
  ],
  breakpoints: ["40em", "52em", "64em"]     # Media query breakpoints
}
```

## API Reference

### Core Functions

- `ThemeEx.from_json/1` - Parse theme from JSON string
- `ThemeEx.from_map/1` - Convert map to theme struct
- `ThemeEx.to_css_variables/1` - Generate CSS custom properties
- `ThemeEx.json_schema/0` - Generate JSON Schema for validation
- `ThemeEx.validate/1` - Validate theme structure and types

### Data Structures

All structs include proper type specifications and support for both single values and arrays where appropriate by the Theme UI specification.

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Run tests (`mix test`)
4. Commit your changes (`git commit -m 'Add amazing feature'`)
5. Push to the branch (`git push origin feature/amazing-feature`)
6. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## References

- [Theme UI Specification](https://theme-ui.com/theme-spec)
- [JSON Schema Specification](https://json-schema.org/)
- [CSS Custom Properties](https://developer.mozilla.org/en-US/docs/Web/CSS/--*)

