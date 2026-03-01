defmodule ElixircnWeb.Components.UI.RadioGroup do
  use Phoenix.Component

  attr :id, :string, default: nil
  attr :name, :string, default: nil
  attr :value, :string, default: nil
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(phx-change)
  slot :inner_block, required: true

  def radio_group(assigns) do
    ~H"""
    <div id={@id} class={["grid gap-2", @class]} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :id, :string, default: nil
  attr :name, :string, default: nil
  attr :value, :string, required: true
  attr :checked, :boolean, default: false
  attr :disabled, :boolean, default: false
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(phx-change)
  slot :inner_block

  def radio_group_item(assigns) do
    ~H"""
    <div class={["flex items-center gap-2", @class]}>
      <input
        id={@id}
        name={@name}
        type="radio"
        value={@value}
        checked={@checked}
        disabled={@disabled}
        class={[
          "peer h-4 w-4 shrink-0 rounded-full border border-primary text-primary shadow focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:cursor-not-allowed disabled:opacity-50",
          @class
        ]}
        {@rest}
      />
      <label :if={@inner_block != []} for={@id} class="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70">
        {render_slot(@inner_block)}
      </label>
    </div>
    """
  end
end
