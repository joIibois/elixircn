defmodule ElixircnWeb.Components.UI.AspectRatio do
  @moduledoc "Provides an aspect ratio component for maintaining consistent width-to-height proportions."
  use Phoenix.Component
  import ElixircnWeb.Components.UI.Utils

  attr :ratio, :float, default: 1.0
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders a container that enforces a zero-ratio guard, falling back to 1.0."
  def aspect_ratio(%{ratio: ratio} = assigns) when ratio == 0 or ratio == 0.0 do
    aspect_ratio(%{assigns | ratio: 1.0})
  end

  @doc "Renders a container that maintains the given aspect ratio using padding-bottom technique."
  def aspect_ratio(assigns) do
    ~H"""
    <div
      style={"padding-bottom: #{Float.round(100.0 / @ratio, 4)}%; position: relative;"}
      class={cn(@class)}
      {@rest}
    >
      <div class="absolute inset-0">
        {render_slot(@inner_block)}
      </div>
    </div>
    """
  end
end
