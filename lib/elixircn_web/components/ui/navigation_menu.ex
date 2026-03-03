defmodule ElixircnWeb.Components.UI.NavigationMenu do
  @moduledoc "Provides a navigation menu component with list items, triggers, content panels, and links."
  use Phoenix.Component
  import ElixircnWeb.Components.UI.Icon
  import ElixircnWeb.Components.UI.Utils
  alias Phoenix.LiveView.JS

  attr :id, :string, default: nil
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders the root navigation menu container as a nav element."
  def navigation_menu(assigns) do
    assigns =
      if assigns.id,
        do: assigns,
        else: assign(assigns, :id, "nav-menu-#{System.unique_integer([:positive])}")

    ~H"""
    <nav
      id={@id}
      class={cn(["relative z-10 flex max-w-max flex-1 items-center justify-center", @class])}
      phx-hook="NavigationMenuNav"
      {@rest}
    >
      {render_slot(@inner_block)}
    </nav>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders an unordered list of navigation menu items."
  def navigation_menu_list(assigns) do
    ~H"""
    <ul class={cn(["group flex flex-1 list-none items-center justify-center space-x-1", @class])} {@rest}>
      {render_slot(@inner_block)}
    </ul>
    """
  end

  attr :id, :string, required: true
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders a navigation menu list item with a backdrop for closing open content panels."
  def navigation_menu_item(assigns) do
    ~H"""
    <li id={@id} class={cn(["relative", @class])} data-nav-item {@rest}>
      <div
        id={"#{@id}-backdrop"}
        class="hidden fixed inset-0 z-40"
        phx-click={
          JS.hide(to: "##{@id}-content")
          |> JS.hide(to: "##{@id}-backdrop")
          |> JS.set_attribute({"aria-expanded", "false"}, to: "##{@id}-trigger")
        }
        data-escape-close
      />
      {render_slot(@inner_block)}
    </li>
    """
  end

  attr :item_id, :string, required: true
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders a trigger button that toggles the associated navigation menu content panel."
  def navigation_menu_trigger(assigns) do
    ~H"""
    <button
      id={"#{@item_id}-trigger"}
      type="button"
      aria-expanded="false"
      data-nav-trigger
      phx-click={
        JS.toggle(
          to: "##{@item_id}-content",
          in: {"ease-out duration-150", "opacity-0 scale-95", "opacity-100 scale-100"},
          out: {"ease-in duration-100", "opacity-100 scale-100", "opacity-0 scale-95"},
          time: 150
        )
        |> JS.toggle(to: "##{@item_id}-backdrop")
        |> JS.toggle_attribute({"aria-expanded", "true", "false"}, to: "##{@item_id}-trigger")
      }
      class={cn([
        "group inline-flex h-9 w-max items-center justify-center rounded-md bg-background px-4 py-2 text-sm font-medium transition-colors hover:bg-accent hover:text-accent-foreground focus:bg-accent focus:text-accent-foreground focus:outline-none disabled:pointer-events-none disabled:opacity-50",
        @class
      ])}
      {@rest}
    >
      {render_slot(@inner_block)}
      <.icon name="chevron-down" class="relative top-[1px] ml-1 h-3 w-3 transition duration-300" />
    </button>
    """
  end

  attr :item_id, :string, required: true
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders the dropdown content panel for a navigation menu item."
  def navigation_menu_content(assigns) do
    ~H"""
    <div
      id={"#{@item_id}-content"}
      data-nav-content
      class={cn([
        "hidden absolute left-0 top-full z-50 w-auto rounded-md border bg-popover text-popover-foreground shadow-lg p-2",
        @class
      ])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :href, :string, default: nil
  attr :navigate, :string, default: nil
  attr :title, :string, required: true
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block

  @doc "Renders a styled navigation link with a title and optional description content."
  def navigation_menu_link(assigns) do
    ~H"""
    <.link
      href={@href}
      navigate={@navigate}
      class={cn([
        "block select-none space-y-1 rounded-md p-3 leading-none no-underline outline-none transition-colors hover:bg-accent hover:text-accent-foreground focus:bg-accent focus:text-accent-foreground",
        @class
      ])}
      {@rest}
    >
      <div class="text-sm font-medium leading-none">{@title}</div>
      <p :if={@inner_block != []} class="line-clamp-2 text-sm leading-snug text-muted-foreground">
        {render_slot(@inner_block)}
      </p>
    </.link>
    """
  end
end
