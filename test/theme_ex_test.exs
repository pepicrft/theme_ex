defmodule ThemeExTest do
  use ExUnit.Case

  alias ThemeEx.{Theme, Colors, Fonts, FontWeights, LineHeights}

  doctest ThemeEx

  describe "from_json/1" do
    test "parses valid JSON theme" do
      json = """
      {
        "colors": {
          "primary": "#0066cc",
          "secondary": "#ff6600",
          "text": "#000000",
          "background": "#ffffff"
        },
        "fonts": {
          "body": "system-ui, sans-serif",
          "heading": "Georgia, serif"
        },
        "fontSizes": [12, 14, 16, 20, 24, 32, 48, 64]
      }
      """

      {:ok, theme} = ThemeEx.from_json(json)

      assert theme.colors.primary == "#0066cc"
      assert theme.colors.secondary == "#ff6600"
      assert theme.colors.text == "#000000"
      assert theme.colors.background == "#ffffff"
      assert theme.fonts.body == "system-ui, sans-serif"
      assert theme.fonts.heading == "Georgia, serif"
      assert theme.fontSizes == [12, 14, 16, 20, 24, 32, 48, 64]
    end

    test "handles invalid JSON" do
      json = "{ invalid json }"
      assert {:error, _} = ThemeEx.from_json(json)
    end
  end

  describe "from_map/1" do
    test "converts map to theme struct" do
      map = %{
        "colors" => %{
          "primary" => "#0066cc",
          "text" => "#000000"
        },
        "fonts" => %{
          "body" => "Arial, sans-serif"
        },
        "fontSizes" => [14, 16, 18]
      }

      {:ok, theme} = ThemeEx.from_map(map)

      assert theme.colors.primary == "#0066cc"
      assert theme.colors.text == "#000000"
      assert theme.fonts.body == "Arial, sans-serif"
      assert theme.fontSizes == [14, 16, 18]
    end

    test "handles empty map" do
      {:ok, theme} = ThemeEx.from_map(%{})
      assert %Theme{} = theme
    end
  end

  describe "to_css_variables/1" do
    test "generates CSS variables from theme" do
      theme = %Theme{
        colors: %Colors{
          primary: "#0066cc",
          secondary: "#ff6600",
          text: "#000000"
        },
        fonts: %Fonts{
          body: "system-ui, sans-serif",
          heading: "Georgia, serif"
        },
        fontSizes: [12, 14, 16, 20]
      }

      css = ThemeEx.to_css_variables(theme)

      assert String.contains?(css, "--theme-colors-primary: #0066cc;")
      assert String.contains?(css, "--theme-colors-secondary: #ff6600;")
      assert String.contains?(css, "--theme-colors-text: #000000;")
      assert String.contains?(css, "--theme-fonts-body: system-ui, sans-serif;")
      assert String.contains?(css, "--theme-fonts-heading: Georgia, serif;")
      assert String.contains?(css, "--theme-fontSizes-0: 12;")
      assert String.contains?(css, "--theme-fontSizes-1: 14;")
      assert String.contains?(css, "--theme-fontSizes-2: 16;")
      assert String.contains?(css, "--theme-fontSizes-3: 20;")
      assert String.starts_with?(css, ":root {")
      assert String.ends_with?(css, "}")
    end

    test "handles theme with font arrays" do
      theme = %Theme{
        fonts: %Fonts{
          body: ["Helvetica Neue", "Arial", "sans-serif"]
        }
      }

      css = ThemeEx.to_css_variables(theme)
      assert String.contains?(css, "--theme-fonts-body: Helvetica Neue, Arial, sans-serif;")
    end

    test "skips nil values" do
      theme = %Theme{
        colors: %Colors{primary: "#0066cc"},
        fonts: nil
      }

      css = ThemeEx.to_css_variables(theme)
      assert String.contains?(css, "--theme-colors-primary: #0066cc;")
      refute String.contains?(css, "fonts")
    end
  end

  describe "json_schema/0" do
    test "generates valid JSON schema" do
      schema = ThemeEx.json_schema()

      assert schema["$schema"] == "https://json-schema.org/draft/2020-12/schema"
      assert schema["title"] == "Theme UI Theme"
      assert schema["type"] == "object"
      assert is_map(schema["properties"])
      assert Map.has_key?(schema["properties"], "colors")
      assert Map.has_key?(schema["properties"], "fonts")
      assert Map.has_key?(schema["properties"], "fontSizes")
    end

    test "colors schema allows string or array" do
      schema = ThemeEx.json_schema()
      colors_schema = schema["properties"]["colors"]
      primary_schema = colors_schema["properties"]["primary"]

      assert primary_schema["oneOf"] == [
               %{"type" => "string"},
               %{"type" => "array", "items" => %{"type" => "string"}}
             ]
    end
  end

  describe "validate/1" do
    test "validates valid theme" do
      theme = %Theme{
        colors: %Colors{primary: "#0066cc"},
        fonts: %Fonts{body: "Arial, sans-serif"},
        fontSizes: [12, 14, 16]
      }

      assert {:ok, ^theme} = ThemeEx.validate(theme)
    end

    test "validates theme with complex color modes" do
      theme = %Theme{
        colors: %Colors{
          primary: "#0066cc",
          modes: %{
            "dark" => %{"primary" => "#66ccff", "text" => "#ffffff"}
          }
        }
      }

      assert {:ok, ^theme} = ThemeEx.validate(theme)
    end

    test "validates theme with font arrays" do
      theme = %Theme{
        fonts: %Fonts{
          body: ["Helvetica Neue", "Arial", "sans-serif"]
        }
      }

      assert {:ok, ^theme} = ThemeEx.validate(theme)
    end
  end

  describe "theme struct types" do
    test "Colors struct has correct fields" do
      colors = %Colors{
        text: "#000000",
        background: "#ffffff",
        primary: "#0066cc",
        secondary: "#ff6600"
      }

      assert colors.text == "#000000"
      assert colors.background == "#ffffff"
      assert colors.primary == "#0066cc"
      assert colors.secondary == "#ff6600"
    end

    test "Fonts struct has correct fields" do
      fonts = %Fonts{
        body: "Arial, sans-serif",
        heading: "Georgia, serif",
        monospace: "Menlo, monospace"
      }

      assert fonts.body == "Arial, sans-serif"
      assert fonts.heading == "Georgia, serif"
      assert fonts.monospace == "Menlo, monospace"
    end

    test "FontWeights struct has correct fields" do
      font_weights = %FontWeights{
        body: 400,
        heading: 700,
        bold: 600
      }

      assert font_weights.body == 400
      assert font_weights.heading == 700
      assert font_weights.bold == 600
    end

    test "LineHeights struct has correct fields" do
      line_heights = %LineHeights{
        body: 1.5,
        heading: 1.25,
        solid: 1.0
      }

      assert line_heights.body == 1.5
      assert line_heights.heading == 1.25
      assert line_heights.solid == 1.0
    end
  end

  describe "edge cases and error handling" do
    test "handles partial theme data" do
      json = """
      {
        "colors": {
          "primary": "#0066cc"
        }
      }
      """

      {:ok, theme} = ThemeEx.from_json(json)
      assert theme.colors.primary == "#0066cc"
      assert theme.colors.secondary == nil
      assert theme.fonts == nil
    end

    test "CSS variables generation with empty theme" do
      theme = %Theme{}
      css = ThemeEx.to_css_variables(theme)
      assert css == ":root {\n\n}"
    end

    test "validates empty theme" do
      theme = %Theme{}
      assert {:ok, ^theme} = ThemeEx.validate(theme)
    end
  end
end
