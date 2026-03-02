defmodule ElixircnWeb.Components.UI.Menubar do
  @moduledoc "Provides a horizontal menubar component with dropdown menus, items, separators, and labels."
  use Phoenix.Component
  alias Phoenix.LiveView.JS
  import ElixircnWeb.Components.UI.Utils

  attr :id, :string, required: true
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders a horizontal menubar container with keyboard navigation support."
  def menubar(assigns) do
    ~H"""
    <div
      id={@id}
      class={cn([
        "relative flex h-9 items-center space-x-1 rounded-md border bg-background p-1 shadow-sm",
        @class
      ])}
      role="menubar"
      phx-hook="MenubarNav"
      {@rest}
    >
      <div
        id={"#{@id}-backdrop"}
        class="hidden fixed inset-0 z-40"
        phx-click={JS.hide(to: "##{@id} [role=menu]") |> JS.hide(to: "##{@id}-backdrop")}
        data-escape-close
      />
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :menubar_id, :string, required: true
  attr :value, :string, required: true
  attr :class, :any, default: nil
  attr :rest, :global
  slot :trigger, required: true
  slot :inner_block, required: true

  @doc "Renders a menubar menu entry with a trigger button and a dropdown content panel."
  def menubar_menu(assigns) do
    ~H"""
    <div id={"#{@menubar_id}-menu-#{@value}"} class={cn(["relative", @class])}>
      <button
        type="button"
        role="menuitem"
        aria-haspopup="menu"
        phx-click={
          JS.hide(to: "##{@menubar_id} [role=menu]")
          |> JS.show(
            to: "##{@menubar_id}-menu-#{@value}-content",
            transition: {"ease-out duration-100", "opacity-0 scale-95", "opacity-100 scale-100"},
            time: 100
          )
          |> JS.show(to: "##{@menubar_id}-backdrop")
        }
        class="flex cursor-default select-none items-center rounded-sm px-3 py-1 text-sm font-medium outline-none focus:bg-accent focus:text-accent-foreground data-[state=open]:bg-accent data-[state=open]:text-accent-foreground"
        {@rest}
      >
        {render_slot(@trigger)}
      </button>
      <div
        id={"#{@menubar_id}-menu-#{@value}-content"}
        class="hidden absolute left-0 top-full z-50 min-w-[12rem] overflow-hidden rounded-md border bg-popover p-1 text-popover-foreground shadow-md"
        role="menu"
        phx-hook="Menu"
      >
        {render_slot(@inner_block)}
      </div>
    </div>
    """
  end

  attr :class, :any, default: nil
  attr :disabled, :boolean, default: false
  attr :shortcut, :string, default: nil
  attr :rest, :global, include: ~w(form name value data-confirm)
  slot :inner_block, required: true

  @doc "Renders an individual menubar item with optional disabled state and keyboard shortcut display."
  def menubar_item(assigns) do
    ~H"""
    <div
      role="menuitem"
      tabindex="-1"
      aria-disabled={to_string(@disabled)}
      class={cn([
        "relative flex cursor-pointer select-none items-center rounded-sm px-2 py-1.5 text-sm outline-none hover:bg-accent hover:text-accent-foreground focus:bg-accent focus:text-accent-foreground",
        @disabled && "pointer-events-none opacity-50",
        @class
      ])}
      {@rest}
    >
      {render_slot(@inner_block)}
      <span :if={@shortcut} class="ml-auto text-xs tracking-widest text-muted-foreground">
        {@shortcut}
      </span>
    </div>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global

  @doc "Renders a horizontal separator line within a menubar dropdown."
  def menubar_separator(assigns) do
    ~H"""
    <div class={cn(["-mx-1 my-1 h-px bg-muted", @class])} {@rest} />
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders a label heading within a menubar dropdown section."
  def menubar_label(assigns) do
    ~H"""
    <div class={cn(["px-2 py-1.5 text-sm font-semibold", @class])} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end
end
