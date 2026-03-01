defmodule ElixircnWeb.Components.UI.InputGroup do
  use Phoenix.Component

  attr :class, :string, default: nil
  attr :rest, :global

  slot :addon_start
  slot :addon_end
  slot :inner_block, required: true

  def input_group(assigns) do
    ~H"""
    <div class={["flex items-stretch overflow-hidden rounded-md shadow-sm [&_input]:shadow-none", @class]} {@rest}>
      <span
        :if={@addon_start != []}
        class="inline-flex items-center rounded-l-md border border-r-0 border-input bg-muted px-3 text-sm text-muted-foreground"
      >
        {render_slot(@addon_start)}
      </span>
      <div class={[
        "flex-1",
        @addon_start != [] && "[&>*]:rounded-l-none",
        @addon_end != [] && "[&>*]:rounded-r-none"
      ]}>
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
