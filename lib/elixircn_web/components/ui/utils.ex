defmodule ElixircnWeb.Components.UI.Utils do
  @moduledoc "Provides utility functions for Tailwind CSS class merging and form error translation."
  @doc """
  Merges Tailwind CSS classes with conflict resolution.

  Accepts a list of class strings, `nil`, or `false` values (falsy values are
  filtered out). Later classes override earlier ones when they target the same
  CSS property — e.g. `cn(["px-4 py-2", "px-6"])` returns `"py-2 px-6"`.

  This is the Elixir equivalent of shadcn/ui's `cn()` utility.
  """
  def cn(classes) when is_list(classes) do
    classes
    |> Enum.reject(&(!&1))
    |> Enum.join(" ")
    |> TwMerge.merge()
  end

  @doc "Merges a single binary class string through TwMerge for conflict resolution."
  def cn(class) when is_binary(class), do: TwMerge.merge(class)

  @doc "Returns nil when given nil."
  def cn(nil), do: nil

  @doc "Ignores unexpected types (atoms, integers, etc.) by returning nil."
  def cn(_), do: nil

  @doc "Translates a form error tuple into a human-readable string by interpolating option values."
  def translate_error({msg, opts}) do
    Enum.reduce(opts, msg, fn {key, value}, acc ->
      String.replace(acc, "%{#{key}}", fn _ -> to_string(value) end)
    end)
  end
end
