defmodule ElixircnWeb.Components.UI.Skeleton do
  @moduledoc """
  Skeleton loading placeholder component.

  Renders an animated pulsing placeholder that fills the space of content
  while it is loading. Always hidden from screen readers via `aria-hidden`.
  """
  use Phoenix.Component
  import ElixircnWeb.Components.UI.Utils

  attr :class, :any, default: nil
  attr :rest, :global

  @doc """
  Renders an animated skeleton placeholder.

  The element is hidden from screen readers with `aria-hidden="true"` since
  it carries no meaningful content.
  """
  def skeleton(assigns) do
    ~H"""
    <div
      aria-hidden="true"
      class={cn(["animate-pulse rounded-md bg-primary/10", @class])}
      {@rest}
    />
    """
  end
end
