defmodule ElixircnWeb.Components.UI.NativeSelect do
  use Phoenix.Component

  attr :id, :string, default: nil
  attr :name, :string, default: nil
  attr :value, :string, default: nil
  attr :disabled, :boolean, default: false
  attr :required, :boolean, default: false
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(phx-change)

  slot :inner_block, required: true

  def native_select(assigns) do
    ~H"""
    <select
      id={@id}
      name={@name}
      disabled={@disabled}
      required={@required}
      class={[
        "flex h-9 w-full appearance-none items-center justify-between whitespace-nowrap rounded-md border border-input bg-transparent px-3 py-2 text-sm shadow-sm ring-offset-background placeholder:text-muted-foreground focus:outline-none focus:ring-1 focus:ring-ring disabled:cursor-not-allowed disabled:opacity-50",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </select>
    """
  end
end
