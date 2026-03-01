defmodule ElixircnWeb.Components.UI.Checkbox do
  use Phoenix.Component

  attr :id, :string, default: nil
  attr :name, :string, default: nil
  attr :checked, :boolean, default: false
  attr :disabled, :boolean, default: false
  attr :required, :boolean, default: false
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(phx-change phx-click)
  slot :inner_block

  def checkbox(assigns) do
    ~H"""
    <div class="flex items-center gap-2">
      <input
        id={@id}
        name={@name}
        type="checkbox"
        checked={@checked}
        disabled={@disabled}
        required={@required}
        class={[
          "peer h-4 w-4 shrink-0 rounded-sm border border-primary shadow focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:cursor-not-allowed disabled:opacity-50 checked:bg-primary checked:text-primary-foreground",
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
