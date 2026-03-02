defmodule ElixircnWeb.Components.UI.Popover do
  @moduledoc "Provides a popover component with configurable side and alignment positioning."
  use Phoenix.Component
  alias Phoenix.LiveView.JS
  import ElixircnWeb.Components.UI.Utils

  @doc "Returns a JS command to show the popover with the given id."
  def show_popover(id) do
    %JS{}
    |> JS.show(to: "##{id}-backdrop")
    |> JS.show(
      to: "##{id}-content",
      transition: {"ease-out duration-150", "opacity-0 scale-95", "opacity-100 scale-100"},
      time: 150
    )
  end

  @doc "Returns a JS command to hide the popover with the given id."
  def hide_popover(id) do
    %JS{}
    |> JS.hide(to: "##{id}-backdrop")
    |> JS.hide(
      to: "##{id}-content",
      transition: {"ease-in duration-100", "opacity-100 scale-100", "opacity-0 scale-95"},
      time: 100
    )
  end

  attr :id, :string, required: true
  attr :side, :string, default: "bottom", values: ~w(top bottom left right)
  attr :align, :string, default: "start", values: ~w(start center end)
  attr :class, :any, default: nil
  attr :rest, :global
  slot :trigger, required: true
  slot :inner_block, required: true

  @doc "Renders a popover container with a trigger slot and a positioned content panel."
  def popover(assigns) do
    ~H"""
    <div id={@id} class={cn(["relative inline-block", @class])} {@rest}>
      <div
        id={"#{@id}-backdrop"}
        class="hidden fixed inset-0 z-40"
        phx-click={hide_popover(@id)}
        data-escape-close
      />
      <div
        id={"#{@id}-trigger"}
        aria-expanded="false"
        phx-click={
          JS.toggle(
            to: "##{@id}-content",
            in: {"ease-out duration-150", "opacity-0 scale-95", "opacity-100 scale-100"},
            out: {"ease-in duration-100", "opacity-100 scale-100", "opacity-0 scale-95"},
            time: 150
          )
          |> JS.toggle(to: "##{@id}-backdrop")
          |> JS.toggle_attribute({"aria-expanded", "true", "false"}, to: "##{@id}-trigger")
        }
      >
        {render_slot(@trigger)}
      </div>
      <div
        id={"#{@id}-content"}
        class={cn([
          "hidden absolute z-50 w-72 rounded-md border bg-popover p-4 text-popover-foreground shadow-md outline-none",
          popover_position(@side, @align)
        ])}
        role="dialog"
      >
        {render_slot(@inner_block)}
      </div>
    </div>
    """
  end

  defp popover_position("bottom", "start"), do: "top-full left-0 mt-1"
  defp popover_position("bottom", "center"), do: "top-full left-1/2 -translate-x-1/2 mt-1"
  defp popover_position("bottom", "end"), do: "top-full right-0 mt-1"
  defp popover_position("top", "start"), do: "bottom-full left-0 mb-1"
  defp popover_position("top", "center"), do: "bottom-full left-1/2 -translate-x-1/2 mb-1"
  defp popover_position("top", "end"), do: "bottom-full right-0 mb-1"
  defp popover_position("left", "start"), do: "right-full top-0 mr-1"
  defp popover_position("left", "center"), do: "right-full top-1/2 -translate-y-1/2 mr-1"
  defp popover_position("left", "end"), do: "right-full bottom-0 mr-1"
  defp popover_position("right", "start"), do: "left-full top-0 ml-1"
  defp popover_position("right", "center"), do: "left-full top-1/2 -translate-y-1/2 ml-1"
  defp popover_position("right", "end"), do: "left-full bottom-0 ml-1"
end
