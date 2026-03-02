defmodule ElixircnWeb.Components.UI.Separator do
  @moduledoc "Provides a horizontal or vertical separator component for visually dividing content."
  use Phoenix.Component
  import ElixircnWeb.Components.UI.Utils

  attr :orientation, :string, default: "horizontal", values: ~w(horizontal vertical)
  attr :decorative, :boolean, default: true
  attr :class, :any, default: nil
  attr :rest, :global

  @doc "Renders a styled separator line in either horizontal or vertical orientation."
  def separator(assigns) do
    ~H"""
    <div
      role={if @decorative, do: "none", else: "separator"}
      aria-orientation={if !@decorative, do: @orientation}
      class={cn([
        "shrink-0 bg-border",
        @orientation == "horizontal" && "h-[1px] w-full",
        @orientation == "vertical" && "h-full w-[1px]",
        @class
      ])}
      {@rest}
    />
    """
  end
end
