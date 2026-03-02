defmodule ElixircnWeb.Components.UI.Textarea do
  @moduledoc "Provides a styled multi-line text input component with form field integration."
  use Phoenix.Component
  import ElixircnWeb.Components.UI.Utils

  attr :field, Phoenix.HTML.FormField, default: nil, doc: "a form field struct; auto-extracts id, name, value, and errors"
  attr :id, :string, default: nil
  attr :name, :string, default: nil
  attr :value, :string, default: nil
  attr :placeholder, :string, default: nil
  attr :disabled, :boolean, default: false
  attr :required, :boolean, default: false
  attr :rows, :integer, default: 3
  attr :errors, :list, default: []
  attr :class, :any, default: nil
  attr :rest, :global, include: ~w(autocomplete)

  @doc "Renders a styled textarea, accepting either a form field struct or individual attributes."
  def textarea(%{field: %Phoenix.HTML.FormField{} = f} = assigns) do
    assigns
    |> assign(field: nil)
    |> assign_new(:id, fn -> f.id end)
    |> assign_new(:name, fn -> f.name end)
    |> assign_new(:value, fn -> f.value end)
    |> assign(:errors, Enum.map(f.errors, &translate_error/1))
    |> textarea()
  end

  def textarea(assigns) do
    ~H"""
    <textarea
      id={@id}
      name={@name}
      placeholder={@placeholder}
      disabled={@disabled}
      required={@required}
      rows={@rows}
      aria-invalid={@errors != [] && "true"}
      class={cn([
        "flex min-h-[60px] w-full rounded-md border border-input bg-transparent px-3 py-2 text-base shadow-sm placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:cursor-not-allowed disabled:opacity-50 md:text-sm",
        @errors != [] && "border-destructive focus-visible:ring-destructive",
        @class
      ])}
      {@rest}
    >{@value}</textarea>
    """
  end

end
