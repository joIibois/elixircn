defmodule ElixircnWeb.Components.UI.Label do
  @moduledoc "Provides a styled form label component with peer-disabled state support."
  use Phoenix.Component
  import ElixircnWeb.Components.UI.Utils

  attr :for, :string, default: nil
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders a styled label element associated with a form control."
  def label(assigns) do
    ~H"""
    <label
      for={@for}
      class={cn([
        "text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70",
        @class
      ])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </label>
    """
  end
end
