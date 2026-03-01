defmodule ElixircnWeb.Components.UI.Tooltip do
  use Phoenix.Component

  attr :id, :string, default: nil
  attr :content, :string, required: true
  attr :side, :string, default: "top", values: ~w(top bottom left right)
  attr :class, :string, default: nil
  slot :inner_block, required: true

  def tooltip(assigns) do
    ~H"""
    <div id={@id} class="group relative inline-flex">
      {render_slot(@inner_block)}
      <div
        role="tooltip"
        class={[
          "pointer-events-none absolute z-50 max-w-xs rounded-md bg-primary px-3 py-1.5 text-xs text-primary-foreground whitespace-nowrap opacity-0 group-hover:opacity-100 transition-opacity duration-150",
          tooltip_position(@side),
          @class
        ]}
      >
        {@content}
      </div>
    </div>
    """
  end

  defp tooltip_position("top"),    do: "bottom-full left-1/2 -translate-x-1/2 mb-2"
  defp tooltip_position("bottom"), do: "top-full left-1/2 -translate-x-1/2 mt-2"
  defp tooltip_position("left"),   do: "right-full top-1/2 -translate-y-1/2 mr-2"
  defp tooltip_position("right"),  do: "left-full top-1/2 -translate-y-1/2 ml-2"
end
