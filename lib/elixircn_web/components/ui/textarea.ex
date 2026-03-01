defmodule ElixircnWeb.Components.UI.Textarea do
  use Phoenix.Component

  attr :id, :string, default: nil
  attr :name, :string, default: nil
  attr :value, :string, default: nil
  attr :placeholder, :string, default: nil
  attr :disabled, :boolean, default: false
  attr :required, :boolean, default: false
  attr :rows, :integer, default: 3
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(phx-change phx-blur phx-focus phx-debounce)

  def textarea(assigns) do
    ~H"""
    <textarea
      id={@id}
      name={@name}
      placeholder={@placeholder}
      disabled={@disabled}
      required={@required}
      rows={@rows}
      class={[
        "flex min-h-[60px] w-full rounded-md border border-input bg-transparent px-3 py-2 text-base shadow-sm placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:cursor-not-allowed disabled:opacity-50 md:text-sm",
        @class
      ]}
      {@rest}
    >{@value}</textarea>
    """
  end
end
