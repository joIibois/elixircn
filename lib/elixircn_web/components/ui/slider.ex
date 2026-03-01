defmodule ElixircnWeb.Components.UI.Slider do
  use Phoenix.Component

  attr :id, :string, default: nil
  attr :name, :string, default: nil
  attr :value, :integer, default: 50
  attr :min, :integer, default: 0
  attr :max, :integer, default: 100
  attr :step, :integer, default: 1
  attr :disabled, :boolean, default: false
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(phx-change phx-blur)

  def slider(assigns) do
    ~H"""
    <div class={["relative w-full", @class]}>
      <input
        id={@id}
        name={@name}
        type="range"
        min={@min}
        max={@max}
        step={@step}
        value={@value}
        disabled={@disabled}
        class="w-full h-2 appearance-none rounded-full bg-secondary accent-primary cursor-pointer disabled:cursor-not-allowed disabled:opacity-50 focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring"
        {@rest}
      />
    </div>
    """
  end
end
