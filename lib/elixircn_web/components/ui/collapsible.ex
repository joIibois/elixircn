defmodule ElixircnWeb.Components.UI.Collapsible do
  use Phoenix.Component
  alias Phoenix.LiveView.JS

  def show_collapsible(js \\ %JS{}, id) do
    js
    |> JS.show(
      to: "##{id}-content",
      transition: {"ease-out duration-200", "opacity-0 -translate-y-1", "opacity-100 translate-y-0"},
      time: 200
    )
    |> JS.set_attribute({"data-state", "open"}, to: "##{id}")
  end

  def hide_collapsible(js \\ %JS{}, id) do
    js
    |> JS.hide(
      to: "##{id}-content",
      transition: {"ease-in duration-150", "opacity-100 translate-y-0", "opacity-0 -translate-y-1"},
      time: 150
    )
    |> JS.set_attribute({"data-state", "closed"}, to: "##{id}")
  end

  attr :id, :string, required: true
  attr :open, :boolean, default: false
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def collapsible(assigns) do
    ~H"""
    <div
      id={@id}
      data-state={if @open, do: "open", else: "closed"}
      class={@class}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :collapsible_id, :string, required: true
  attr :open, :boolean, default: false
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def collapsible_trigger(assigns) do
    ~H"""
    <div
      phx-click={
        if @open,
          do: hide_collapsible(@collapsible_id),
          else: show_collapsible(@collapsible_id)
      }
      class={["cursor-pointer", @class]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :collapsible_id, :string, required: true
  attr :open, :boolean, default: false
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def collapsible_content(assigns) do
    ~H"""
    <div
      id={"#{@collapsible_id}-content"}
      class={[!@open && "hidden", @class]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end
end
