defmodule ThemeEx do
  @moduledoc """
  An Elixir package that implements data structures for the Theme UI theme specification
  and provides utilities for parsing, validation, and CSS variable generation.

  ## Usage

      # Create a theme
      theme = %ThemeEx.Theme{
        colors: %ThemeEx.Colors{
          text: "#000000",
          background: "#ffffff",
          primary: "#0066cc"
        },
        fonts: %ThemeEx.Fonts{
          body: "system-ui, sans-serif",
          heading: "Georgia, serif"
        },
        fontSizes: [12, 14, 16, 20, 24, 32, 48, 64]
      }

      # Generate CSS variables
      css = ThemeEx.to_css_variables(theme)

      # Generate JSON Schema
      schema = ThemeEx.json_schema()

      # Validate a theme
      {:ok, validated_theme} = ThemeEx.validate(theme)

  """

  alias ThemeEx.{Theme, Colors, Fonts, FontWeights, LineHeights}

  @doc """
  Parse a theme from JSON string.

  ## Examples

      iex> json = ~s({"colors": {"primary": "#0066cc"}})
      iex> {:ok, theme} = ThemeEx.from_json(json)
      iex> theme.colors.primary
      "#0066cc"

  """
  @spec from_json(String.t()) :: {:ok, Theme.t()} | {:error, term()}
  def from_json(json_string) when is_binary(json_string) do
    with {:ok, data} <- Jason.decode(json_string),
         {:ok, theme} <- from_map(data) do
      {:ok, theme}
    end
  end

  @doc """
  Convert a map to a theme struct.

  ## Examples

      iex> map = %{"colors" => %{"primary" => "#0066cc"}}
      iex> {:ok, theme} = ThemeEx.from_map(map)
      iex> theme.colors.primary
      "#0066cc"

  """
  @spec from_map(map()) :: {:ok, Theme.t()} | {:error, term()}
  def from_map(data) when is_map(data) do
    try do
      theme = %Theme{
        colors: parse_colors(data["colors"]),
        fonts: parse_fonts(data["fonts"]),
        fontWeights: parse_font_weights(data["fontWeights"]),
        lineHeights: parse_line_heights(data["lineHeights"]),
        fontSizes: data["fontSizes"],
        space: data["space"],
        sizes: data["sizes"],
        radii: data["radii"],
        shadows: data["shadows"],
        zIndices: data["zIndices"],
        breakpoints: data["breakpoints"],
        styles: data["styles"],
        variants: data["variants"]
      }
      {:ok, theme}
    rescue
      e -> {:error, e}
    end
  end

  @doc """
  Convert a theme to CSS variables.

  ## Examples

      iex> theme = %ThemeEx.Theme{colors: %ThemeEx.Colors{primary: "#0066cc"}}
      iex> css = ThemeEx.to_css_variables(theme)
      iex> String.contains?(css, "--theme-colors-primary: #0066cc;")
      true

  """
  @spec to_css_variables(Theme.t()) :: String.t()
  def to_css_variables(%Theme{} = theme) do
    css_vars = []
    |> add_colors_css(theme.colors)
    |> add_fonts_css(theme.fonts)
    |> add_font_weights_css(theme.fontWeights)
    |> add_line_heights_css(theme.lineHeights)
    |> add_scale_css("fontSizes", theme.fontSizes)
    |> add_scale_css("space", theme.space)
    |> add_scale_css("sizes", theme.sizes)
    |> add_scale_css("radii", theme.radii)
    |> add_scale_css("shadows", theme.shadows)
    |> add_scale_css("breakpoints", theme.breakpoints)

    ":root {\n" <> Enum.join(css_vars, "\n") <> "\n}"
  end

  @doc """
  Generate JSON Schema for theme validation.

  ## Examples

      iex> schema = ThemeEx.json_schema()
      iex> is_map(schema)
      true

  """
  @spec json_schema() :: map()
  def json_schema do
    %{
      "$schema" => "https://json-schema.org/draft/2020-12/schema",
      "title" => "Theme UI Theme",
      "type" => "object",
      "properties" => %{
        "colors" => colors_schema(),
        "fonts" => fonts_schema(),
        "fontWeights" => font_weights_schema(),
        "lineHeights" => line_heights_schema(),
        "fontSizes" => %{
          "type" => "array",
          "items" => %{"type" => "number"}
        },
        "space" => %{
          "type" => "array",
          "items" => %{
            "oneOf" => [
              %{"type" => "number"},
              %{"type" => "string"}
            ]
          }
        },
        "sizes" => %{
          "type" => "array",
          "items" => %{
            "oneOf" => [
              %{"type" => "number"},
              %{"type" => "string"}
            ]
          }
        },
        "radii" => %{
          "type" => "array",
          "items" => %{
            "oneOf" => [
              %{"type" => "number"},
              %{"type" => "string"}
            ]
          }
        },
        "shadows" => %{
          "type" => "array",
          "items" => %{"type" => "string"}
        },
        "zIndices" => %{
          "type" => "object",
          "additionalProperties" => %{"type" => "number"}
        },
        "breakpoints" => %{
          "type" => "array",
          "items" => %{"type" => "string"}
        },
        "styles" => %{
          "type" => "object",
          "additionalProperties" => true
        },
        "variants" => %{
          "type" => "object",
          "additionalProperties" => true
        }
      },
      "additionalProperties" => false
    }
  end

  @doc """
  Validate a theme struct against the schema.

  ## Examples

      iex> theme = %ThemeEx.Theme{colors: %ThemeEx.Colors{primary: "#0066cc"}}
      iex> {:ok, validated} = ThemeEx.validate(theme)
      iex> validated.colors.primary
      "#0066cc"

  """
  @spec validate(Theme.t()) :: {:ok, Theme.t()} | {:error, list()}
  def validate(%Theme{} = theme) do
    theme_map = to_map(theme)
    schema = json_schema()
    
    case validate_against_schema(theme_map, schema) do
      {:ok, _} -> {:ok, theme}
      {:error, errors} -> {:error, errors}
    end
  end

  # Private functions

  defp parse_colors(nil), do: nil
  defp parse_colors(data) when is_map(data) do
    struct(Colors, atomize_keys(data))
  end

  defp parse_fonts(nil), do: nil
  defp parse_fonts(data) when is_map(data) do
    struct(Fonts, atomize_keys(data))
  end

  defp parse_font_weights(nil), do: nil
  defp parse_font_weights(data) when is_map(data) do
    struct(FontWeights, atomize_keys(data))
  end

  defp parse_line_heights(nil), do: nil
  defp parse_line_heights(data) when is_map(data) do
    struct(LineHeights, atomize_keys(data))
  end

  defp atomize_keys(map) when is_map(map) do
    Map.new(map, fn {k, v} -> {String.to_atom(k), v} end)
  end

  defp add_colors_css(css_vars, nil), do: css_vars
  defp add_colors_css(css_vars, %Colors{} = colors) do
    colors
    |> Map.from_struct()
    |> Enum.reduce(css_vars, fn
      {_, nil}, acc -> acc
      {:modes, modes}, acc when is_map(modes) -> acc
      {key, value}, acc -> 
        [format_css_var("colors", key, value) | acc]
    end)
  end

  defp add_fonts_css(css_vars, nil), do: css_vars
  defp add_fonts_css(css_vars, %Fonts{} = fonts) do
    fonts
    |> Map.from_struct()
    |> Enum.reduce(css_vars, fn
      {_, nil}, acc -> acc
      {:custom, _}, acc -> acc
      {key, value}, acc -> 
        [format_css_var("fonts", key, value) | acc]
    end)
  end

  defp add_font_weights_css(css_vars, nil), do: css_vars
  defp add_font_weights_css(css_vars, %FontWeights{} = font_weights) do
    font_weights
    |> Map.from_struct()
    |> Enum.reduce(css_vars, fn
      {_, nil}, acc -> acc
      {:custom, _}, acc -> acc
      {key, value}, acc -> 
        [format_css_var("fontWeights", key, value) | acc]
    end)
  end

  defp add_line_heights_css(css_vars, nil), do: css_vars
  defp add_line_heights_css(css_vars, %LineHeights{} = line_heights) do
    line_heights
    |> Map.from_struct()
    |> Enum.reduce(css_vars, fn
      {_, nil}, acc -> acc
      {:custom, _}, acc -> acc
      {key, value}, acc -> 
        [format_css_var("lineHeights", key, value) | acc]
    end)
  end

  defp add_scale_css(css_vars, _key, nil), do: css_vars
  defp add_scale_css(css_vars, key, values) when is_list(values) do
    values
    |> Enum.with_index()
    |> Enum.reduce(css_vars, fn {value, index}, acc ->
      [format_css_var(key, index, value) | acc]
    end)
  end
  defp add_scale_css(css_vars, _key, _value), do: css_vars

  defp format_css_var(category, key, value) do
    var_name = "--theme-#{category}-#{key}"
    "  #{var_name}: #{format_css_value(value)};"
  end

  defp format_css_value(value) when is_list(value) do
    Enum.join(value, ", ")
  end
  defp format_css_value(value), do: to_string(value)

  defp colors_schema do
    %{
      "type" => "object",
      "properties" => %{
        "text" => color_property(),
        "background" => color_property(),
        "primary" => color_property(),
        "secondary" => color_property(),
        "accent" => color_property(),
        "highlight" => color_property(),
        "muted" => color_property(),
        "success" => color_property(),
        "warning" => color_property(),
        "error" => color_property(),
        "info" => color_property(),
        "border" => color_property(),
        "surface" => color_property(),
        "modes" => %{
          "type" => "object",
          "additionalProperties" => %{
            "type" => "object",
            "additionalProperties" => color_property()
          }
        }
      },
      "additionalProperties" => color_property()
    }
  end

  defp fonts_schema do
    %{
      "type" => "object",
      "properties" => %{
        "body" => font_property(),
        "heading" => font_property(),
        "monospace" => font_property(),
        "sans" => font_property(),
        "serif" => font_property(),
        "display" => font_property()
      },
      "additionalProperties" => font_property()
    }
  end

  defp font_weights_schema do
    %{
      "type" => "object",
      "additionalProperties" => %{
        "oneOf" => [
          %{"type" => "number"},
          %{"type" => "string"}
        ]
      }
    }
  end

  defp line_heights_schema do
    %{
      "type" => "object",
      "additionalProperties" => %{
        "oneOf" => [
          %{"type" => "number"},
          %{"type" => "string"}
        ]
      }
    }
  end

  defp color_property do
    %{
      "oneOf" => [
        %{"type" => "string"},
        %{
          "type" => "array",
          "items" => %{"type" => "string"}
        }
      ]
    }
  end

  defp font_property do
    %{
      "oneOf" => [
        %{"type" => "string"},
        %{
          "type" => "array",
          "items" => %{"type" => "string"}
        }
      ]
    }
  end

  defp to_map(%Theme{} = theme) do
    theme
    |> Map.from_struct()
    |> Enum.reduce(%{}, fn
      {_, nil}, acc -> acc
      {key, %struct_type{} = value}, acc when struct_type in [Colors, Fonts, FontWeights, LineHeights] ->
        Map.put(acc, Atom.to_string(key), struct_to_map(value))
      {key, value}, acc ->
        Map.put(acc, Atom.to_string(key), value)
    end)
  end

  defp struct_to_map(struct) do
    struct
    |> Map.from_struct()
    |> Enum.reduce(%{}, fn
      {_, nil}, acc -> acc
      {key, value}, acc -> Map.put(acc, Atom.to_string(key), value)
    end)
  end

  defp validate_against_schema(data, schema) do
    case do_validate_schema(data, schema) do
      [] -> {:ok, data}
      errors -> {:error, errors}
    end
  end

  defp do_validate_schema(data, schema) do
    case schema["type"] do
      "object" -> validate_object(data, schema)
      "array" -> validate_array(data, schema)
      _ -> validate_primitive(data, schema)
    end
  end

  defp validate_object(data, schema) when is_map(data) do
    properties = schema["properties"] || %{}
    
    properties
    |> Enum.flat_map(fn {key, prop_schema} ->
      case Map.get(data, key) do
        nil -> []
        value -> do_validate_schema(value, prop_schema)
      end
    end)
  end
  defp validate_object(_, _), do: ["Expected object"]

  defp validate_array(data, schema) when is_list(data) do
    items_schema = schema["items"]
    
    data
    |> Enum.flat_map(fn item ->
      do_validate_schema(item, items_schema)
    end)
  end
  defp validate_array(_, _), do: ["Expected array"]

  defp validate_primitive(data, schema) do
    case schema["oneOf"] do
      nil -> validate_type(data, schema["type"])
      schemas -> validate_one_of(data, schemas)
    end
  end

  defp validate_type(data, "string") when is_binary(data), do: []
  defp validate_type(data, "number") when is_number(data), do: []
  defp validate_type(data, "object") when is_map(data), do: []
  defp validate_type(data, "array") when is_list(data), do: []
  defp validate_type(_, expected), do: ["Expected #{expected}"]

  defp validate_one_of(data, schemas) do
    case Enum.any?(schemas, fn schema -> 
      do_validate_schema(data, schema) == [] 
    end) do
      true -> []
      false -> ["Value does not match any allowed schema"]
    end
  end
end
