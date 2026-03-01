defmodule ElixircnWeb.Components.UI.Select do
  use Phoenix.Component
  import ElixircnWeb.Components.UI.Icon
  alias Phoenix.LiveView.JS

  attr :id, :string, required: true
  attr :name, :string, default: nil
  attr :value, :string, default: nil
  attr :placeholder, :string, default: "Select an option..."
  attr :on_change, :string, default: nil
  attr :disabled, :boolean, default: false
  attr :class, :string, default: nil

  slot :select_item, required: true do
    attr :value, :string, required: true
    attr :label, :string, required: true
  end

  def select(assigns) do
    selected = Enum.find(assigns.select_item, &(&1.value == assigns.value))
    assigns = assign(assigns, :selected_label, selected && selected.label)

    ~H"""
    <div id={@id} class={["relative", @class]}>
      <input type="hidden" name={@name} value={@value} />
      <button
        type="button"
        disabled={@disabled}
        phx-click={JS.toggle(to: "##{@id}-options",
          in: {"ease-out duration-100", "opacity-0 scale-95", "opacity-100 scale-100"},
          out: {"ease-in duration-75", "opacity-100 scale-100", "opacity-0 scale-95"},
          time: 100)}
        class={[
          "flex h-9 w-full items-center justify-between whitespace-nowrap rounded-md border border-input bg-transparent px-3 py-2 text-sm shadow-sm ring-offset-background focus:outline-none focus:ring-1 focus:ring-ring disabled:cursor-not-allowed disabled:opacity-50 [&>span]:line-clamp-1",
          !@selected_label && "text-muted-foreground"
        ]}
        aria-haspopup="listbox"
      >
        <span>{@selected_label || @placeholder}</span>
        <.icon name="chevron-down" class="h-4 w-4 opacity-50 shrink-0" />
      </button>
      <div
        id={"#{@id}-options"}
        class="hidden absolute z-50 left-0 top-full mt-1 min-w-[8rem] w-full overflow-hidden rounded-md border bg-popover text-popover-foreground shadow-md"
      >
        <div class="p-1" role="listbox">
          <div
            :for={item <- @select_item}
            role="option"
            aria-selected={to_string(item.value == @value)}
            phx-click={item_click(@id, @on_change, item.value)}
            class={[
              "relative flex w-full cursor-pointer select-none items-center rounded-sm py-1.5 pl-8 pr-2 text-sm outline-none hover:bg-accent hover:text-accent-foreground",
              item.value == @value && "bg-accent"
            ]}
          >
            <span :if={item.value == @value} class="absolute left-2 flex h-3.5 w-3.5 items-center justify-center">
              <.icon name="check" class="h-4 w-4" />
            </span>
            {item.label}
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp item_click(id, nil, _value),
    do: JS.hide(to: "##{id}-options")

  defp item_click(id, on_change, value),
    do: JS.push(on_change, value: %{value: value}) |> JS.hide(to: "##{id}-options")
end
