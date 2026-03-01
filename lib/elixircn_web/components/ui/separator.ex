defmodule ElixircnWeb.Components.UI.Separator do
  use Phoenix.Component

  attr :orientation, :string, default: "horizontal", values: ~w(horizontal vertical)
  attr :decorative, :boolean, default: true
  attr :class, :string, default: nil
  attr :rest, :global

  def separator(assigns) do
    ~H"""
    <div
      role={if @decorative, do: "none", else: "separator"}
      aria-orientation={if !@decorative, do: @orientation}
      class={[
        "shrink-0 bg-border",
        @orientation == "horizontal" && "h-[1px] w-full",
        @orientation == "vertical" && "h-full w-[1px]",
        @class
      ]}
      {@rest}
    />
    """
  end
end
