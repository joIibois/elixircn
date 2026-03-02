defmodule ElixircnWeb.Components.UI.Combobox do
  @moduledoc "Provides a combobox component combining a searchable dropdown with selection state."
  use Phoenix.Component
  import ElixircnWeb.Components.UI.Icon
  import ElixircnWeb.Components.UI.Utils
  alias Phoenix.LiveView.JS

  attr :id, :string, required: true
  attr :value, :any, default: nil
  attr :placeholder, :string, default: "Select..."
  attr :search_placeholder, :string, default: "Search..."
  attr :options, :list, default: []
  attr :name, :string, default: nil
  attr :on_select, :string, required: true
  attr :errors, :list, default: []
  attr :class, :any, default: nil
  attr :rest, :global

  @doc "Renders a combobox with a searchable dropdown list and currently selected value display."
  def combobox(assigns) do
    selected = Enum.find(assigns.options, &(&1[:value] == assigns.value))
    assigns = assign(assigns, :selected_label, selected && selected[:label])

    ~H"""
    <div id={@id} class={cn(["relative w-full", @class])} {@rest}>
      <input :if={@name} type="hidden" name={@name} value={@value} />
      <div
        id={"#{@id}-backdrop"}
        class="hidden fixed inset-0 z-40"
        phx-click={JS.hide(to: "##{@id}-backdrop") |> JS.hide(to: "##{@id}-dropdown")}
        data-escape-close
      />
      <button
        id={"#{@id}-trigger"}
        type="button"
        role="combobox"
        aria-expanded="false"
        phx-click={
          JS.toggle(
            to: "##{@id}-dropdown",
            in: {"ease-out duration-150", "opacity-0 scale-95", "opacity-100 scale-100"},
            out: {"ease-in duration-100", "opacity-100 scale-100", "opacity-0 scale-95"},
            time: 150
          )
          |> JS.toggle(to: "##{@id}-backdrop")
          |> JS.toggle_attribute({"aria-expanded", "true", "false"}, to: "##{@id}-trigger")
        }
        class={cn([
          "inline-flex h-9 w-full items-center justify-between whitespace-nowrap rounded-md border border-input bg-transparent px-3 py-2 text-sm shadow-sm hover:bg-accent focus:outline-none focus:ring-1 focus:ring-ring disabled:cursor-not-allowed disabled:opacity-50",
          !@selected_label && "text-muted-foreground",
          @errors != [] && "border-destructive focus:ring-destructive"
        ])}
        aria-invalid={@errors != [] && "true"}
      >
        <span>{@selected_label || @placeholder}</span>
        <.icon name="chevrons-up-down" class="h-4 w-4 opacity-50 shrink-0" />
      </button>
      <div
        id={"#{@id}-dropdown"}
        class="hidden absolute z-50 left-0 top-full mt-1 min-w-full w-full overflow-hidden rounded-md border bg-popover text-popover-foreground shadow-md"
        data-combobox-dropdown
      >
        <div class="flex items-center border-b px-3">
          <.icon name="search" class="mr-2 h-4 w-4 shrink-0 opacity-50" />
          <input
            type="text"
            placeholder={@search_placeholder}
            phx-hook="ComboboxFilter"
            id={"#{@id}-search"}
            class="flex h-9 w-full rounded-md bg-transparent py-3 text-sm outline-none placeholder:text-muted-foreground"
          />
        </div>
        <div class="max-h-[200px] overflow-y-auto p-1">
          <div
            :for={opt <- @options}
            role="option"
            phx-click={
              JS.push(@on_select, value: %{value: opt[:value]})
              |> JS.hide(to: "##{@id}-dropdown")
              |> JS.hide(to: "##{@id}-backdrop")
              |> JS.set_attribute({"aria-expanded", "false"}, to: "##{@id}-trigger")
            }
            class={cn([
              "relative flex cursor-pointer select-none items-center rounded-sm px-2 py-1.5 text-sm outline-none hover:bg-accent hover:text-accent-foreground",
              @value == opt[:value] && "bg-accent"
            ])}
          >
            <.icon :if={@value == opt[:value]} name="check" class="mr-2 h-4 w-4" />
            <span :if={@value != opt[:value]} class="mr-6" />
            {opt[:label]}
          </div>
        </div>
      </div>
    </div>
    """
  end
end
