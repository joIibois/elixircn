defmodule ElixircnWeb.Components.UI.ToggleGroup do
  @moduledoc "Provides a group container for organizing multiple toggle buttons with single or multiple selection."
  use Phoenix.Component
  import ElixircnWeb.Components.UI.Utils

  attr :type, :string, default: "single", values: ~w(single multiple)
  attr :class, :any, default: nil
  attr :rest, :global

  slot :inner_block, required: true

  @doc "Renders a container grouping toggle buttons with either single or multiple selection semantics."
  def toggle_group(assigns) do
    ~H"""
    <div
      class={cn(["flex items-center justify-center gap-1", @class])}
      role={if @type == "single", do: "radiogroup", else: "group"}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end
end
