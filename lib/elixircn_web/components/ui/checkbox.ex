defmodule ElixircnWeb.Components.UI.Checkbox do
  @moduledoc "Provides a checkbox component with optional form field integration and label support."
  use Phoenix.Component
  import ElixircnWeb.Components.UI.Utils

  attr :field, Phoenix.HTML.FormField, default: nil, doc: "a form field struct; auto-extracts id, name, and checked state"
  attr :id, :string, default: nil
  attr :name, :string, default: nil
  attr :checked, :boolean, default: false
  attr :disabled, :boolean, default: false
  attr :required, :boolean, default: false
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block

  @doc "Renders a checkbox with form field bindings when a FormField struct is provided."
  def checkbox(%{field: %Phoenix.HTML.FormField{} = f} = assigns) do
    assigns
    |> assign(field: nil)
    |> assign_new(:id, fn -> f.id end)
    |> assign_new(:name, fn -> f.name end)
    |> assign_new(:checked, fn -> checked_value?(f.value) end)
    |> checkbox()
  end

  @doc "Renders a styled checkbox input with an optional inline label."
  def checkbox(assigns) do
    ~H"""
    <div class="flex items-center gap-2">
      <input :if={@name} type="hidden" name={@name} value="false" />
      <input
        id={@id}
        name={@name}
        type="checkbox"
        value="true"
        checked={@checked}
        disabled={@disabled}
        required={@required}
        class={cn([
          "peer h-4 w-4 shrink-0 rounded-sm border border-primary shadow focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:cursor-not-allowed disabled:opacity-50 checked:bg-primary checked:text-primary-foreground",
          @class
        ])}
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

  defp checked_value?(val) when val in [true, "true", "on", 1, "1"], do: true
  defp checked_value?(_), do: false
end
