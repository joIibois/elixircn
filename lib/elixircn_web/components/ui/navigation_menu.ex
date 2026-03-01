defmodule ElixircnWeb.Components.UI.NavigationMenu do
  use Phoenix.Component
  alias Phoenix.LiveView.JS

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def navigation_menu(assigns) do
    ~H"""
    <nav class={["relative z-10 flex max-w-max flex-1 items-center justify-center", @class]} {@rest}>
      {render_slot(@inner_block)}
    </nav>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def navigation_menu_list(assigns) do
    ~H"""
    <ul class={["group flex flex-1 list-none items-center justify-center space-x-1", @class]} {@rest}>
      {render_slot(@inner_block)}
    </ul>
    """
  end

  attr :id, :string, required: true
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def navigation_menu_item(assigns) do
    ~H"""
    <li id={@id} class={["relative", @class]} {@rest}>
      <div
        id={"#{@id}-backdrop"}
        class="hidden fixed inset-0 z-40"
        phx-click={
          JS.hide(to: "##{@id}-content")
          |> JS.hide(to: "##{@id}-backdrop")
        }
      />
      {render_slot(@inner_block)}
    </li>
    """
  end

  attr :item_id, :string, required: true
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def navigation_menu_trigger(assigns) do
    ~H"""
    <button
      type="button"
      phx-click={
        JS.toggle(to: "##{@item_id}-content",
          in: {"ease-out duration-150", "opacity-0 scale-95", "opacity-100 scale-100"},
          out: {"ease-in duration-100", "opacity-100 scale-100", "opacity-0 scale-95"},
          time: 150)
        |> JS.toggle(to: "##{@item_id}-backdrop")
      }
      class={[
        "group inline-flex h-9 w-max items-center justify-center rounded-md bg-background px-4 py-2 text-sm font-medium transition-colors hover:bg-accent hover:text-accent-foreground focus:bg-accent focus:text-accent-foreground focus:outline-none disabled:pointer-events-none disabled:opacity-50",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
      <svg class="relative top-[1px] ml-1 h-3 w-3 transition duration-300" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m6 9 6 6 6-6"/></svg>
    </button>
    """
  end

  attr :item_id, :string, required: true
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def navigation_menu_content(assigns) do
    ~H"""
    <div
      id={"#{@item_id}-content"}
      class={["hidden absolute left-0 top-full w-auto rounded-md border bg-popover text-popover-foreground shadow-lg p-2", @class]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :href, :string, default: nil
  attr :navigate, :string, default: nil
  attr :title, :string, required: true
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block

  def navigation_menu_link(assigns) do
    ~H"""
    <.link
      href={@href}
      navigate={@navigate}
      class={["block select-none space-y-1 rounded-md p-3 leading-none no-underline outline-none transition-colors hover:bg-accent hover:text-accent-foreground focus:bg-accent focus:text-accent-foreground", @class]}
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
