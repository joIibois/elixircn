defmodule ElixircnWeb.Components.UI.Sidebar do
  use Phoenix.Component
  alias Phoenix.LiveView.JS

  attr :id, :string, required: true
  attr :side, :string, default: "left", values: ~w(left right)
  attr :collapsible, :string, default: "offcanvas", values: ~w(offcanvas icon none)
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def sidebar(assigns) do
    ~H"""
    <aside
      id={@id}
      class={[
        "flex h-full flex-col bg-sidebar text-sidebar-foreground",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </aside>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def sidebar_header(assigns) do
    ~H"""
    <div class={["flex flex-col gap-2 p-2", @class]} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def sidebar_content(assigns) do
    ~H"""
    <div class={["flex min-h-0 flex-1 flex-col gap-2 overflow-auto p-2", @class]} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def sidebar_footer(assigns) do
    ~H"""
    <div class={["flex flex-col gap-2 p-2", @class]} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def sidebar_group(assigns) do
    ~H"""
    <div class={["relative flex w-full min-w-0 flex-col p-2", @class]} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def sidebar_group_content(assigns) do
    ~H"""
    <div class={["w-full text-sm", @class]} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def sidebar_group_label(assigns) do
    ~H"""
    <div class={["duration-200 flex h-8 shrink-0 items-center rounded-md px-2 text-xs font-medium text-sidebar-foreground/70 outline-none ring-sidebar-ring transition-[margin,opa] ease-linear focus-visible:ring-2 [&>svg]:size-4 [&>svg]:shrink-0", @class]} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def sidebar_menu(assigns) do
    ~H"""
    <ul class={["flex w-full min-w-0 flex-col gap-1", @class]} {@rest}>
      {render_slot(@inner_block)}
    </ul>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def sidebar_menu_item(assigns) do
    ~H"""
    <li class={["group/menu-item relative", @class]} {@rest}>
      {render_slot(@inner_block)}
    </li>
    """
  end

  attr :active, :boolean, default: false
  attr :href, :string, default: nil
  attr :navigate, :string, default: nil
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def sidebar_menu_button(assigns) do
    ~H"""
    <.link
      href={@href}
      navigate={@navigate}
      class={[
        "peer/menu-button flex w-full items-center gap-2 overflow-hidden rounded-md p-2 text-left text-sm outline-none ring-sidebar-ring transition-[width,height,padding] hover:bg-sidebar-accent hover:text-sidebar-accent-foreground focus-visible:ring-2 active:bg-sidebar-accent active:text-sidebar-accent-foreground disabled:pointer-events-none disabled:opacity-50 [&>span:last-child]:truncate [&>svg]:size-4 [&>svg]:shrink-0",
        @active && "bg-sidebar-accent font-medium text-sidebar-accent-foreground",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </.link>
    """
  end

  attr :id, :string, required: true
  attr :class, :string, default: nil
  slot :inner_block, required: true

  def sidebar_trigger(assigns) do
    ~H"""
    <button
      type="button"
      phx-click={JS.toggle(to: "##{@id}",
        in: {"ease-out duration-200", "opacity-0 -translate-x-full", "opacity-100 translate-x-0"},
        out: {"ease-in duration-150", "opacity-100 translate-x-0", "opacity-0 -translate-x-full"},
        time: 200)}
      class={["inline-flex h-7 w-7 items-center justify-center rounded-md hover:bg-sidebar-accent hover:text-sidebar-accent-foreground", @class]}
      aria-label="Toggle sidebar"
    >
      {render_slot(@inner_block)}
    </button>
    """
  end
end
