defmodule ElixircnWeb.Components.UI.Combobox do
  use Phoenix.Component
  import ElixircnWeb.Components.UI.Icon
  alias Phoenix.LiveView.JS

  attr :id, :string, required: true
  attr :value, :string, default: nil
  attr :placeholder, :string, default: "Select..."
  attr :search_placeholder, :string, default: "Search..."
  attr :options, :list, default: []
  attr :on_select, :string, default: "combobox_select"
  attr :class, :string, default: nil

  def combobox(assigns) do
    selected = Enum.find(assigns.options, &(&1[:value] == assigns.value))
    assigns = assign(assigns, :selected_label, selected && selected[:label])

    ~H"""
    <div id={@id} class={["relative", @class]}>
      <div
        id={"#{@id}-backdrop"}
        class="hidden fixed inset-0 z-40"
        phx-click={JS.hide(to: "##{@id}-backdrop") |> JS.hide(to: "##{@id}-dropdown")}
        data-escape-close
      />
      <button
        type="button"
        role="combobox"
        phx-click={
          JS.toggle(to: "##{@id}-dropdown",
            in: {"ease-out duration-150", "opacity-0 scale-95", "opacity-100 scale-100"},
            out: {"ease-in duration-100", "opacity-100 scale-100", "opacity-0 scale-95"},
            time: 150)
          |> JS.toggle(to: "##{@id}-backdrop")
        }
        class={[
          "inline-flex h-9 w-[200px] items-center justify-between whitespace-nowrap rounded-md border border-input bg-transparent px-3 py-2 text-sm shadow-sm hover:bg-accent focus:outline-none focus:ring-1 focus:ring-ring disabled:cursor-not-allowed disabled:opacity-50",
          !@selected_label && "text-muted-foreground"
        ]}
      >
        <span>{@selected_label || @placeholder}</span>
        <.icon name="chevrons-up-down" class="h-4 w-4 opacity-50 shrink-0" />
      </button>
      <div
        id={"#{@id}-dropdown"}
        class="hidden absolute z-50 left-0 top-full mt-1 min-w-[200px] w-full overflow-hidden rounded-md border bg-popover text-popover-foreground shadow-md"
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
            phx-click={JS.push(@on_select, value: %{value: opt[:value]}) |> JS.hide(to: "##{@id}-dropdown") |> JS.hide(to: "##{@id}-backdrop")}
            class={[
              "relative flex cursor-pointer select-none items-center rounded-sm px-2 py-1.5 text-sm outline-none hover:bg-accent hover:text-accent-foreground",
              @value == opt[:value] && "bg-accent"
            ]}
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
