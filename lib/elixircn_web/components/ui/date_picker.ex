defmodule ElixircnWeb.Components.UI.DatePicker do
  @moduledoc "Provides a date picker component combining a trigger button with a calendar popup."
  use Phoenix.Component
  import ElixircnWeb.Components.UI.Icon
  import ElixircnWeb.Components.UI.Utils
  import ElixircnWeb.Components.UI.Calendar
  alias Phoenix.LiveView.JS

  attr :id, :string, required: true
  attr :selected, :any, default: nil
  attr :placeholder, :string, default: "Pick a date"
  attr :on_select, :string, required: true
  attr :on_prev, :string, required: true
  attr :on_next, :string, required: true
  attr :month, :integer, default: nil
  attr :year, :integer, default: nil
  attr :class, :any, default: nil
  attr :rest, :global

  @doc "Renders a date picker with a button trigger that opens a calendar popup for date selection."
  def date_picker(assigns) do
    today = Date.utc_today()
    month = assigns.month || (assigns.selected && assigns.selected.month) || today.month
    year = assigns.year || (assigns.selected && assigns.selected.year) || today.year
    assigns = assign(assigns, month: month, year: year)

    ~H"""
    <div id={@id} class={cn(["relative", @class])} {@rest}>
      <div
        id={"#{@id}-backdrop"}
        class="hidden fixed inset-0 z-40"
        phx-click={JS.hide(to: "##{@id}-backdrop") |> JS.hide(to: "##{@id}-calendar-popup")}
        data-escape-close
      />
      <button
        id={"#{@id}-trigger"}
        type="button"
        aria-expanded="false"
        phx-click={
          JS.toggle(
            to: "##{@id}-calendar-popup",
            in: {"ease-out duration-150", "opacity-0 scale-95", "opacity-100 scale-100"},
            out: {"ease-in duration-100", "opacity-100 scale-100", "opacity-0 scale-95"},
            time: 150
          )
          |> JS.toggle(to: "##{@id}-backdrop")
          |> JS.toggle_attribute({"aria-expanded", "true", "false"}, to: "##{@id}-trigger")
        }
        class={cn([
          "inline-flex h-9 w-full items-center justify-start rounded-md border border-input bg-transparent px-4 py-2 text-sm shadow-sm hover:bg-accent hover:text-accent-foreground focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring",
          !@selected && "text-muted-foreground"
        ])}
      >
        <.icon name="calendar" class="mr-2 h-4 w-4 opacity-50" />
        {if @selected, do: Calendar.strftime(@selected, "%B %-d, %Y"), else: @placeholder}
      </button>
      <div
        id={"#{@id}-calendar-popup"}
        class="hidden absolute top-full left-0 z-50 mt-1 rounded-md border bg-popover shadow-md"
      >
        <.calendar
          id={"#{@id}-cal"}
          month={@month}
          year={@year}
          selected={@selected}
          today={Date.utc_today()}
          on_select={
            JS.push(@on_select)
            |> JS.hide(to: "##{@id}-calendar-popup")
            |> JS.hide(to: "##{@id}-backdrop")
            |> JS.set_attribute({"aria-expanded", "false"}, to: "##{@id}-trigger")
          }
          on_prev={@on_prev}
          on_next={@on_next}
        />
      </div>
    </div>
    """
  end
end
