defmodule ElixircnWeb.Components.UI.Button do
  @moduledoc "Provides a button component with multiple variants and sizes."
  use Phoenix.Component
  import ElixircnWeb.Components.UI.Utils

  attr :variant, :string,
    default: "default",
    values: ~w(default destructive outline secondary ghost)

  attr :size, :string,
    default: "default",
    values: ~w(default sm lg icon)

  attr :class, :any, default: nil
  attr :disabled, :boolean, default: false
  attr :type, :string, default: "button"

  attr :rest, :global, include: ~w(form name value data-confirm)

  slot :inner_block, required: true

  @doc "Renders a styled button element with configurable variant, size, and disabled state."
  def button(assigns) do
    ~H"""
    <button
      type={@type}
      disabled={@disabled}
      class={cn([
        "inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md text-sm font-medium transition-colors cursor-pointer focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:pointer-events-none disabled:opacity-50 [&_svg]:pointer-events-none [&_svg]:size-4 [&_svg]:shrink-0",
        button_variant(@variant),
        button_size(@size),
        @class
      ])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </button>
    """
  end

  attr :href, :string, required: true
  attr :navigate, :string, default: nil
  attr :patch, :string, default: nil
  attr :size, :string, default: "default", values: ~w(default sm lg icon)
  attr :class, :any, default: nil
  attr :rest, :global, include: ~w(target rel download)

  slot :inner_block, required: true

  @doc "Renders a link styled with button-link appearance using a semantic <a> tag."
  def link_button(assigns) do
    ~H"""
    <.link
      href={@href}
      navigate={@navigate}
      patch={@patch}
      class={cn([
        "inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md text-sm font-medium transition-colors focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring [&_svg]:pointer-events-none [&_svg]:size-4 [&_svg]:shrink-0",
        "text-primary underline-offset-4 hover:underline",
        button_size(@size),
        @class
      ])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </.link>
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

  defp button_size("default"), do: "h-9 px-4 py-2"
  defp button_size("sm"), do: "h-8 rounded-md px-3 text-xs"
  defp button_size("lg"), do: "h-10 rounded-md px-8"
  defp button_size("icon"), do: "h-9 w-9"
end
