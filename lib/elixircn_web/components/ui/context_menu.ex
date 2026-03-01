defmodule ElixircnWeb.Components.UI.ContextMenu do
  use Phoenix.Component

  attr :id, :string, required: true
  attr :class, :string, default: nil
  slot :trigger, required: true
  slot :inner_block, required: true

  def context_menu(assigns) do
    ~H"""
    <div
      id={@id}
      class={["relative", @class]}
      data-menu-target={"#{@id}-content"}
      phx-hook="ContextMenu"
    >
      {render_slot(@trigger)}
      <div
        id={"#{@id}-content"}
        class="hidden fixed z-50 min-w-[8rem] overflow-hidden rounded-md border bg-popover p-1 text-popover-foreground shadow-md"
        role="menu"
        style="display: none;"
        data-context-menu-content
      >
        {render_slot(@inner_block)}
      </div>
    </div>
    """
  end

  attr :class, :string, default: nil
  attr :disabled, :boolean, default: false
  attr :rest, :global, include: ~w(phx-click phx-target)
  slot :inner_block, required: true

  def context_menu_item(assigns) do
    ~H"""
    <div
      role="menuitem"
      class={[
        "relative flex cursor-pointer select-none items-center gap-2 rounded-sm px-2 py-1.5 text-sm outline-none hover:bg-accent hover:text-accent-foreground",
        @disabled && "pointer-events-none opacity-50",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global

  def context_menu_separator(assigns) do
    ~H"""
    <div class={["-mx-1 my-1 h-px bg-muted", @class]} {@rest} />
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def context_menu_label(assigns) do
    ~H"""
    <div class={["px-2 py-1.5 text-sm font-semibold", @class]} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end
end
