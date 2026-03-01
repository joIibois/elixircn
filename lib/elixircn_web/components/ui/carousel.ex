defmodule ElixircnWeb.Components.UI.Carousel do
  use Phoenix.Component
  alias Phoenix.LiveView.JS

  attr :id, :string, required: true
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def carousel(assigns) do
    ~H"""
    <div
      id={@id}
      class={["relative", @class]}
      role="region"
      aria-roledescription="carousel"
      phx-hook="Carousel"
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def carousel_content(assigns) do
    ~H"""
    <div class={["overflow-hidden", @class]} {@rest}>
      <div
        data-carousel-track
        class="flex transition-transform duration-300 ease-in-out"
      >
        {render_slot(@inner_block)}
      </div>
    </div>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def carousel_item(assigns) do
    ~H"""
    <div
      role="group"
      aria-roledescription="slide"
      class={["min-w-0 shrink-0 grow-0 basis-full pl-4", @class]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :carousel_id, :string, required: true
  attr :class, :string, default: nil
  attr :rest, :global

  def carousel_previous(assigns) do
    ~H"""
    <button
      type="button"
      phx-click={JS.dispatch("carousel:prev", to: "##{@carousel_id}")}
      aria-label="Previous slide"
      class={[
        "absolute left-[-12px] top-1/2 -translate-y-1/2 inline-flex h-8 w-8 items-center justify-center rounded-full border bg-background shadow-md hover:bg-accent hover:text-accent-foreground disabled:opacity-50",
        @class
      ]}
      {@rest}
    >
      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="h-4 w-4"><path d="m15 18-6-6 6-6"/></svg>
    </button>
    """
  end

  attr :carousel_id, :string, required: true
  attr :class, :string, default: nil
  attr :rest, :global

  def carousel_next(assigns) do
    ~H"""
    <button
      type="button"
      phx-click={JS.dispatch("carousel:next", to: "##{@carousel_id}")}
      aria-label="Next slide"
      class={[
        "absolute right-[-12px] top-1/2 -translate-y-1/2 inline-flex h-8 w-8 items-center justify-center rounded-full border bg-background shadow-md hover:bg-accent hover:text-accent-foreground disabled:opacity-50",
        @class
      ]}
      {@rest}
    >
      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="h-4 w-4"><path d="m9 18 6-6-6-6"/></svg>
    </button>
    """
  end
end
