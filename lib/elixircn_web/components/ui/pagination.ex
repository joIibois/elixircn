defmodule ElixircnWeb.Components.UI.Pagination do
  use Phoenix.Component
  import ElixircnWeb.Components.UI.Icon

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def pagination(assigns) do
    ~H"""
    <nav
      role="navigation"
      aria-label="pagination"
      class={["mx-auto flex w-full justify-center", @class]}
      {@rest}
    >
      <ul class="flex flex-row items-center gap-1">
        {render_slot(@inner_block)}
      </ul>
    </nav>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def pagination_content(assigns) do
    ~H"""
    <li class={@class} {@rest}>
      {render_slot(@inner_block)}
    </li>
    """
  end

  attr :href, :string, default: nil
  attr :navigate, :string, default: nil
  attr :active, :boolean, default: false
  attr :disabled, :boolean, default: false
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def pagination_link(assigns) do
    ~H"""
    <.link
      href={!@disabled && @href}
      navigate={!@disabled && @navigate}
      aria-current={@active && "page"}
      class={[
        "inline-flex h-9 w-9 items-center justify-center rounded-md text-sm transition-colors",
        @active && "border border-input bg-background shadow-sm",
        !@active && "hover:bg-accent hover:text-accent-foreground",
        @disabled && "pointer-events-none opacity-50",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </.link>
    """
  end

  attr :href, :string, default: nil
  attr :navigate, :string, default: nil
  attr :disabled, :boolean, default: false
  attr :class, :string, default: nil
  attr :rest, :global

  def pagination_previous(assigns) do
    ~H"""
    <.link
      href={!@disabled && @href}
      navigate={!@disabled && @navigate}
      aria-label="Go to previous page"
      class={[
        "inline-flex h-9 items-center justify-center gap-1 rounded-md px-3 text-sm transition-colors hover:bg-accent hover:text-accent-foreground",
        @disabled && "pointer-events-none opacity-50",
        @class
      ]}
      {@rest}
    >
      <.icon name="chevron-left" class="h-4 w-4" />
      <span>Previous</span>
    </.link>
    """
  end

  attr :href, :string, default: nil
  attr :navigate, :string, default: nil
  attr :disabled, :boolean, default: false
  attr :class, :string, default: nil
  attr :rest, :global

  def pagination_next(assigns) do
    ~H"""
    <.link
      href={!@disabled && @href}
      navigate={!@disabled && @navigate}
      aria-label="Go to next page"
      class={[
        "inline-flex h-9 items-center justify-center gap-1 rounded-md px-3 text-sm transition-colors hover:bg-accent hover:text-accent-foreground",
        @disabled && "pointer-events-none opacity-50",
        @class
      ]}
      {@rest}
    >
      <span>Next</span>
      <.icon name="chevron-right" class="h-4 w-4" />
    </.link>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global

  def pagination_ellipsis(assigns) do
    ~H"""
    <span
      aria-hidden="true"
      class={["flex h-9 w-9 items-center justify-center", @class]}
      {@rest}
    >
      <.icon name="ellipsis" class="h-4 w-4" />
      <span class="sr-only">More pages</span>
    </span>
    """
  end
end
