defmodule ElixircnWeb.Components.UI.HoverCard do
  use Phoenix.Component

  attr :id, :string, default: nil
  attr :class, :string, default: nil
  slot :trigger, required: true
  slot :inner_block, required: true

  def hover_card(assigns) do
    ~H"""
    <div id={@id} class={["group relative inline-block", @class]}>
      {render_slot(@trigger)}
      <div class="absolute left-0 top-full pt-1 z-50 pointer-events-none group-hover:pointer-events-auto">
        <div class="w-64 rounded-md border bg-popover p-4 text-popover-foreground shadow-md opacity-0 group-hover:opacity-100 transition-opacity duration-200">
          {render_slot(@inner_block)}
        </div>
      </div>
    </div>
    """
  end
end
