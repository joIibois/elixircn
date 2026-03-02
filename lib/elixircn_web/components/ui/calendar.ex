defmodule ElixircnWeb.Components.UI.Calendar do
  @moduledoc "Provides a calendar component for date display and selection with navigation controls."
  use Phoenix.Component
  import ElixircnWeb.Components.UI.Icon
  import ElixircnWeb.Components.UI.Utils

  attr :id, :string, required: true
  attr :month, :integer, required: true
  attr :year, :integer, required: true
  attr :selected, :any, default: nil
  attr :today, :any, default: nil
  attr :on_select, :any,
    required: true,
    doc: "event name (string) or %JS{} struct fired when a day is clicked, receives %{\"date\" => \"YYYY-MM-DD\"}"

  attr :on_prev, :string, required: true, doc: "event name pushed when the previous-month button is clicked"
  attr :on_next, :string, required: true, doc: "event name pushed when the next-month button is clicked"
  attr :class, :any, default: nil
  attr :day_names, :list, default: ~w(Su Mo Tu We Th Fr Sa),
    doc: "list of 7 day-name abbreviations starting from the week_start day"
  attr :month_names, :list,
    default: ~w(January February March April May June July August September October November December),
    doc: "list of 12 full month names"
  attr :week_start, :atom, default: :sunday, values: [:sunday, :monday],
    doc: "first day of the week; affects how days are offset"
  attr :rest, :global

  @doc "Renders a monthly calendar grid with previous/next navigation and selectable day buttons."
  def calendar(assigns) do
    today = assigns.today || Date.utc_today()
    {year, month} = wrap_month(assigns.year, assigns.month)
    first_day = Date.new!(year, month, 1)
    days_in_month = Date.days_in_month(first_day)
    start_dow = Date.day_of_week(first_day, assigns.week_start) - 1
    month_name = Enum.at(assigns.month_names, month - 1)
    weeks = build_weeks(year, month, start_dow, days_in_month, assigns.selected, today)

    assigns =
      assigns
      |> assign(:today, today)
      |> assign(:month_name, month_name)
      |> assign(:weeks, weeks)

    ~H"""
    <div id={@id} class={cn(["p-3", @class])} {@rest}>
      <div class="flex flex-col space-y-4">
        <div class="relative flex items-center justify-center pt-1">
          <button
            type="button"
            phx-click={@on_prev}
            class="absolute left-1 inline-flex h-7 w-7 items-center justify-center rounded-md border border-input bg-transparent p-0 opacity-50 hover:opacity-100"
            aria-label="Previous month"
          >
            <.icon name="chevron-left" class="h-4 w-4" />
          </button>
          <div class="text-sm font-medium">{@month_name} {@year}</div>
          <button
            type="button"
            phx-click={@on_next}
            class="absolute right-1 inline-flex h-7 w-7 items-center justify-center rounded-md border border-input bg-transparent p-0 opacity-50 hover:opacity-100"
            aria-label="Next month"
          >
            <.icon name="chevron-right" class="h-4 w-4" />
          </button>
        </div>
        <table class="w-full border-collapse space-y-1">
          <thead>
            <tr class="flex">
              <th
                :for={day <- @day_names}
                class="text-muted-foreground rounded-md w-9 font-normal text-[0.8rem] text-center"
              >
                {day}
              </th>
            </tr>
          </thead>
          <tbody>
            <tr :for={week <- @weeks} class="flex w-full mt-2">
              <td :for={{day, date} <- week} class="relative p-0 text-center text-sm">
                <button
                  :if={day}
                  type="button"
                  phx-click={@on_select}
                  phx-value-date={date && Date.to_iso8601(date)}
                  class={cn([
                    "inline-flex h-9 w-9 items-center justify-center rounded-md text-sm font-normal transition-colors hover:bg-accent hover:text-accent-foreground focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring",
                    date == @today && @selected != date &&
                      "bg-accent text-accent-foreground font-semibold",
                    @selected && date == @selected &&
                      "bg-primary text-primary-foreground hover:bg-primary hover:text-primary-foreground"
                  ])}
                >
                  {day}
                </button>
                <div :if={!day} class="h-9 w-9" />
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
    """
  end

  defp wrap_month(year, month) when month > 12, do: wrap_month(year + 1, month - 12)
  defp wrap_month(year, month) when month < 1, do: wrap_month(year - 1, month + 12)
  defp wrap_month(year, month), do: {year, month}

  defp build_weeks(year, month, start_dow, days_in_month, _selected, _today) do
    padding = List.duplicate({nil, nil}, start_dow)

    days =
      Enum.map(1..days_in_month, fn day ->
        {day, Date.new!(year, month, day)}
      end)

    all = padding ++ days
    remainder = rem(length(all), 7)
    all = if remainder > 0, do: all ++ List.duplicate({nil, nil}, 7 - remainder), else: all
    Enum.chunk_every(all, 7)
  end
end
