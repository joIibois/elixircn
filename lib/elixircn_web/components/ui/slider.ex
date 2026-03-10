defmodule ElixircnWeb.Components.UI.Slider do
  @moduledoc "Provides a custom range slider with tooltip, progress fill, hover preview, and animated thumb."
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

  @doc "Renders a custom slider with progress fill, tooltip, hover preview, and animated thumb."
  def slider(assigns) do
    pct = percent(assigns.value, assigns.min, assigns.max)
    assigns = assign(assigns, :pct, pct)

    ~H"""
    <div
      id={@id || "slider-#{System.unique_integer([:positive])}"}
      class={cn(["relative w-full group", @class])}
      phx-hook="Slider"
      data-min={@min}
      data-max={@max}
      data-step={@step}
      data-value={@value}
      data-disabled={@disabled && "true"}
      {@rest}
    >
      <input type="hidden" name={@name} value={@value} data-slider-input />

      <%!-- Tooltip --%>
      <div
        class="absolute -top-10 pointer-events-none opacity-0 transition-opacity duration-150"
        style={"left: #{@pct}%"}
        data-slider-tooltip
      >
        <div class="relative -translate-x-1/2 rounded-md border bg-popover px-2.5 py-1 text-xs font-medium text-popover-foreground shadow-sm select-none">
          <span data-slider-tooltip-value>{round_value(@value, @step)}</span>
        </div>
      </div>

      <%!-- Track --%>
      <div
        class={[
          "relative h-2 w-full rounded-full cursor-pointer select-none",
          "before:content-[''] before:absolute before:-top-4 before:-bottom-4 before:left-0 before:right-0",
          "bg-secondary",
          @disabled && "opacity-50 cursor-not-allowed"
        ]}
        data-slider-track
        aria-invalid={@errors != [] && "true"}
      >
        <%!-- Hover preview fill (current value → hover position) --%>
        <div
          class="absolute top-0 h-full rounded-full bg-primary/20 pointer-events-none opacity-0 transition-opacity duration-150"
          style={"left: #{@pct}%; width: 0%"}
          data-slider-hover-fill
        />

        <%!-- Active fill (left → current value) --%>
        <div
          class="absolute top-0 left-0 h-full rounded-full bg-primary pointer-events-none"
          style={"width: #{@pct}%"}
          data-slider-fill
        />

        <%!-- Thumb --%>
        <div
          class={[
            "absolute top-1/2 -translate-y-1/2 -translate-x-1/2 h-5 w-5 rounded-full border-2 border-primary bg-background shadow-sm",
            "ring-offset-background focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2",
            @disabled && "cursor-not-allowed" || "cursor-grab active:cursor-grabbing"
          ]}
          style={"left: #{@pct}%"}
          tabindex={!@disabled && "0"}
          role="slider"
          aria-valuemin={@min}
          aria-valuemax={@max}
          aria-valuenow={@value}
          data-slider-thumb
        />
      </div>
    </div>
    """
  end

  defp percent(value, min, max) do
    v = parse_number(value)
    mn = parse_number(min)
    mx = parse_number(max)
    if mx == mn, do: 0.0, else: (v - mn) / (mx - mn) * 100
  end

  defp parse_number(v) when is_binary(v) do
    case Float.parse(v) do
      {f, _} -> f
      :error -> 0.0
    end
  end
  defp parse_number(v) when is_number(v), do: v / 1
  defp parse_number(_), do: 0.0

  defp round_value(value, step) do
    v = parse_number(value)
    s = parse_number(step)
    if s == trunc(s) and s >= 1, do: trunc(v), else: Float.round(v, 2)
  end
end
