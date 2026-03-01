defmodule ElixircnWeb.Components.UI.DatePicker do
  use Phoenix.Component
  import ElixircnWeb.Components.UI.Icon
  alias Phoenix.LiveView.JS

  attr :id, :string, required: true
  attr :selected, :any, default: nil
  attr :placeholder, :string, default: "Pick a date"
  attr :on_select, :string, default: "date_picker_select"
  attr :on_prev, :string, default: "date_picker_prev"
  attr :on_next, :string, default: "date_picker_next"
  attr :month, :integer, default: nil
  attr :year, :integer, default: nil
  attr :class, :string, default: nil

  def date_picker(assigns) do
    today = Date.utc_today()
    month = assigns.month || (assigns.selected && assigns.selected.month) || today.month
    year = assigns.year || (assigns.selected && assigns.selected.year) || today.year
    assigns = assign(assigns, month: month, year: year)

    ~H"""
    <div id={@id} class={["relative", @class]}>
      <div
        id={"#{@id}-backdrop"}
        class="hidden fixed inset-0 z-40"
        phx-click={JS.hide(to: "##{@id}-backdrop") |> JS.hide(to: "##{@id}-calendar-popup")}
      />
      <button
        type="button"
        phx-click={
          JS.toggle(to: "##{@id}-calendar-popup",
            in: {"ease-out duration-150", "opacity-0 scale-95", "opacity-100 scale-100"},
            out: {"ease-in duration-100", "opacity-100 scale-100", "opacity-0 scale-95"},
            time: 150)
          |> JS.toggle(to: "##{@id}-backdrop")
        }
        class={[
          "inline-flex h-9 w-[240px] items-center justify-start rounded-md border border-input bg-transparent px-4 py-2 text-sm shadow-sm hover:bg-accent hover:text-accent-foreground focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring",
          !@selected && "text-muted-foreground"
        ]}
      >
        <.icon name="calendar" class="mr-2 h-4 w-4 opacity-50" />
        {if @selected, do: Calendar.strftime(@selected, "%B %-d, %Y"), else: @placeholder}
      </button>
      <div
        id={"#{@id}-calendar-popup"}
        class="hidden absolute top-full left-0 z-50 mt-1 rounded-md border bg-popover shadow-md"
      >
        <ElixircnWeb.Components.UI.Calendar.calendar
          id={"#{@id}-cal"}
          month={@month}
          year={@year}
          selected={@selected}
          today={Date.utc_today()}
          on_select={JS.push(@on_select) |> JS.hide(to: "##{@id}-calendar-popup") |> JS.hide(to: "##{@id}-backdrop")}
          on_prev={@on_prev}
          on_next={@on_next}
        />
      </div>
    </div>
    """
  end
end
