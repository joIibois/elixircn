defmodule ElixircnWeb.Components.UI.Pagination do
  @moduledoc """
  Pagination navigation components.

  Provides `pagination/1`, `pagination_content/1`, `pagination_link/1`,
  `pagination_previous/1`, `pagination_next/1`, and `pagination_ellipsis/1`.
  """
  use Phoenix.Component
  import ElixircnWeb.Components.UI.Icon
  import ElixircnWeb.Components.UI.Utils

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders a pagination `<nav>` wrapper."
  def pagination(assigns) do
    ~H"""
    <nav
      role="navigation"
      aria-label="pagination"
      class={cn(["mx-auto flex w-full justify-center", @class])}
      {@rest}
    >
      <ul class="flex flex-row items-center gap-1">
        {render_slot(@inner_block)}
      </ul>
    </nav>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Wraps a pagination item in a `<li>` element."
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
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders a single page number link."
  def pagination_link(assigns) do
    ~H"""
    <.link
      href={if @disabled, do: nil, else: @href}
      navigate={if @disabled, do: nil, else: @navigate}
      aria-current={@active && "page"}
      class={cn([
        "inline-flex h-9 w-9 items-center justify-center rounded-md text-sm transition-colors",
        @active && "border border-input bg-background shadow-sm",
        !@active && "hover:bg-accent hover:text-accent-foreground",
        @disabled && "pointer-events-none opacity-50",
        @class
      ])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </.link>
    """
  end

  attr :href, :string, default: nil
  attr :navigate, :string, default: nil
  attr :disabled, :boolean, default: false
  attr :label, :string, default: "Previous", doc: "visible link text; override for i18n"
  attr :class, :any, default: nil
  attr :rest, :global

  @doc """
  Renders a "Previous" pagination link.

  The visible text defaults to `"Previous"` and can be overridden via the
  `label` attr for internationalisation.
  """
  def pagination_previous(assigns) do
    ~H"""
    <.link
      href={if @disabled, do: nil, else: @href}
      navigate={if @disabled, do: nil, else: @navigate}
      aria-label="Go to previous page"
      class={cn([
        "inline-flex h-9 items-center justify-center gap-1 rounded-md px-3 text-sm transition-colors hover:bg-accent hover:text-accent-foreground",
        @disabled && "pointer-events-none opacity-50",
        @class
      ])}
      {@rest}
    >
      <.icon name="chevron-left" class="h-4 w-4" />
      <span>{@label}</span>
    </.link>
    """
  end

  attr :href, :string, default: nil
  attr :navigate, :string, default: nil
  attr :disabled, :boolean, default: false
  attr :label, :string, default: "Next", doc: "visible link text; override for i18n"
  attr :class, :any, default: nil
  attr :rest, :global

  @doc """
  Renders a "Next" pagination link.

  The visible text defaults to `"Next"` and can be overridden via the `label`
  attr for internationalisation.
  """
  def pagination_next(assigns) do
    ~H"""
    <.link
      href={if @disabled, do: nil, else: @href}
      navigate={if @disabled, do: nil, else: @navigate}
      aria-label="Go to next page"
      class={cn([
        "inline-flex h-9 items-center justify-center gap-1 rounded-md px-3 text-sm transition-colors hover:bg-accent hover:text-accent-foreground",
        @disabled && "pointer-events-none opacity-50",
        @class
      ])}
      {@rest}
    >
      <span>{@label}</span>
      <.icon name="chevron-right" class="h-4 w-4" />
    </.link>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global

  @doc "Renders a `…` ellipsis placeholder between page number groups."
  def pagination_ellipsis(assigns) do
    ~H"""
    <span
      aria-hidden="true"
      class={cn(["flex h-9 w-9 items-center justify-center", @class])}
      {@rest}
    >
      <.icon name="ellipsis" class="h-4 w-4" />
      <span class="sr-only">More pages</span>
    </span>
    """
  end
end
