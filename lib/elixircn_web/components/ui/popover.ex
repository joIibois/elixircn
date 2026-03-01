defmodule ElixircnWeb.Components.UI.Popover do
  use Phoenix.Component
  alias Phoenix.LiveView.JS

  def show_popover(id) do
    %JS{}
    |> JS.show(to: "##{id}-backdrop")
    |> JS.show(
      to: "##{id}-content",
      transition: {"ease-out duration-150", "opacity-0 scale-95", "opacity-100 scale-100"},
      time: 150
    )
  end

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
  attr :class, :string, default: nil
  slot :trigger, required: true
  slot :inner_block, required: true

  def popover(assigns) do
    ~H"""
    <div id={@id} class={["relative inline-block", @class]}>
      <div
        id={"#{@id}-backdrop"}
        class="hidden fixed inset-0 z-40"
        phx-click={hide_popover(@id)}
        data-escape-close
      />
      <div phx-click={JS.toggle(to: "##{@id}-content",
        in:  {"ease-out duration-150", "opacity-0 scale-95", "opacity-100 scale-100"},
        out: {"ease-in duration-100", "opacity-100 scale-100", "opacity-0 scale-95"},
        time: 150
      ) |> JS.toggle(to: "##{@id}-backdrop")}>
        {render_slot(@trigger)}
      </div>
      <div
        id={"#{@id}-content"}
        class="hidden absolute z-50 left-0 top-full mt-1 w-72 rounded-md border bg-popover p-4 text-popover-foreground shadow-md outline-none"
        role="dialog"
      >
        {render_slot(@inner_block)}
      </div>
    </div>
    """
  end
end
