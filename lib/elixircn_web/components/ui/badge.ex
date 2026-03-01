defmodule ElixircnWeb.Components.UI.Badge do
  use Phoenix.Component

  attr :variant, :string, default: "default",
    values: ~w(default secondary destructive outline)
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def badge(assigns) do
    ~H"""
    <span
      class={[badge_variant(@variant), @class]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </span>
    """
  end

  defp badge_variant("default"),
    do: "inline-flex items-center rounded-md border border-transparent bg-primary px-2.5 py-0.5 text-xs font-semibold text-primary-foreground shadow transition-colors focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2"
  defp badge_variant("secondary"),
    do: "inline-flex items-center rounded-md border border-transparent bg-secondary px-2.5 py-0.5 text-xs font-semibold text-secondary-foreground transition-colors focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2"
  defp badge_variant("destructive"),
    do: "inline-flex items-center rounded-md border border-transparent bg-destructive px-2.5 py-0.5 text-xs font-semibold text-destructive-foreground shadow transition-colors focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2"
  defp badge_variant("outline"),
    do: "inline-flex items-center rounded-md border px-2.5 py-0.5 text-xs font-semibold transition-colors focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 text-foreground"
end
