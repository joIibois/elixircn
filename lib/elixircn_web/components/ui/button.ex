defmodule ElixircnWeb.Components.UI.Button do
  use Phoenix.Component

  attr :variant, :string, default: "default",
    values: ~w(default destructive outline secondary ghost link)
  attr :size, :string, default: "default",
    values: ~w(default sm lg icon)
  attr :class, :string, default: nil
  attr :disabled, :boolean, default: false
  attr :type, :string, default: "button"
  attr :rest, :global, include: ~w(phx-click phx-target phx-submit phx-value-id phx-disable-with form name value)

  slot :inner_block, required: true

  def button(assigns) do
    ~H"""
    <button
      type={@type}
      disabled={@disabled}
      class={[
        "inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md text-sm font-medium transition-colors focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:pointer-events-none disabled:opacity-50 [&_svg]:pointer-events-none [&_svg]:size-4 [&_svg]:shrink-0",
        button_variant(@variant),
        button_size(@size),
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </button>
    """
  end

  defp button_variant("default"),
    do: "bg-primary text-primary-foreground shadow hover:bg-primary/90"
  defp button_variant("destructive"),
    do: "bg-destructive text-destructive-foreground shadow-sm hover:bg-destructive/90"
  defp button_variant("outline"),
    do: "border border-input bg-background shadow-sm hover:bg-accent hover:text-accent-foreground"
  defp button_variant("secondary"),
    do: "bg-secondary text-secondary-foreground shadow-sm hover:bg-secondary/80"
  defp button_variant("ghost"),
    do: "hover:bg-accent hover:text-accent-foreground"
  defp button_variant("link"),
    do: "text-primary underline-offset-4 hover:underline"

  defp button_size("default"), do: "h-9 px-4 py-2"
  defp button_size("sm"),      do: "h-8 rounded-md px-3 text-xs"
  defp button_size("lg"),      do: "h-10 rounded-md px-8"
  defp button_size("icon"),    do: "h-9 w-9"
end
