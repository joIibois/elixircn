defmodule ElixircnWeb.Components.UI.Input do
  use Phoenix.Component

  attr :id, :string, default: nil
  attr :name, :string, default: nil
  attr :type, :string, default: "text"
  attr :value, :any, default: nil
  attr :placeholder, :string, default: nil
  attr :disabled, :boolean, default: false
  attr :required, :boolean, default: false
  attr :readonly, :boolean, default: false
  attr :errors, :list, default: []
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(phx-change phx-blur phx-focus phx-debounce autocomplete min max step pattern)

  def input(assigns) do
    ~H"""
    <input
      id={@id}
      name={@name}
      type={@type}
      value={@value}
      placeholder={@placeholder}
      disabled={@disabled}
      required={@required}
      readonly={@readonly}
      class={[
        "flex h-9 w-full rounded-md border border-input bg-transparent px-3 leading-9 text-base shadow-sm transition-colors file:border-0 file:bg-transparent file:text-sm file:font-medium file:text-foreground placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:cursor-not-allowed disabled:opacity-50 md:text-sm",
        @errors != [] && "border-destructive focus-visible:ring-destructive",
        @class
      ]}
      {@rest}
    />
    """
  end
end
