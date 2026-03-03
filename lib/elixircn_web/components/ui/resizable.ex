defmodule ElixircnWeb.Components.UI.Resizable do
  @moduledoc """
  Resizable panel components powered by the `Resizable` JS hook.

  Provides `resizable_panel_group/1`, `resizable_panel/1`, and
  `resizable_handle/1` for building drag-to-resize layouts.
  """
  use Phoenix.Component
  import ElixircnWeb.Components.UI.Icon
  import ElixircnWeb.Components.UI.Utils

  attr :id, :string, required: true
  attr :direction, :string, default: "horizontal", values: ~w(horizontal vertical)
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc """
  Renders the outer group container for a resizable layout.

  Must contain `resizable_panel/1` and `resizable_handle/1` children.
  The `Resizable` JS hook is mounted on this element.
  """
  def resizable_panel_group(assigns) do
    ~H"""
    <div
      id={@id}
      data-panel-group
      data-direction={@direction}
      class={cn([
        "flex h-full w-full",
        @direction == "horizontal" && "flex-row",
        @direction == "vertical" && "flex-col",
        @class
      ])}
      phx-hook="Resizable"
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :id, :string, default: nil
  attr :default_size, :float, default: 50.0,
    doc: "initial flex percentage (0–100); supports fractional values like 33.3"
  attr :min_size, :float, default: 10.0, doc: "minimum allowed flex percentage"
  attr :max_size, :float, default: 90.0, doc: "maximum allowed flex percentage"
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc """
  Renders a single resizable panel within a `resizable_panel_group/1`.

  Use fractional values for `default_size`, `min_size`, and `max_size` when
  you need equal three-panel splits (e.g. `33.3`).
  """
  def resizable_panel(assigns) do
    ~H"""
    <div
      id={@id}
      data-panel
      data-default-size={@default_size}
      data-min-size={@min_size}
      data-max-size={@max_size}
      style={"flex: #{@default_size} 1 0%;"}
      class={cn(["overflow-hidden", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :direction, :string, default: "horizontal", values: ~w(horizontal vertical),
    doc: "must match the parent `resizable_panel_group` direction"
  attr :with_handle, :boolean, default: true
  attr :class, :any, default: nil
  attr :rest, :global

  @doc "Renders the drag handle between two resizable panels."
  def resizable_handle(assigns) do
    ~H"""
    <div
      data-resize-handle
      tabindex="0"
      role="separator"
      aria-orientation={if @direction == "horizontal", do: "vertical", else: "horizontal"}
      aria-label={if @direction == "horizontal", do: "Resize panels horizontally", else: "Resize panels vertically"}
      class={cn([
        "relative flex items-center justify-center bg-border focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring focus-visible:ring-offset-1",
        @direction == "horizontal" && "w-px after:absolute after:inset-y-0 after:left-1/2 after:w-1 after:-translate-x-1/2 cursor-col-resize",
        @direction == "vertical" && "h-px after:absolute after:inset-x-0 after:top-1/2 after:h-1 after:-translate-y-1/2 cursor-row-resize",
        @class
      ])}
      {@rest}
    >
      <div
        :if={@with_handle}
        class={cn([
          "z-10 flex items-center justify-center rounded-sm border bg-border",
          @direction == "horizontal" && "h-4 w-3",
          @direction == "vertical" && "h-3 w-4"
        ])}
      >
        <.icon name={if @direction == "horizontal", do: "grip-vertical", else: "grip-horizontal"} class="h-2.5 w-2.5" />
      </div>
    </div>
    """
  end
end
