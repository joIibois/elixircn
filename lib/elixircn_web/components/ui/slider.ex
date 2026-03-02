defmodule ElixircnWeb.Components.UI.Slider do
  @moduledoc "Provides a range slider component with form field integration and error display."
  use Phoenix.Component
  import ElixircnWeb.Components.UI.Utils

  attr :field, Phoenix.HTML.FormField, default: nil, doc: "a form field struct; auto-extracts id, name, value, and errors"
  attr :id, :string, default: nil
  attr :name, :string, default: nil
  attr :value, :any, default: 50.0
  attr :min, :float, default: 0.0
  attr :max, :float, default: 100.0
  attr :step, :float, default: 1.0
  attr :disabled, :boolean, default: false
  attr :errors, :list, default: []
  attr :class, :any, default: nil
  attr :rest, :global, include: ~w(form data-confirm)

  @doc "Handles form field struct assignment before delegating to the base slider render."
  def slider(%{field: %Phoenix.HTML.FormField{} = f} = assigns) do
    assigns
    |> assign(field: nil)
    |> assign_new(:id, fn -> f.id end)
    |> assign_new(:name, fn -> f.name end)
    |> assign_new(:value, fn -> f.value end)
    |> assign(:errors, Enum.map(f.errors, &translate_error/1))
    |> slider()
  end

  @doc "Renders a styled range input slider with optional error styling."
  def slider(assigns) do
    ~H"""
    <div class={cn(["relative w-full", @class])}>
      <input
        id={@id}
        name={@name}
        type="range"
        min={@min}
        max={@max}
        step={@step}
        value={@value}
        disabled={@disabled}
        aria-invalid={@errors != [] && "true"}
        class={cn([
          "w-full h-2 appearance-none rounded-full bg-secondary accent-primary cursor-pointer disabled:cursor-not-allowed disabled:opacity-50 focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring",
          @errors != [] && "accent-destructive"
        ])}
        {@rest}
      />
    </div>
    """
  end

end
