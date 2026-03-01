defmodule ElixircnWeb.Components.UI.Progress do
  use Phoenix.Component

  attr :value, :integer, default: 0
  attr :max, :integer, default: 100
  attr :class, :string, default: nil
  attr :rest, :global

  def progress(assigns) do
    pct = if assigns.max > 0, do: round(assigns.value / assigns.max * 100), else: 0
    assigns = assign(assigns, :pct, pct)

    ~H"""
    <div
      class={["relative h-2 w-full overflow-hidden rounded-full bg-primary/20", @class]}
      role="progressbar"
      aria-valuemin="0"
      aria-valuemax={@max}
      aria-valuenow={@value}
      {@rest}
    >
      <div
        class="h-full w-full flex-1 bg-primary transition-all"
        style={"transform: translateX(-#{100 - @pct}%)"}
      />
    </div>
    """
  end
end
