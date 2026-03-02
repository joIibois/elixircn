defmodule ElixircnWeb.Components.UI.Tabs do
  @moduledoc "Provides tabbed interface components for organizing content into selectable panels."
  use Phoenix.Component
  import ElixircnWeb.Components.UI.Utils
  alias Phoenix.LiveView.JS

  attr :id, :string, required: true
  attr :default_value, :string, default: nil
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders the root tabs container with a unique id and optional default selected value."
  def tabs(assigns) do
    ~H"""
    <div id={@id} class={cn(["w-full", @class])} data-tabs {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :tabs_id, :string, required: true
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders the tab list container that holds the tab trigger buttons."
  def tabs_list(assigns) do
    ~H"""
    <div
      id={"#{@tabs_id}-tablist"}
      class={cn([
        "inline-flex h-9 items-center justify-center rounded-lg bg-muted p-1 text-muted-foreground",
        @class
      ])}
      role="tablist"
      phx-hook="Tabs"
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
  attr :class, :any, default: nil
  attr :rest, :global

  slot :inner_block, required: true

  @doc "Renders a tab trigger button that activates its associated content panel when clicked."
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
        JS.remove_class("bg-background text-foreground shadow",
          to: "##{@tabs_id} [role=tab][data-state=active]"
        )
        |> JS.set_attribute({"aria-selected", "false"},
          to: "##{@tabs_id} [role=tab][data-state=active]"
        )
        |> JS.set_attribute({"data-state", "inactive"},
          to: "##{@tabs_id} [role=tab][data-state=active]"
        )
        |> JS.set_attribute({"hidden", "true"},
          to: "##{@tabs_id} [role=tabpanel]:not([hidden])"
        )
        |> JS.set_attribute({"data-state", "inactive"},
          to: "##{@tabs_id} [role=tabpanel][data-state=active]"
        )
        |> JS.set_attribute({"data-state", "active"}, to: "##{@tabs_id}-tab-#{@value}")
        |> JS.set_attribute({"aria-selected", "true"}, to: "##{@tabs_id}-tab-#{@value}")
        |> JS.add_class("bg-background text-foreground shadow", to: "##{@tabs_id}-tab-#{@value}")
        |> JS.remove_attribute("hidden", to: "##{@tabs_id}-panel-#{@value}")
        |> JS.set_attribute({"data-state", "active"}, to: "##{@tabs_id}-panel-#{@value}")
      }
      class={cn([
        "inline-flex items-center justify-center whitespace-nowrap rounded-md px-3 py-1 text-sm font-medium ring-offset-background transition-all focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50",
        @active && "bg-background text-foreground shadow",
        @class
      ])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </button>
    """
  end

  attr :tabs_id, :string, required: true
  attr :value, :string, required: true
  attr :active, :boolean, default: false
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders a tab content panel associated with a specific tab trigger value."
  def tabs_content(assigns) do
    ~H"""
    <div
      id={"#{@tabs_id}-panel-#{@value}"}
      role="tabpanel"
      aria-labelledby={"#{@tabs_id}-tab-#{@value}"}
      data-state={if @active, do: "active", else: "inactive"}
      hidden={!@active}
      class={cn([
        "mt-2 ring-offset-background focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2",
        @class
      ])}
      tabindex="0"
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end
end
