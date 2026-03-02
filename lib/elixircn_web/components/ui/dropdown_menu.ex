defmodule ElixircnWeb.Components.UI.DropdownMenu do
  @moduledoc "Provides dropdown menu components for displaying a list of actions from a trigger element."
  use Phoenix.Component
  alias Phoenix.LiveView.JS
  import ElixircnWeb.Components.UI.Utils

  @doc "Returns a JS command that shows the dropdown menu with the given id."
  def show_dropdown(id) do
    %JS{}
    |> JS.show(to: "##{id}-backdrop")
    |> JS.show(
      to: "##{id}-content",
      transition: {"ease-out duration-100", "opacity-0 scale-95", "opacity-100 scale-100"},
      time: 100
    )
  end

  @doc "Returns a JS command that hides the dropdown menu with the given id."
  def hide_dropdown(id) do
    %JS{}
    |> JS.hide(to: "##{id}-backdrop")
    |> JS.hide(
      to: "##{id}-content",
      transition: {"ease-in duration-75", "opacity-100 scale-100", "opacity-0 scale-95"},
      time: 75
    )
  end

  attr :id, :string, required: true
  attr :class, :any, default: nil
  attr :rest, :global
  slot :trigger, required: true
  slot :inner_block, required: true

  @doc "Renders the dropdown menu container with a trigger slot and a toggleable content panel."
  def dropdown_menu(assigns) do
    ~H"""
    <div id={@id} class={cn(["relative inline-block", @class])} {@rest}>
      <div
        id={"#{@id}-backdrop"}
        class="hidden fixed inset-0 z-40"
        phx-click={hide_dropdown(@id)}
        data-escape-close
      />
      <div
        id={"#{@id}-trigger"}
        aria-expanded="false"
        phx-click={
          JS.toggle(
            to: "##{@id}-content",
            in: {"ease-out duration-100", "opacity-0 scale-95", "opacity-100 scale-100"},
            out: {"ease-in duration-75", "opacity-100 scale-100", "opacity-0 scale-95"},
            time: 100
          )
          |> JS.toggle(to: "##{@id}-backdrop")
          |> JS.toggle_attribute({"aria-expanded", "true", "false"}, to: "##{@id}-trigger")
        }
      >
        {render_slot(@trigger)}
      </div>
      <div
        id={"#{@id}-content"}
        class="hidden absolute right-0 top-full z-50 mt-1 min-w-[8rem] overflow-hidden rounded-md border bg-popover p-1 text-popover-foreground shadow-md"
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
  attr :rest, :global, include: ~w(form name value data-confirm)
  slot :inner_block, required: true

  @doc "Renders a single clickable item within a dropdown menu."
  def dropdown_menu_item(assigns) do
    ~H"""
    <div
      role="menuitem"
      tabindex="-1"
      aria-disabled={to_string(@disabled)}
      class={cn([
        "relative flex cursor-pointer select-none items-center gap-2 rounded-sm px-2 py-1.5 text-sm outline-none transition-colors hover:bg-accent hover:text-accent-foreground focus:bg-accent focus:text-accent-foreground",
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
  slot :inner_block, required: true

  @doc "Renders a non-interactive label heading within a dropdown menu."
  def dropdown_menu_label(assigns) do
    ~H"""
    <div class={cn(["px-2 py-1.5 text-sm font-semibold", @class])} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global

  @doc "Renders a horizontal separator line between dropdown menu items."
  def dropdown_menu_separator(assigns) do
    ~H"""
    <div class={cn(["-mx-1 my-1 h-px bg-muted", @class])} {@rest} />
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders a logical grouping container for related dropdown menu items."
  def dropdown_menu_group(assigns) do
    ~H"""
    <div class={@class} role="group" {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end
end
