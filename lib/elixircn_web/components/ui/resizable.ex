defmodule ElixircnWeb.Components.UI.Resizable do
  use Phoenix.Component

  attr :id, :string, required: true
  attr :direction, :string, default: "horizontal", values: ~w(horizontal vertical)
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def resizable_panel_group(assigns) do
    ~H"""
    <div
      id={@id}
      data-panel-group
      data-direction={@direction}
      class={[
        "flex h-full w-full",
        @direction == "horizontal" && "flex-row",
        @direction == "vertical" && "flex-col",
        @class
      ]}
      phx-hook="Resizable"
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :id, :string, default: nil
  attr :default_size, :integer, default: 50
  attr :min_size, :integer, default: 10
  attr :max_size, :integer, default: 90
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def resizable_panel(assigns) do
    ~H"""
    <div
      id={@id}
      data-panel
      data-default-size={@default_size}
      data-min-size={@min_size}
      data-max-size={@max_size}
      style={"flex: #{@default_size} 1 0%;"}
      class={["overflow-hidden", @class]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :with_handle, :boolean, default: true
  attr :class, :string, default: nil
  attr :rest, :global

  def resizable_handle(assigns) do
    ~H"""
    <div
      data-resize-handle
      class={[
        "relative flex w-px items-center justify-center bg-border after:absolute after:inset-y-0 after:left-1/2 after:w-1 after:-translate-x-1/2 focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring focus-visible:ring-offset-1 cursor-col-resize",
        @class
      ]}
      {@rest}
    >
      <div :if={@with_handle} class="z-10 flex h-4 w-3 items-center justify-center rounded-sm border bg-border">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="h-2.5 w-2.5"><circle cx="9" cy="12" r="1"/><circle cx="9" cy="5" r="1"/><circle cx="9" cy="19" r="1"/><circle cx="15" cy="12" r="1"/><circle cx="15" cy="5" r="1"/><circle cx="15" cy="19" r="1"/></svg>
      </div>
    </div>
    """
  end
end
