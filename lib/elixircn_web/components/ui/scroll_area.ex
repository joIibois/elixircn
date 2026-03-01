defmodule ElixircnWeb.Components.UI.ScrollArea do
  use Phoenix.Component

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def scroll_area(assigns) do
    ~H"""
    <div
      class={["relative overflow-hidden", @class]}
      {@rest}
    >
      <div class="h-full w-full overflow-auto rounded-[inherit] [scrollbar-width:thin] [scrollbar-color:hsl(var(--border))_transparent]">
        {render_slot(@inner_block)}
      </div>
    </div>
    """
  end
end
