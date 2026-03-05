defmodule Mix.Tasks.Elixircn.Install do
  use Mix.Task

  @shortdoc "Patches *_web.ex to resolve CoreComponents naming conflicts with elixircn"

  @moduledoc """
  Patches your `*_web.ex` file to exclude the four Phoenix CoreComponents functions
  that conflict with elixircn: `button/1`, `input/1`, `icon/1`, and `table/1`.

  ## Usage

      mix elixircn.install

  The task will:
    1. Locate `lib/*_web.ex` automatically
    2. Find the `import YourAppWeb.CoreComponents` line in `html_helpers/0`
    3. Add or merge `except: [input: 1, icon: 1, button: 1, table: 1]`

  If your file cannot be patched automatically, manual instructions are printed.
  """

  @conflicts ["button: 1", "input: 1", "icon: 1", "table: 1"]

  @impl Mix.Task
  def run(_args) do
    case find_web_file() do
      nil ->
        Mix.shell().error("Could not find a *_web.ex file in lib/.")
        print_manual_instructions()

      path ->
        patch(path)
    end
  end

  # ── file discovery ──────────────────────────────────────────────────────────

  defp find_web_file do
    case File.ls("lib") do
      {:ok, entries} ->
        Enum.find_value(entries, fn name ->
          if String.ends_with?(name, "_web.ex"), do: Path.join("lib", name)
        end)

      {:error, _} ->
        nil
    end
  end

  # ── patching logic ──────────────────────────────────────────────────────────

  defp patch(path) do
    content = File.read!(path)

    cond do
      all_conflicts_excluded?(content) ->
        Mix.shell().info("#{path} already excludes all conflicting CoreComponents functions. Nothing to do.")

      has_bare_import?(content) ->
        patched = add_except_to_bare_import(content)
        File.write!(path, patched)
        Mix.shell().info("✓ Patched #{path}")
        Mix.shell().info("  import YourAppWeb.CoreComponents, except: [input: 1, icon: 1, button: 1, table: 1]")

      has_except_import?(content) ->
        {patched, added} = merge_into_existing_except(content)

        if added == [] do
          Mix.shell().info("#{path} already excludes all conflicting CoreComponents functions. Nothing to do.")
        else
          File.write!(path, patched)
          Mix.shell().info("✓ Patched #{path}")
          Mix.shell().info("  Added to existing except: #{Enum.join(added, ", ")}")
        end

      String.contains?(content, "CoreComponents") ->
        Mix.shell().error("Found CoreComponents in #{path} but could not parse the import line.")
        Mix.shell().error("The import may span multiple lines or use an unexpected format.")
        print_manual_instructions()

      true ->
        Mix.shell().error("No CoreComponents import found in #{path}.")
        print_manual_instructions()
    end
  end

  # Does the file already exclude all four?
  defp all_conflicts_excluded?(content) do
    Enum.all?(@conflicts, &String.contains?(content, &1))
  end

  # `import XxxWeb.CoreComponents` with no except clause
  defp has_bare_import?(content) do
    Regex.match?(~r/import \w+Web\.CoreComponents\s*\n/, content)
  end

  # `import XxxWeb.CoreComponents, except: [...]`
  defp has_except_import?(content) do
    Regex.match?(~r/import \w+Web\.CoreComponents,\s*except:\s*\[/, content)
  end

  defp add_except_to_bare_import(content) do
    Regex.replace(
      ~r/(import \w+Web\.CoreComponents)(\s*\n)/,
      content,
      "\\1, except: [input: 1, icon: 1, button: 1, table: 1]\\2",
      global: false
    )
  end

  defp merge_into_existing_except(content) do
    missing = Enum.reject(@conflicts, &String.contains?(content, &1))

    if missing == [] do
      {content, []}
    else
      patched =
        Regex.replace(
          ~r/(import \w+Web\.CoreComponents,\s*except:\s*\[)([^\]]*?)(\])/,
          content,
          fn _, prefix, existing_items, suffix ->
            existing = String.trim(existing_items)

            appended =
              if existing == "" do
                Enum.join(missing, ", ")
              else
                existing <> ", " <> Enum.join(missing, ", ")
              end

            prefix <> appended <> suffix
          end,
          global: false
        )

      {patched, missing}
    end
  end

  # ── fallback instructions ───────────────────────────────────────────────────

  defp print_manual_instructions do
    Mix.shell().info("""

    Manual fix — in your `my_app_web.ex`, inside `html_helpers/0`:

        import MyAppWeb.CoreComponents, except: [input: 1, icon: 1, button: 1, table: 1]

    Replace `MyAppWeb` with your application's module prefix.
    """)
  end
end
