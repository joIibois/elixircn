defmodule ElixircnWeb.Components.UI.Card do
  @moduledoc """
  Card components for displaying content in a contained, styled surface.

  Provides `card/1`, `card_header/1`, `card_title/1`, `card_description/1`,
  `card_content/1`, and `card_footer/1`.
  """
  use Phoenix.Component
  import ElixircnWeb.Components.UI.Utils

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders a card container."
  def card(assigns) do
    ~H"""
    <div
      class={cn(["rounded-xl border bg-card text-card-foreground shadow", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders the card header area (top padding + flex column layout)."
  def card_header(assigns) do
    ~H"""
    <div class={cn(["flex flex-col space-y-1.5 p-6", @class])} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :class, :any, default: nil
  attr :as, :string, default: "h3", doc: "heading element to render, e.g. \"h2\", \"h3\", \"h4\""
  attr :rest, :global
  slot :inner_block, required: true

  @doc """
  Renders the card title as a heading element.

  Defaults to `<h3>` for proper document outline semantics. Override with the
  `as` attr when a different heading level is needed.
  """
  def card_title(assigns) do
    ~H"""
    <.dynamic_tag
      tag_name={@as}
      class={cn(["font-semibold leading-none tracking-tight", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </.dynamic_tag>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders a muted description paragraph below the card title."
  def card_description(assigns) do
    ~H"""
    <p class={cn(["text-sm text-muted-foreground", @class])} {@rest}>
      {render_slot(@inner_block)}
    </p>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders the main content area of a card."
  def card_content(assigns) do
    ~H"""
    <div class={cn(["p-6 pt-0", @class])} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders the footer row at the bottom of a card."
  def card_footer(assigns) do
    ~H"""
    <div class={cn(["flex items-center p-6 pt-0", @class])} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end
end
