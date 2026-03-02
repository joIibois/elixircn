defmodule ElixircnWeb.Components.UI.Toggle do
  @moduledoc "Provides a two-state toggle button component with variant and size options."
  use Phoenix.Component
  alias Phoenix.LiveView.JS
  import ElixircnWeb.Components.UI.Utils

  attr :id, :string, required: true
  attr :variant, :string, default: "default", values: ~w(default outline)
  attr :size, :string, default: "default", values: ~w(default sm lg)
  attr :pressed, :boolean, default: false
  attr :disabled, :boolean, default: false
  attr :class, :any, default: nil
  attr :"phx-click", :any, default: nil, doc: "Additional JS commands chained after the built-in toggle"
  attr :rest, :global, include: ~w(form name value data-confirm)

  slot :inner_block, required: true

  @doc "Renders a toggle button that switches between pressed and unpressed states."
  def toggle(assigns) do
    extra_click = assigns[:"phx-click"]

    base_js =
      JS.toggle_attribute({"data-state", "on", "off"})
      |> JS.toggle_attribute({"aria-pressed", "true", "false"})

    assigns = assign(assigns, :toggle_js, if(extra_click, do: JS.concat(base_js, extra_click), else: base_js))

    ~H"""
    <button
      type="button"
      role="button"
      id={@id}
      aria-pressed={to_string(@pressed)}
      disabled={@disabled}
      data-state={if @pressed, do: "on", else: "off"}
      phx-update="ignore"
      phx-click={@toggle_js}
      class={cn([
        "inline-flex items-center justify-center gap-2 rounded-md text-sm font-medium transition-colors hover:bg-muted hover:text-muted-foreground focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:pointer-events-none disabled:opacity-50 data-[state=on]:bg-accent data-[state=on]:text-accent-foreground [&_svg]:pointer-events-none [&_svg]:size-4 [&_svg]:shrink-0",
        toggle_variant(@variant),
        toggle_size(@size),
        @class
      ])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </button>
    """
  end

  defp toggle_variant("default"), do: "bg-transparent"

  defp toggle_variant("outline"),
    do:
      "border border-input bg-transparent shadow-sm hover:bg-accent hover:text-accent-foreground"

  defp toggle_size("default"), do: "h-9 px-2 min-w-9"
  defp toggle_size("sm"), do: "h-8 px-1.5 min-w-8"
  defp toggle_size("lg"), do: "h-10 px-2.5 min-w-10"
end
