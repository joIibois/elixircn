defmodule ElixircnWeb.Components.UI.Breadcrumb do
  use Phoenix.Component
  alias Phoenix.LiveView.JS

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def breadcrumb(assigns) do
    ~H"""
    <nav aria-label="breadcrumb" class={@class} {@rest}>
      <ol class="flex flex-wrap items-center gap-1.5 break-words text-sm text-muted-foreground sm:gap-2.5">
        {render_slot(@inner_block)}
      </ol>
    </nav>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def breadcrumb_item(assigns) do
    ~H"""
    <li class={["inline-flex items-center gap-1.5", @class]} {@rest}>
      {render_slot(@inner_block)}
    </li>
    """
  end

  attr :href, :string, default: nil
  attr :navigate, :string, default: nil
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def breadcrumb_link(assigns) do
    ~H"""
    <.link
      href={@href}
      navigate={@navigate}
      class={["transition-colors hover:text-foreground", @class]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </.link>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def breadcrumb_page(assigns) do
    ~H"""
    <span
      role="link"
      aria-disabled="true"
      aria-current="page"
      class={["font-normal text-foreground", @class]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </span>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global

  def breadcrumb_separator(assigns) do
    ~H"""
    <li
      role="presentation"
      aria-hidden="true"
      class={["[&>svg]:size-3.5", @class]}
      {@rest}
    >
      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="h-3.5 w-3.5"><path d="m9 18 6-6-6-6"/></svg>
    </li>
    """
  end

  attr :id, :string, default: nil
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block

  def breadcrumb_ellipsis(assigns) do
    ~H"""
    <span class={["relative flex items-center", @class]} {@rest}>
      <button
        :if={@inner_block != [] && @id}
        id={"#{@id}-trigger"}
        type="button"
        data-state="closed"
        phx-click={
          JS.toggle(to: "##{@id}-dropdown",
            in: {"ease-out duration-150", "opacity-0 scale-95", "opacity-100 scale-100"},
            out: {"ease-in duration-100", "opacity-100 scale-100", "opacity-0 scale-95"},
            time: 150)
          |> JS.toggle(to: "##{@id}-backdrop")
          |> JS.toggle_attribute({"data-state", "open", "closed"})
        }
        class="flex h-9 w-9 items-center justify-center rounded-md hover:bg-accent hover:text-accent-foreground data-[state=open]:bg-accent data-[state=open]:text-accent-foreground"
        aria-label="Show more"
      >
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="h-4 w-4"><circle cx="12" cy="12" r="1"/><circle cx="19" cy="12" r="1"/><circle cx="5" cy="12" r="1"/></svg>
        <span class="sr-only">More</span>
      </button>
      <span
        :if={@inner_block == [] || !@id}
        role="presentation"
        aria-hidden="true"
        class="flex h-9 w-9 items-center justify-center"
      >
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="h-4 w-4"><circle cx="12" cy="12" r="1"/><circle cx="19" cy="12" r="1"/><circle cx="5" cy="12" r="1"/></svg>
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
        />
        <div
          id={"#{@id}-dropdown"}
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
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def breadcrumb_ellipsis_item(assigns) do
    ~H"""
    <.link
      href={@href}
      navigate={@navigate}
      class={["block rounded-sm px-2 py-1.5 text-sm hover:bg-accent hover:text-accent-foreground outline-none", @class]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </.link>
    """
  end
end
