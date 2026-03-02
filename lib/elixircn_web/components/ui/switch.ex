defmodule ElixircnWeb.Components.UI.Switch do
  @moduledoc "Provides a toggle switch component with form field integration."
  use Phoenix.Component
  import ElixircnWeb.Components.UI.Utils

  attr :field, Phoenix.HTML.FormField, default: nil, doc: "a form field struct; auto-extracts id, name, and checked state"
  attr :id, :string, default: nil
  attr :name, :string, default: nil
  attr :checked, :boolean, default: false
  attr :disabled, :boolean, default: false
  attr :class, :any, default: nil
  attr :rest, :global

  @doc "Handles form field struct assignment before delegating to the base switch render."
  def switch(%{field: %Phoenix.HTML.FormField{} = f} = assigns) do
    assigns
    |> assign(field: nil)
    |> assign_new(:id, fn -> f.id end)
    |> assign_new(:name, fn -> f.name end)
    |> assign_new(:checked, fn -> checked_value?(f.value) end)
    |> switch()
  end

  @doc "Renders a styled toggle switch using a checkbox input with a visual track."
  def switch(assigns) do
    ~H"""
    <label class={cn([
      "relative inline-flex cursor-pointer items-center",
      @disabled && "cursor-not-allowed opacity-50",
      @class
    ])}>
      <input :if={@name} type="hidden" name={@name} value="false" />
      <input
        id={@id}
        name={@name}
        type="checkbox"
        role="switch"
        value="true"
        checked={@checked}
        aria-checked={to_string(@checked)}
        disabled={@disabled}
        class="peer sr-only"
        {@rest}
      />
      <div class="peer h-5 w-9 rounded-full border-2 border-transparent bg-input outline-none transition-colors peer-checked:bg-primary peer-focus-visible:ring-2 peer-focus-visible:ring-ring peer-focus-visible:ring-offset-2 peer-focus-visible:ring-offset-background peer-disabled:cursor-not-allowed relative after:absolute after:left-0 after:top-0 after:h-4 after:w-4 after:rounded-full after:bg-background after:shadow-sm after:transition-transform after:duration-100 peer-checked:after:translate-x-4">
      </div>
    </label>
    """
  end

  defp checked_value?(val) when val in [true, "true", "on", 1, "1"], do: true
  defp checked_value?(_), do: false
end
