defmodule ElixircnWeb.Components.UI.Switch do
  use Phoenix.Component

  attr :id, :string, default: nil
  attr :name, :string, default: nil
  attr :checked, :boolean, default: false
  attr :disabled, :boolean, default: false
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(phx-change phx-click)

  def switch(assigns) do
    ~H"""
    <label class={["relative inline-flex cursor-pointer items-center", @disabled && "cursor-not-allowed opacity-50", @class]}>
      <input
        id={@id}
        name={@name}
        type="checkbox"
        role="switch"
        checked={@checked}
        disabled={@disabled}
        class="peer sr-only"
        {@rest}
      />
      <div class="peer h-5 w-9 rounded-full border-2 border-transparent bg-input outline-none transition-colors peer-checked:bg-primary peer-focus-visible:ring-2 peer-focus-visible:ring-ring peer-focus-visible:ring-offset-2 peer-focus-visible:ring-offset-background peer-disabled:cursor-not-allowed relative after:absolute after:left-0 after:top-0 after:h-4 after:w-4 after:rounded-full after:bg-background after:shadow-sm after:transition-transform after:duration-100 peer-checked:after:translate-x-4"></div>
    </label>
    """
  end
end
