defmodule ElixircnWeb.Components.UI.HoverCard do
  @moduledoc "Provides a hover-triggered card overlay component for displaying contextual information."
  use Phoenix.Component
  import ElixircnWeb.Components.UI.Utils

  attr :id, :string, default: nil
  attr :class, :any, default: nil
  attr :rest, :global
  slot :trigger, required: true
  slot :inner_block, required: true

  @doc "Renders a card that appears when the user hovers over or focuses the trigger element."
  def hover_card(assigns) do
    ~H"""
    <div id={@id} class={cn(["group relative inline-block", @class])} {@rest}>
      {render_slot(@trigger)}
      <div class="absolute left-0 top-full pt-1 z-50 pointer-events-none group-hover:pointer-events-auto group-focus-within:pointer-events-auto">
        <div class="w-64 rounded-md border bg-popover p-4 text-popover-foreground shadow-md opacity-0 group-hover:opacity-100 group-focus-within:opacity-100 transition-opacity duration-200">
          {render_slot(@inner_block)}
        </div>
      </div>
    </div>
    """
  end
end
