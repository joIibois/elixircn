defmodule ElixircnWeb.Components.UI.Breadcrumb do
  @moduledoc """
  Breadcrumb navigation components for showing the current page hierarchy.

  Provides `breadcrumb/1`, `breadcrumb_item/1`, `breadcrumb_link/1`,
  `breadcrumb_page/1`, `breadcrumb_separator/1`, `breadcrumb_ellipsis/1`,
  and `breadcrumb_ellipsis_item/1`.
  """
  use Phoenix.Component
  import ElixircnWeb.Components.UI.Icon
  import ElixircnWeb.Components.UI.Utils
  alias Phoenix.LiveView.JS

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders the breadcrumb `<nav>` wrapper with an ordered list inside."
  def breadcrumb(assigns) do
    ~H"""
    <nav aria-label="breadcrumb" class={@class} {@rest}>
      <ol class="flex flex-wrap items-center gap-1.5 break-words text-sm text-muted-foreground sm:gap-2.5">
        {render_slot(@inner_block)}
      </ol>
    </nav>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders a single `<li>` item within a breadcrumb list."
  def breadcrumb_item(assigns) do
    ~H"""
    <li class={cn(["inline-flex items-center gap-1.5", @class])} {@rest}>
      {render_slot(@inner_block)}
    </li>
    """
  end

  attr :href, :string, default: nil
  attr :navigate, :string, default: nil
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders a breadcrumb link for non-current trail pages."
  def breadcrumb_link(assigns) do
    ~H"""
    <.link
      href={@href}
      navigate={@navigate}
      class={cn(["transition-colors hover:text-foreground", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </.link>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc """
  Renders the current page breadcrumb item (non-interactive).

  Uses `aria-current="page"` to identify the active page to assistive
  technology. Does not use `role="link"` or `aria-disabled`, since this
  element is intentionally non-interactive.
  """
  def breadcrumb_page(assigns) do
    ~H"""
    <span
      aria-current="page"
      class={cn(["font-normal text-foreground", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </span>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global

  @doc "Renders a decorative separator between breadcrumb items."
  def breadcrumb_separator(assigns) do
    ~H"""
    <li
      role="presentation"
      aria-hidden="true"
      class={cn(["[&>svg]:size-3.5", @class])}
      {@rest}
    >
      <.icon name="chevron-right" class="h-3.5 w-3.5" />
    </li>
    """
  end

  attr :id, :string, default: nil
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block

  @doc """
  Renders a `…` ellipsis button that toggles a dropdown of hidden trail items.

  Provide `id` and populate `:inner_block` with `breadcrumb_ellipsis_item/1`
  components to enable the dropdown. Without an `id` the ellipsis is rendered
  as a non-interactive presentation element.
  """
  def breadcrumb_ellipsis(assigns) do
    ~H"""
    <span class={cn(["relative flex items-center", @class])} {@rest}>
      <button
        :if={@inner_block != [] && @id}
        id={"#{@id}-trigger"}
        type="button"
        data-state="closed"
        phx-click={
          JS.toggle(
            to: "##{@id}-dropdown",
            in: {"ease-out duration-150", "opacity-0 scale-95", "opacity-100 scale-100"},
            out: {"ease-in duration-100", "opacity-100 scale-100", "opacity-0 scale-95"},
            time: 150
          )
          |> JS.toggle(to: "##{@id}-backdrop")
          |> JS.toggle_attribute({"data-state", "open", "closed"})
        }
        class="flex h-9 w-9 items-center justify-center rounded-md hover:bg-accent hover:text-accent-foreground data-[state=open]:bg-accent data-[state=open]:text-accent-foreground"
        aria-label="Show more"
      >
        <.icon name="ellipsis" class="h-4 w-4" />
        <span class="sr-only">More</span>
      </button>
      <span
        :if={@inner_block == [] || !@id}
        role="presentation"
        aria-hidden="true"
        class="flex h-9 w-9 items-center justify-center"
      >
        <.icon name="ellipsis" class="h-4 w-4" />
        <span class="sr-only">More</span>
      </span>
      <div :if={@inner_block != [] && @id}>
        <div
          id={"#{@id}-backdrop"}
          class="hidden fixed inset-0 z-40"
          phx-click={
            JS.hide(to: "##{@id}-backdrop")
            |> JS.hide(to: "##{@id}-dropdown")
            |> JS.set_attribute({"data-state", "closed"}, to: "##{@id}-trigger")
          }
          data-escape-close
        />
        <div
          id={"#{@id}-dropdown"}
          role="menu"
          phx-hook="Menu"
          class="hidden absolute left-1/2 -translate-x-1/2 top-full z-50 mt-1 min-w-[10rem] overflow-hidden rounded-md border bg-popover p-1 text-popover-foreground shadow-md"
        >
          {render_slot(@inner_block)}
        </div>
      </div>
    </span>
    """
  end

  attr :href, :string, default: "#"
  attr :navigate, :string, default: nil
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders a link item inside a `breadcrumb_ellipsis/1` dropdown."
  def breadcrumb_ellipsis_item(assigns) do
    ~H"""
    <.link
      href={@href}
      navigate={@navigate}
      role="menuitem"
      tabindex="-1"
      class={cn([
        "block rounded-sm px-2 py-1.5 text-sm outline-none hover:bg-accent hover:text-accent-foreground focus:bg-accent focus:text-accent-foreground",
        @class
      ])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </.link>
    """
  end
end
