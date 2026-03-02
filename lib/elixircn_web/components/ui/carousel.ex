defmodule ElixircnWeb.Components.UI.Carousel do
  @moduledoc "Provides carousel components for cycling through slides with previous and next navigation."
  use Phoenix.Component
  import ElixircnWeb.Components.UI.Icon
  import ElixircnWeb.Components.UI.Utils
  alias Phoenix.LiveView.JS

  attr :id, :string, required: true
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders the carousel root container with a region role and the Carousel hook."
  def carousel(assigns) do
    ~H"""
    <div
      id={@id}
      class={cn(["relative", @class])}
      role="region"
      aria-roledescription="carousel"
      phx-hook="Carousel"
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders the scrollable track wrapper that contains carousel slide items."
  def carousel_content(assigns) do
    ~H"""
    <div class={cn(["overflow-hidden", @class])} {@rest}>
      <div
        data-carousel-track
        class="-ml-4 flex transition-transform duration-300 ease-in-out"
      >
        {render_slot(@inner_block)}
      </div>
    </div>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders an individual carousel slide item."
  def carousel_item(assigns) do
    ~H"""
    <div
      role="group"
      aria-roledescription="slide"
      class={cn(["min-w-0 shrink-0 grow-0 basis-full pl-4", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :carousel_id, :string, required: true
  attr :class, :any, default: nil
  attr :rest, :global

  @doc "Renders the previous-slide navigation button for the carousel."
  def carousel_previous(assigns) do
    ~H"""
    <button
      type="button"
      phx-click={JS.dispatch("carousel:prev", to: "##{@carousel_id}")}
      aria-label="Previous slide"
      class={cn([
        "absolute left-[-12px] top-1/2 -translate-y-1/2 inline-flex h-8 w-8 items-center justify-center rounded-full border bg-background shadow-md hover:bg-accent hover:text-accent-foreground disabled:opacity-50",
        @class
      ])}
      {@rest}
    >
      <.icon name="chevron-left" class="h-4 w-4" />
    </button>
    """
  end

  attr :carousel_id, :string, required: true
  attr :class, :any, default: nil
  attr :rest, :global

  @doc "Renders the next-slide navigation button for the carousel."
  def carousel_next(assigns) do
    ~H"""
    <button
      type="button"
      phx-click={JS.dispatch("carousel:next", to: "##{@carousel_id}")}
      aria-label="Next slide"
      class={cn([
        "absolute right-[-12px] top-1/2 -translate-y-1/2 inline-flex h-8 w-8 items-center justify-center rounded-full border bg-background shadow-md hover:bg-accent hover:text-accent-foreground disabled:opacity-50",
        @class
      ])}
      {@rest}
    >
      <.icon name="chevron-right" class="h-4 w-4" />
    </button>
    """
  end
end
