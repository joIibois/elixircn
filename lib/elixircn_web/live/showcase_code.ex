defmodule ElixircnWeb.ShowcaseCode do
  @moduledoc "Serves component source files for the showcase code viewer."

  # Resolved at compile time relative to this file's location
  @ui_dir Path.expand("../components/ui", __DIR__)

  def snippet(component) do
    filename = String.replace(component, "-", "_") <> ".ex"
    path = Path.join(@ui_dir, filename)

    case File.read(path) do
      {:ok, content} -> String.trim(content)
      {:error, _} -> "# Source not found: #{filename}"
    end
  end
end
