defmodule ElixircnWeb.Components.UI.Input do
  @moduledoc "Provides a styled text input component with form field integration and error display."
  use Phoenix.Component
  import ElixircnWeb.Components.UI.Utils

  attr :field, Phoenix.HTML.FormField, default: nil, doc: "a form field struct; auto-extracts id, name, value, and errors"
  attr :id, :string, default: nil
  attr :name, :string, default: nil
  attr :type, :string, default: "text"
  attr :value, :any, default: nil
  attr :placeholder, :string, default: nil
  attr :disabled, :boolean, default: false
  attr :required, :boolean, default: false
  attr :readonly, :boolean, default: false
  attr :errors, :list, default: []
  attr :class, :any, default: nil

  attr :rest, :global, include: ~w(autocomplete min max step pattern)

  @doc "Handles form field struct assignment before delegating to the base input render."
  def input(%{field: %Phoenix.HTML.FormField{} = f} = assigns) do
    assigns
    |> assign(field: nil)
    |> assign_new(:id, fn -> f.id end)
    |> assign_new(:name, fn -> f.name end)
    |> assign_new(:value, fn -> f.value end)
    |> assign(:errors, Enum.map(f.errors, &translate_error/1))
    |> input()
  end

  @doc "Renders a styled input element with optional error styling."
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
      aria-invalid={@errors != [] && "true"}
      class={cn([
        "flex h-9 w-full rounded-md border border-input bg-transparent px-3 leading-9 text-base shadow-sm transition-colors file:border-0 file:bg-transparent file:text-sm file:font-medium file:text-foreground placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:cursor-not-allowed disabled:opacity-50 md:text-sm",
        @errors != [] && "border-destructive focus-visible:ring-destructive",
        @class
      ])}
      {@rest}
    />
    """
  end

end
