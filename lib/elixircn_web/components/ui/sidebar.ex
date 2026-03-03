defmodule ElixircnWeb.Components.UI.Sidebar do
  @moduledoc "Provides a sidebar component with header, content, footer, groups, menus, menu items, buttons, and a toggle trigger."
  use Phoenix.Component
  import ElixircnWeb.Components.UI.Utils
  alias Phoenix.LiveView.JS

  attr :id, :string, required: true
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders the root sidebar aside element."
  def sidebar(assigns) do
    ~H"""
    <aside
      id={@id}
      class={cn([
        "flex h-full flex-col bg-sidebar text-sidebar-foreground",
        @class
      ])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </aside>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders the header section at the top of a sidebar."
  def sidebar_header(assigns) do
    ~H"""
    <div class={cn(["flex flex-col gap-2 p-2", @class])} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders the scrollable content area in the middle of a sidebar."
  def sidebar_content(assigns) do
    ~H"""
    <div class={cn(["flex min-h-0 flex-1 flex-col gap-2 overflow-auto p-2", @class])} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders the footer section at the bottom of a sidebar."
  def sidebar_footer(assigns) do
    ~H"""
    <div class={cn(["flex flex-col gap-2 p-2", @class])} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders a group container within sidebar content for organizing related items."
  def sidebar_group(assigns) do
    ~H"""
    <div class={cn(["relative flex w-full min-w-0 flex-col p-2", @class])} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders the content area within a sidebar group."
  def sidebar_group_content(assigns) do
    ~H"""
    <div class={cn(["w-full text-sm", @class])} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders a label heading for a sidebar group."
  def sidebar_group_label(assigns) do
    ~H"""
    <div
      class={cn([
        "duration-200 flex h-8 shrink-0 items-center rounded-md px-2 text-xs font-medium text-sidebar-foreground/70 outline-none ring-sidebar-ring transition-[margin,opa] ease-linear focus-visible:ring-2 [&>svg]:size-4 [&>svg]:shrink-0",
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

  @doc "Renders an unordered list container for sidebar menu items."
  def sidebar_menu(assigns) do
    ~H"""
    <ul class={cn(["flex w-full min-w-0 flex-col gap-1", @class])} {@rest}>
      {render_slot(@inner_block)}
    </ul>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders a list item wrapper for a single sidebar menu entry."
  def sidebar_menu_item(assigns) do
    ~H"""
    <li class={cn(["group/menu-item relative", @class])} {@rest}>
      {render_slot(@inner_block)}
    </li>
    """
  end

  attr :active, :boolean, default: false
  attr :href, :string, default: nil
  attr :navigate, :string, default: nil
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders a sidebar menu button as either a link or a plain button depending on href/navigate."
  def sidebar_menu_button(assigns) do
    base_class = [
      "peer/menu-button flex w-full items-center gap-2 overflow-hidden rounded-md p-2 text-left text-sm outline-none ring-sidebar-ring transition-[width,height,padding] hover:bg-sidebar-accent hover:text-sidebar-accent-foreground focus-visible:ring-2 active:bg-sidebar-accent active:text-sidebar-accent-foreground disabled:pointer-events-none disabled:opacity-50 [&>span:last-child]:truncate [&>svg]:size-4 [&>svg]:shrink-0"
    ]

    assigns = assign(assigns, :base_class, base_class)

    ~H"""
    <.link
      :if={@href || @navigate}
      href={@href}
      navigate={@navigate}
      class={cn([@base_class, @active && "bg-sidebar-accent font-medium text-sidebar-accent-foreground", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </.link>
    <button
      :if={!@href && !@navigate}
      type="button"
      class={cn([@base_class, @active && "bg-sidebar-accent font-medium text-sidebar-accent-foreground", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </button>
    """
  end

  attr :id, :string, required: true
  attr :side, :string, default: "left", values: ~w(left right), doc: "must match the parent sidebar's side for correct slide animation direction"
  attr :class, :any, default: nil
  slot :inner_block, required: true

  @doc "Renders a button that toggles the visibility of the sidebar with a slide animation."
  def sidebar_trigger(assigns) do
    {from_class, to_class} =
      if assigns.side == "right",
        do: {"opacity-0 translate-x-full", "opacity-100 translate-x-0"},
        else: {"opacity-0 -translate-x-full", "opacity-100 translate-x-0"}

    assigns = assign(assigns, from_class: from_class, to_class: to_class)

    ~H"""
    <button
      type="button"
      phx-click={
        JS.toggle(
          to: "##{@id}",
          in: {"ease-out duration-200", @from_class, @to_class},
          out: {"ease-in duration-150", @to_class, @from_class},
          time: 200
        )
      }
      class={cn([
        "inline-flex h-7 w-7 items-center justify-center rounded-md hover:bg-sidebar-accent hover:text-sidebar-accent-foreground",
        @class
      ])}
      aria-label="Toggle sidebar"
    >
      {render_slot(@inner_block)}
    </button>
    """
  end
end
