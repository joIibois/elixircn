defmodule ElixircnWeb.Components.UI.Calendar do
  use Phoenix.Component
  import ElixircnWeb.Components.UI.Icon

  attr :id, :string, required: true
  attr :month, :integer, required: true
  attr :year, :integer, required: true
  attr :selected, :any, default: nil
  attr :today, :any, default: nil
  attr :on_select, :any, default: "calendar_select"
  attr :on_prev, :string, default: "calendar_prev"
  attr :on_next, :string, default: "calendar_next"
  attr :class, :string, default: nil

  @day_names ~w(Su Mo Tu We Th Fr Sa)
  @month_names ~w(January February March April May June July August September October November December)

  def calendar(assigns) do
    today = assigns.today || Date.utc_today()
    first_day = Date.new!(assigns.year, assigns.month, 1)
    days_in_month = Date.days_in_month(first_day)
    start_dow = Date.day_of_week(first_day, :sunday) - 1
    month_name = Enum.at(@month_names, assigns.month - 1)
    weeks = build_weeks(start_dow, days_in_month)

    assigns =
      assigns
      |> assign(:today, today)
      |> assign(:month_name, month_name)
      |> assign(:day_names, @day_names)
      |> assign(:weeks, weeks)

    ~H"""
    <div id={@id} class={["p-3", @class]}>
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
              <th :for={day <- @day_names} class="text-muted-foreground rounded-md w-9 font-normal text-[0.8rem] text-center">
                {day}
              </th>
            </tr>
          </thead>
          <tbody>
            <tr :for={week <- @weeks} class="flex w-full mt-2">
              <td :for={day <- week} class="relative p-0 text-center text-sm">
                <button
                  :if={day}
                  type="button"
                  phx-click={@on_select}
                  phx-value-date={day && Date.to_iso8601(Date.new!(@year, @month, day))}
                  class={[
                    "inline-flex h-9 w-9 items-center justify-center rounded-md text-sm font-normal transition-colors hover:bg-accent hover:text-accent-foreground focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring",
                    day && Date.new!(@year, @month, day) == @today && @selected != Date.new!(@year, @month, day) && "bg-accent text-accent-foreground font-semibold",
                    day && @selected && Date.new!(@year, @month, day) == @selected && "bg-primary text-primary-foreground hover:bg-primary hover:text-primary-foreground"
                  ]}
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

  defp build_weeks(start_dow, days_in_month) do
    padding = List.duplicate(nil, start_dow)
    days = Enum.to_list(1..days_in_month)
    all = padding ++ days
    remainder = rem(length(all), 7)
    all = if remainder > 0, do: all ++ List.duplicate(nil, 7 - remainder), else: all
    Enum.chunk_every(all, 7)
  end
end
