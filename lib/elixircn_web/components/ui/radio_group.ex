defmodule ElixircnWeb.Components.UI.RadioGroup do
  @moduledoc "Provides a radio group component with form field integration and individual radio item support."
  use Phoenix.Component
  import ElixircnWeb.Components.UI.Utils

  attr :field, Phoenix.HTML.FormField, default: nil, doc: "a form field struct; auto-extracts id, name, and value"
  attr :id, :string, default: nil
  attr :name, :string, default: nil
  attr :value, :string, default: nil
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Handles form field struct assignment before delegating to the base radio group render."
  def radio_group(%{field: %Phoenix.HTML.FormField{} = f} = assigns) do
    assigns
    |> assign(field: nil)
    |> assign_new(:id, fn -> f.id end)
    |> assign_new(:name, fn -> f.name end)
    |> assign_new(:value, fn -> f.value end)
    |> radio_group()
  end

  @doc "Renders a radio group container passing name and current value to the inner block."
  def radio_group(assigns) do
    ~H"""
    <div id={@id} class={cn(["grid gap-2", @class])} {@rest}>
      {render_slot(@inner_block, %{name: @name, value: @value})}
    </div>
    """
  end

  attr :id, :string, default: nil
  attr :name, :string, default: nil
  attr :value, :string, required: true
  attr :checked, :boolean, default: false
  attr :disabled, :boolean, default: false
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block

  @doc "Renders an individual radio input with an optional label."
  def radio_group_item(assigns) do
    ~H"""
    <div class={cn(["flex items-center gap-2", @class])}>
      <input
        id={@id}
        name={@name}
        type="radio"
        value={@value}
        checked={@checked}
        disabled={@disabled}
        class="peer h-4 w-4 shrink-0 rounded-full border border-primary text-primary shadow focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:cursor-not-allowed disabled:opacity-50"
        {@rest}
      />
      <label
        :if={@inner_block != []}
        for={@id}
        class="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70"
      >
        {render_slot(@inner_block)}
      </label>
    </div>
    """
  end
end
