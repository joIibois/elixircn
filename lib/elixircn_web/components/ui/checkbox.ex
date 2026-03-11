defmodule ElixircnWeb.Components.UI.Checkbox do
  @moduledoc "Provides a checkbox component with optional form field integration and label support."
  use Phoenix.Component
  import ElixircnWeb.Components.UI.Utils

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Wraps checkboxes in a column layout that merges consecutive selected items visually."
  def checkbox_group(assigns) do
    ~H"""
    <div class={cn(["checkbox-group flex flex-col", @class])} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :field, Phoenix.HTML.FormField, default: nil
  attr :id, :string, default: nil
  attr :name, :string, default: nil
  attr :checked, :boolean, default: false
  attr :disabled, :boolean, default: false
  attr :required, :boolean, default: false
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block

  @doc "Renders a styled checkbox. Wrap the label text in the inner block for the full row tap-target style."
  def checkbox(%{field: %Phoenix.HTML.FormField{} = f} = assigns) do
    assigns
    |> assign(field: nil)
    |> assign_new(:id, fn -> f.id end)
    |> assign_new(:name, fn -> f.name end)
    |> assign_new(:checked, fn -> checked_value?(f.value) end)
    |> checkbox()
  end

  def checkbox(assigns) do
    ~H"""
    <label class={cn([
      "checkbox-item flex items-center gap-3 px-3 py-2.5 rounded-lg cursor-pointer select-none",
      "hover:bg-accent has-[input:checked]:bg-accent",
      "has-[input:disabled]:cursor-not-allowed has-[input:disabled]:opacity-50",
      @class
    ])}>
      <input :if={@name} type="hidden" name={@name} value="false" />
      <input
        id={@id}
        name={@name}
        type="checkbox"
        value="true"
        checked={@checked}
        disabled={@disabled}
        required={@required}
        class="checkbox-input peer h-4 w-4 shrink-0 rounded-sm border border-primary appearance-none cursor-pointer focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:cursor-not-allowed"
        {@rest}
      />
      <span
        :if={@inner_block != []}
        class="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70"
      >
        {render_slot(@inner_block)}
      </span>
    </label>
    """
  end

  defp checked_value?(val) when val in [true, "true", "on", 1, "1"], do: true
  defp checked_value?(_), do: false
end
