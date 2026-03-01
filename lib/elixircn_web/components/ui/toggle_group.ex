defmodule ElixircnWeb.Components.UI.ToggleGroup do
  use Phoenix.Component

  attr :type, :string, default: "single", values: ~w(single multiple)
  attr :variant, :string, default: "default", values: ~w(default outline)
  attr :size, :string, default: "default", values: ~w(default sm lg)
  attr :class, :string, default: nil
  attr :rest, :global

  slot :inner_block, required: true

  def toggle_group(assigns) do
    ~H"""
    <div
      class={["flex items-center justify-center gap-1", @class]}
      role={if @type == "single", do: "radiogroup", else: "group"}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end
end
