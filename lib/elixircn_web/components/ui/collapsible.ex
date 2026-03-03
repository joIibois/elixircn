defmodule ElixircnWeb.Components.UI.Collapsible do
  @moduledoc "Provides collapsible components for toggling visibility of content sections."
  use Phoenix.Component
  import ElixircnWeb.Components.UI.Utils
  alias Phoenix.LiveView.JS

  @doc "Returns a JS command that shows the collapsible content with a slide-down transition."
  def show_collapsible(js \\ %JS{}, id) do
    js
    |> JS.show(
      to: "##{id}-content",
      transition:
        {"ease-out duration-200", "opacity-0 -translate-y-1", "opacity-100 translate-y-0"},
      time: 200
    )
    |> JS.set_attribute({"data-state", "open"}, to: "##{id}")
  end

  @doc "Returns a JS command that hides the collapsible content with a slide-up transition."
  def hide_collapsible(js \\ %JS{}, id) do
    js
    |> JS.hide(
      to: "##{id}-content",
      transition:
        {"ease-in duration-150", "opacity-100 translate-y-0", "opacity-0 -translate-y-1"},
      time: 150
    )
    |> JS.set_attribute({"data-state", "closed"}, to: "##{id}")
  end

  attr :id, :string, required: true
  attr :open, :boolean, default: false
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders the collapsible root container with an open/closed data-state attribute."
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
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders the clickable trigger that toggles the collapsible content."
  def collapsible_trigger(assigns) do
    ~H"""
    <div
      phx-click={
        JS.toggle_attribute({"data-state", "open", "closed"}, to: "##{@collapsible_id}")
        |> JS.toggle(
          to: "##{@collapsible_id}-content",
          in: {"ease-out duration-200", "opacity-0 -translate-y-1", "opacity-100 translate-y-0"},
          out: {"ease-in duration-150", "opacity-100 translate-y-0", "opacity-0 -translate-y-1"},
          time: 200
        )
      }
      class={cn(["cursor-pointer", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :collapsible_id, :string, required: true
  attr :open, :boolean, default: false
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders the content panel that is shown or hidden by the collapsible trigger."
  def collapsible_content(assigns) do
    ~H"""
    <div
      id={"#{@collapsible_id}-content"}
      phx-hook="CollapsibleContent"
      class={cn([!@open && "hidden", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end
end
