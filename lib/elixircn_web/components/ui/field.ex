defmodule ElixircnWeb.Components.UI.Field do
  @moduledoc "Provides a form field wrapper component with label, description, and error display."
  use Phoenix.Component
  import ElixircnWeb.Components.UI.Utils

  attr :field, Phoenix.HTML.FormField, default: nil, doc: "a form field struct; auto-extracts id, label (humanized), and errors"
  attr :id, :string, default: nil
  attr :label, :string, default: nil
  attr :description, :string, default: nil
  attr :errors, :list, default: []
  attr :class, :any, default: nil
  attr :rest, :global

  slot :inner_block, required: true

  @doc "Renders a field with form field bindings when a FormField struct is provided."
  def field(%{field: %Phoenix.HTML.FormField{} = f} = assigns) do
    assigns
    |> assign(field: nil)
    |> assign_new(:id, fn -> f.id end)
    |> assign_new(:label, fn -> Phoenix.Naming.humanize(f.field) end)
    |> assign(:errors, Enum.map(f.errors, &translate_error/1))
    |> field()
  end

  @doc "Renders a form field wrapper with label, inner content, description, and validation errors."
  def field(assigns) do
    ~H"""
    <div class={cn(["space-y-2", @class])} {@rest}>
      <label
        :if={@label}
        for={@id}
        class="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70"
      >
        {@label}
      </label>
      {render_slot(@inner_block)}
      <p :if={@description && @errors == []} class="text-[0.8rem] text-muted-foreground">
        {@description}
      </p>
      <p :for={error <- @errors} class="text-[0.8rem] font-medium text-destructive">
        {error}
      </p>
    </div>
    """
  end

end
