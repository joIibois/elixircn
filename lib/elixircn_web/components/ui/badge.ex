defmodule ElixircnWeb.Components.UI.Badge do
  @moduledoc "Provides a badge component for displaying short status labels with variant styling."
  use Phoenix.Component
  import ElixircnWeb.Components.UI.Utils

  attr :variant, :string,
    default: "default",
    values: ~w(default secondary destructive outline)

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders a small inline badge with a configurable variant style."
  def badge(assigns) do
    ~H"""
    <span
      class={cn([
        "inline-flex items-center rounded-md border px-2.5 py-0.5 text-xs font-semibold transition-colors focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2",
        badge_variant(@variant),
        @class
      ])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </span>
    """
  end

  defp badge_variant("default"),
    do: "border-transparent bg-primary text-primary-foreground shadow"

  defp badge_variant("secondary"),
    do: "border-transparent bg-secondary text-secondary-foreground"

  defp badge_variant("destructive"),
    do: "border-transparent bg-destructive text-destructive-foreground shadow"

  defp badge_variant("outline"),
    do: "text-foreground"
end
