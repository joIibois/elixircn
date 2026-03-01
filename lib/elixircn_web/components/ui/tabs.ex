defmodule ElixircnWeb.Components.UI.Tabs do
  use Phoenix.Component
  alias Phoenix.LiveView.JS

  attr :id, :string, required: true
  attr :default_value, :string, default: nil
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def tabs(assigns) do
    ~H"""
    <div id={@id} class={["w-full", @class]} data-tabs {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :tabs_id, :string, required: true
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def tabs_list(assigns) do
    ~H"""
    <div
      class={[
        "inline-flex h-9 items-center justify-center rounded-lg bg-muted p-1 text-muted-foreground",
        @class
      ]}
      role="tablist"
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :tabs_id, :string, required: true
  attr :value, :string, required: true
  attr :active, :boolean, default: false
  attr :disabled, :boolean, default: false
  attr :class, :string, default: nil
  attr :rest, :global

  slot :inner_block, required: true

  def tabs_trigger(assigns) do
    ~H"""
    <button
      type="button"
      role="tab"
      id={"#{@tabs_id}-tab-#{@value}"}
      aria-selected={to_string(@active)}
      aria-controls={"#{@tabs_id}-panel-#{@value}"}
      disabled={@disabled}
      data-state={if @active, do: "active", else: "inactive"}
      phx-click={
        JS.remove_class("bg-background text-foreground shadow", to: "##{@tabs_id} [role=tab][data-state=active]")
        |> JS.set_attribute({"aria-selected", "false"}, to: "##{@tabs_id} [role=tab][data-state=active]")
        |> JS.set_attribute({"data-state", "inactive"}, to: "##{@tabs_id} [role=tab][data-state=active]")
        |> JS.hide(to: "##{@tabs_id} [role=tabpanel]")
        |> JS.set_attribute({"data-state", "active"}, to: "##{@tabs_id}-tab-#{@value}")
        |> JS.set_attribute({"aria-selected", "true"}, to: "##{@tabs_id}-tab-#{@value}")
        |> JS.add_class("bg-background text-foreground shadow", to: "##{@tabs_id}-tab-#{@value}")
        |> JS.show(to: "##{@tabs_id}-panel-#{@value}")
      }
      class={[
        "inline-flex items-center justify-center whitespace-nowrap rounded-md px-3 py-1 text-sm font-medium ring-offset-background transition-all focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50",
        @active && "bg-background text-foreground shadow",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </button>
    """
  end

  attr :tabs_id, :string, required: true
  attr :value, :string, required: true
  attr :active, :boolean, default: false
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def tabs_content(assigns) do
    ~H"""
    <div
      id={"#{@tabs_id}-panel-#{@value}"}
      role="tabpanel"
      aria-labelledby={"#{@tabs_id}-tab-#{@value}"}
      data-state={if @active, do: "active", else: "inactive"}
      class={[
        "mt-2 ring-offset-background focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2",
        !@active && "hidden",
        @class
      ]}
      tabindex="0"
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end
end
