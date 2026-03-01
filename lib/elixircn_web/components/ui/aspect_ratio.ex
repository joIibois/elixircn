defmodule ElixircnWeb.Components.UI.AspectRatio do
  use Phoenix.Component

  attr :ratio, :float, default: 1.0
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def aspect_ratio(assigns) do
    ~H"""
    <div
      style={"padding-bottom: #{Float.round(100.0 / @ratio, 4)}%; position: relative;"}
      class={@class}
      {@rest}
    >
      <div class="absolute inset-0">
        {render_slot(@inner_block)}
      </div>
    </div>
    """
  end
end
