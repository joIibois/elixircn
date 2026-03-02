defmodule ElixircnWeb.Components.UI.ContextMenu do
  @moduledoc "Provides context menu components that appear on right-click with positioned menu items."
  use Phoenix.Component
  import ElixircnWeb.Components.UI.Utils

  attr :id, :string, required: true
  attr :class, :any, default: nil
  slot :trigger, required: true
  slot :inner_block, required: true

  @doc "Renders a context menu wrapper that shows a popup menu on right-click of its trigger slot."
  def context_menu(assigns) do
    ~H"""
    <div
      id={@id}
      class={cn(["relative", @class])}
      data-menu-target={"#{@id}-content"}
      phx-hook="ContextMenu"
    >
      {render_slot(@trigger)}
      <div
        id={"#{@id}-content"}
        class="hidden fixed z-50 min-w-[8rem] overflow-hidden rounded-md border bg-popover p-1 text-popover-foreground shadow-md"
        role="menu"
        phx-hook="Menu"
        style="display: none;"
        data-context-menu-content
      >
        {render_slot(@inner_block)}
      </div>
    </div>
    """
  end

  attr :class, :any, default: nil
  attr :disabled, :boolean, default: false
  attr :rest, :global, include: ~w(form name value data-confirm)
  slot :inner_block, required: true

  @doc "Renders a single clickable item within a context menu."
  def context_menu_item(assigns) do
    ~H"""
    <div
      role="menuitem"
      tabindex="-1"
      aria-disabled={to_string(@disabled)}
      class={cn([
        "relative flex cursor-pointer select-none items-center gap-2 rounded-sm px-2 py-1.5 text-sm outline-none hover:bg-accent hover:text-accent-foreground focus:bg-accent focus:text-accent-foreground",
        @disabled && "pointer-events-none opacity-50",
        @class
      ])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global

  @doc "Renders a horizontal separator line between context menu items."
  def context_menu_separator(assigns) do
    ~H"""
    <div class={cn(["-mx-1 my-1 h-px bg-muted", @class])} {@rest} />
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders a non-interactive label heading within a context menu."
  def context_menu_label(assigns) do
    ~H"""
    <div class={cn(["px-2 py-1.5 text-sm font-semibold", @class])} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end
end
