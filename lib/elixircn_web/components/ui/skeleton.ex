defmodule ElixircnWeb.Components.UI.Skeleton do
  use Phoenix.Component

  attr :class, :string, default: nil
  attr :rest, :global

  def skeleton(assigns) do
    ~H"""
    <div
      class={["animate-pulse rounded-md bg-primary/10", @class]}
      {@rest}
    />
    """
  end
end
