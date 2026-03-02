defmodule Mix.Tasks.Registry.Build do
  use Mix.Task

  @shortdoc "Builds the shadcn-compatible component registry JSON into docs/r/"

  @registry_name "elixircn"
  @homepage "https://joIibois.github.io/elixircn"
  @output_dir "docs/r"
  @components_dir "lib/elixircn_web/components/ui"

  # Components that depend on other registry items (only real code imports)
  @dependencies %{
    "accordion" => ["icon"],
    "alert-dialog" => ["button"],
    "breadcrumb" => ["icon"],
    "button-group" => ["button"],
    "calendar" => ["icon"],
    "carousel" => ["icon"],
    "combobox" => ["icon"],
    "command" => ["icon"],
    "data-table" => ["table"],
    "date-picker" => ["calendar", "icon"],
    "input-group" => ["input"],
    "navigation-menu" => ["icon"],
    "pagination" => ["icon"],
    "resizable" => ["icon"],
    "select" => ["icon"],
    "toast" => ["icon"],
    "toggle-group" => ["toggle"]
  }

  # Components that require a JS hook in app.js
  @js_hooks %{
    "avatar" => "AvatarFallback",
    "carousel" => "Carousel",
    "combobox" => "ComboboxFilter",
    "context-menu" => "ContextMenu",
    "input-otp" => "InputOtp",
    "resizable" => "Resizable",
    "select" => "SelectLabel",
    "tabs" => "Tabs",
    "toast" => "Toast"
  }

  # Manual title overrides for acronyms and special casing
  @title_overrides %{
    "input-otp" => "Input OTP",
    "kbd" => "KBD"
  }

  @impl Mix.Task
  def run(_args) do
    Mix.shell().info("Building elixircn registry → #{@output_dir}/\n")
    File.mkdir_p!(@output_dir)

    items =
      @components_dir
      |> File.ls!()
      |> Enum.filter(&String.ends_with?(&1, ".ex"))
      |> Enum.sort()
      |> Enum.map(&build_item/1)

    # Write individual component JSON files (with file content)
    Enum.each(items, fn item ->
      path = Path.join(@output_dir, "#{item["name"]}.json")

      json =
        item
        |> Map.put("$schema", "https://ui.shadcn.com/schema/registry-item.json")
        |> Jason.encode!(pretty: true)

      File.write!(path, json)
      Mix.shell().info("  ✓ #{item["name"]}.json")
    end)

    # Write registry.json index (files without content — just path/type/target)
    registry = %{
      "$schema" => "https://ui.shadcn.com/schema/registry.json",
      "name" => @registry_name,
      "homepage" => @homepage,
      "items" => Enum.map(items, &strip_content/1)
    }

    registry_path = Path.join(@output_dir, "registry.json")
    File.write!(registry_path, Jason.encode!(registry, pretty: true))
    Mix.shell().info("\n  ✓ registry.json")
    Mix.shell().info("\nDone! #{length(items)} components registered.")
    Mix.shell().info("\nInstall a component:")
    Mix.shell().info("  npx shadcn@latest add #{@homepage}/r/button.json")
  end

  defp build_item(filename) do
    name = filename_to_name(filename)
    title = Map.get(@title_overrides, name, default_title(name))
    module = filename_to_module(filename)
    raw_content = File.read!(Path.join(@components_dir, filename))
    content = String.replace(raw_content, "ElixircnWeb", "MyAppWeb")

    # Auto-detect utils dependency from source imports
    deps = Map.get(@dependencies, name, [])

    deps =
      if name != "utils" && String.contains?(raw_content, "import ElixircnWeb.Components.UI.Utils") do
        Enum.uniq(["utils" | deps])
      else
        deps
      end

    docs = build_docs(name, module)

    %{
      "name" => name,
      "type" => "registry:item",
      "title" => title,
      "description" => "A Phoenix LiveView #{title} component.",
      "docs" => docs,
      "registryDependencies" => deps,
      "files" => [
        %{
          "path" => "registry/#{filename}",
          "type" => "registry:file",
          "target" => "lib/my_app_web/components/ui/#{filename}",
          "content" => content
        }
      ]
    }
  end

  defp filename_to_name(filename) do
    filename
    |> String.replace_suffix(".ex", "")
    |> String.replace("_", "-")
  end

  defp filename_to_module(filename) do
    filename
    |> String.replace_suffix(".ex", "")
    |> Macro.camelize()
  end

  defp default_title(name) do
    name
    |> String.split("-")
    |> Enum.map(&String.capitalize/1)
    |> Enum.join(" ")
  end

  defp build_docs(name, module) do
    base =
      if name == "utils" do
        """
        This is a shared utility module used by most components for Tailwind CSS class merging.

        Add `{:tw_merge, "~> 0.1"}` to your `mix.exs` deps, then run `mix deps.get`.

        Place this file at `lib/my_app_web/components/ui/utils.ex`.
        Replace `MyAppWeb` with your application's module prefix.\
        """
      else
        """
        Add to the `html_helpers` function in your `my_app_web.ex`:

            import MyAppWeb.Components.UI.#{module}

        Replace `MyAppWeb` with your application's module prefix.\
        """
      end

    case Map.get(@js_hooks, name) do
      nil ->
        base

      hook ->
        base <>
          "\n\nThis component requires the `#{hook}` JS hook. " <>
          "Copy it from the `Hooks.#{hook}` block in:\n" <>
          "https://github.com/joIibois/elixircn/blob/master/assets/js/app.js"
    end
  end

  defp strip_content(item) do
    files = Enum.map(item["files"], &Map.delete(&1, "content"))
    Map.put(item, "files", files)
  end
end
