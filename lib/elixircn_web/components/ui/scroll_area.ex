defmodule ElixircnWeb.Components.UI.ScrollArea do
  @moduledoc "Provides a scroll area component with a thin custom scrollbar style."
  use Phoenix.Component
  import ElixircnWeb.Components.UI.Utils

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders a scrollable container with a styled thin scrollbar."
  def scroll_area(assigns) do
    ~H"""
    <div
      class={cn(["relative overflow-hidden", @class])}
      {@rest}
    >
      <div class="h-full w-full overflow-auto rounded-[inherit] [scrollbar-width:thin] [scrollbar-color:hsl(var(--border))_transparent]">
        {render_slot(@inner_block)}
      </div>
    </div>
    """
  end
end
