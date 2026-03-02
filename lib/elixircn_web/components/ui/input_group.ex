defmodule ElixircnWeb.Components.UI.InputGroup do
  @moduledoc "Provides an input group component that composes an input with optional start and end addons."
  use Phoenix.Component
  import ElixircnWeb.Components.UI.Utils

  attr :class, :any, default: nil
  attr :rest, :global

  slot :addon_start
  slot :addon_end
  slot :inner_block, required: true

  @doc "Renders an input group with optional prefix and suffix addon slots."
  def input_group(assigns) do
    ~H"""
    <div
      class={cn(["flex items-stretch overflow-hidden rounded-md shadow-sm [&_input]:shadow-none", @class])}
      {@rest}
    >
      <span
        :if={@addon_start != []}
        class="inline-flex items-center rounded-l-md border border-r-0 border-input bg-muted px-3 text-sm text-muted-foreground"
      >
        {render_slot(@addon_start)}
      </span>
      <div class={cn([
        "flex-1",
        @addon_start != [] && "[&>*]:rounded-l-none",
        @addon_end != [] && "[&>*]:rounded-r-none"
      ])}>
        {render_slot(@inner_block)}
      </div>
      <span
        :if={@addon_end != []}
        class="inline-flex items-center rounded-r-md border border-l-0 border-input bg-muted px-3 text-sm text-muted-foreground"
      >
        {render_slot(@addon_end)}
      </span>
    </div>
    """
  end
end
