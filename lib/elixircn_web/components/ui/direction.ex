defmodule ElixircnWeb.Components.UI.Direction do
  use Phoenix.Component
  import ElixircnWeb.Components.UI.Utils

  attr :dir, :string, default: "ltr", values: ~w(ltr rtl)
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def direction(assigns) do
    ~H"""
    <div dir={@dir} class={cn(@class)} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end
end
