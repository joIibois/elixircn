defmodule ElixircnWeb.Components.UI.ButtonGroup do
  @moduledoc "Provides a button group component for visually joining multiple buttons together."
  use Phoenix.Component
  import ElixircnWeb.Components.UI.Utils

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders a container that joins child buttons into a seamless group."
  def button_group(assigns) do
    ~H"""
    <div
      class={cn([
        "inline-flex items-center rounded-md shadow-sm [&>*:not(:first-child)]:-ml-px [&>*:not(:first-child)]:rounded-l-none [&>*:not(:last-child)]:rounded-r-none [&>button]:shadow-none",
        @class
      ])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end
end
