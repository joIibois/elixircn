defmodule ElixircnWeb.Components.UI.NativeSelect do
  @moduledoc "Provides a styled native HTML select component with form field integration and error display."
  use Phoenix.Component
  import ElixircnWeb.Components.UI.Utils

  attr :field, Phoenix.HTML.FormField, default: nil, doc: "a form field struct; auto-extracts id, name, value, and errors"
  attr :id, :string, default: nil
  attr :name, :string, default: nil
  attr :value, :any, default: nil
  attr :disabled, :boolean, default: false
  attr :required, :boolean, default: false
  attr :errors, :list, default: []
  attr :class, :any, default: nil
  attr :rest, :global, include: ~w(form data-confirm)

  slot :option, doc: "option items; each receives :selected based on the current value" do
    attr :value, :string, required: true
  end

  slot :inner_block, doc: "raw inner content (ignored when :option slots are provided)"

  @doc "Handles form field struct assignment before delegating to the base native select render."
  def native_select(%{field: %Phoenix.HTML.FormField{} = f} = assigns) do
    assigns
    |> assign(field: nil)
    |> assign_new(:id, fn -> f.id end)
    |> assign_new(:name, fn -> f.name end)
    |> assign_new(:value, fn -> f.value end)
    |> assign(:errors, Enum.map(f.errors, &translate_error/1))
    |> native_select()
  end

  @doc "Renders a styled native select element with optional error styling."
  def native_select(assigns) do
    ~H"""
    <select
      id={@id}
      name={@name}
      disabled={@disabled}
      required={@required}
      aria-invalid={@errors != [] && "true"}
      class={cn([
        "flex h-9 w-full appearance-none items-center justify-between whitespace-nowrap rounded-md border border-input bg-transparent px-3 py-2 text-sm shadow-sm ring-offset-background placeholder:text-muted-foreground focus:outline-none focus:ring-1 focus:ring-ring disabled:cursor-not-allowed disabled:opacity-50",
        @errors != [] && "border-destructive focus:ring-destructive",
        @class
      ])}
      {@rest}
    >
      <option :for={opt <- @option} value={opt.value} selected={to_string(opt.value) == to_string(@value)}>
        {render_slot(opt)}
      </option>
      {render_slot(@inner_block)}
    </select>
    """
  end

end
