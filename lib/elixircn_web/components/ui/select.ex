defmodule ElixircnWeb.Components.UI.Select do
  @moduledoc "Provides a custom select component with form field integration, dropdown options, and error display."
  use Phoenix.Component
  import ElixircnWeb.Components.UI.Icon
  import ElixircnWeb.Components.UI.Utils
  alias Phoenix.LiveView.JS

  attr :field, Phoenix.HTML.FormField, default: nil, doc: "a form field struct; auto-extracts id, name, and value"
  attr :id, :string, default: nil
  attr :name, :string, default: nil
  attr :value, :any, default: nil
  attr :placeholder, :string, default: "Select an option..."
  attr :on_change, :string, default: nil
  attr :disabled, :boolean, default: false
  attr :errors, :list, default: []
  attr :class, :any, default: nil
  attr :rest, :global

  slot :select_item, required: true do
    attr :value, :any, required: true
    attr :label, :string, required: true
  end

  @doc "Handles form field struct assignment before delegating to the base select render."
  def select(%{field: %Phoenix.HTML.FormField{} = f} = assigns) do
    assigns
    |> assign(field: nil)
    |> assign_new(:id, fn -> f.id end)
    |> assign_new(:name, fn -> f.name end)
    |> assign_new(:value, fn -> f.value end)
    |> select()
  end

  @doc "Renders a custom select dropdown with a hidden input, trigger button, and option list."
  def select(assigns) do
    assigns =
      if assigns.id,
        do: assigns,
        else: assign(assigns, :id, "select-#{System.unique_integer([:positive])}")
    current = to_string(assigns.value || "")
    selected = Enum.find(assigns.select_item, &(to_string(&1.value) == current))
    assigns = assign(assigns, :selected_label, selected && selected.label)

    ~H"""
    <div id={@id} class={cn(["relative", @class])} phx-hook="SelectNav" data-select-root {@rest}>
      <input type="hidden" name={@name} value={@value} />
      <div
        id={"#{@id}-backdrop"}
        class="hidden fixed inset-0 pointer-events-none"
        phx-click={JS.hide(to: "##{@id}-backdrop") |> JS.hide(to: "##{@id}-options")}
        data-select-backdrop
        data-escape-close
      />
      <button
        type="button"
        disabled={@disabled}
        data-select-trigger
        phx-click={
          JS.toggle(
            to: "##{@id}-options",
            in: {"ease-out duration-100", "opacity-0 scale-95", "opacity-100 scale-100"},
            out: {"ease-in duration-75", "opacity-100 scale-100", "opacity-0 scale-95"},
            time: 100
          )
          |> JS.toggle(to: "##{@id}-backdrop")
        }
        class={cn([
          "flex h-9 w-full items-center justify-between whitespace-nowrap rounded-md border border-input bg-transparent px-3 py-2 text-sm shadow-sm ring-offset-background focus:outline-none focus:ring-1 focus:ring-ring disabled:cursor-not-allowed disabled:opacity-50 [&>span]:line-clamp-1",
          !@selected_label && "text-muted-foreground",
          @errors != [] && "border-destructive focus:ring-destructive"
        ])}
        aria-invalid={@errors != [] && "true"}
        aria-haspopup="listbox"
      >
        <span id={"#{@id}-label"} phx-hook="SelectLabel">{@selected_label || @placeholder}</span>
        <.icon name="chevron-down" class="h-4 w-4 opacity-50 shrink-0" />
      </button>
      <div
        id={"#{@id}-options"}
        data-select-options
        class="hidden absolute z-50 left-0 top-full mt-1 min-w-[8rem] w-full overflow-hidden rounded-md border bg-popover text-popover-foreground shadow-md"
      >
        <div class="p-1" role="listbox">
          <div
            :for={item <- @select_item}
            role="option"
            tabindex="-1"
            aria-selected={to_string(to_string(item.value) == current)}
            phx-click={item_click(@id, @on_change, item.value, item.label)}
            class={cn([
              "relative flex w-full cursor-pointer select-none items-center rounded-sm py-1.5 pl-8 pr-2 text-sm outline-none hover:bg-accent hover:text-accent-foreground focus:bg-accent focus:text-accent-foreground",
              to_string(item.value) == current && "bg-accent"
            ])}
          >
            <span
              :if={to_string(item.value) == current}
              class="absolute left-2 flex h-3.5 w-3.5 items-center justify-center"
            >
              <.icon name="check" class="h-4 w-4" />
            </span>
            {item.label}
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp item_click(id, nil, value, label),
    do:
      JS.set_attribute({"value", to_string(value)}, to: "##{id} input[type=hidden]")
      |> JS.dispatch("input", to: "##{id} input[type=hidden]", bubbles: true)
      |> JS.dispatch("set-label", to: "##{id}-label", detail: %{label: label})
      |> JS.remove_class("text-muted-foreground", to: "##{id} button")
      |> JS.hide(to: "##{id}-options")
      |> JS.hide(to: "##{id}-backdrop")

  defp item_click(id, on_change, value, _label),
    do:
      JS.push(on_change, value: %{value: value})
      |> JS.hide(to: "##{id}-options")
      |> JS.hide(to: "##{id}-backdrop")
end
