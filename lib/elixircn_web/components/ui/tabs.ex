defmodule ElixircnWeb.Components.UI.Tabs do
  @moduledoc "Provides tabbed interface components for organizing content into selectable panels."
  use Phoenix.Component
  import ElixircnWeb.Components.UI.Utils
  alias Phoenix.LiveView.JS

  attr :id, :string, required: true
  attr :default_value, :string, default: nil
  attr :class, :any, default: nil
  attr :rest, :global

  slot :tab, doc: "A tab item. Use this for the standard compound API." do
    attr :value, :string, required: true
    attr :label, :string, required: true, doc: "Text shown in the tab trigger button."
    attr :active, :boolean
    attr :disabled, :boolean
  end

  slot :inner_block,
    doc: "Raw inner content. Use with tabs_list/tabs_trigger/tabs_content for full layout control."

  @doc """
  Renders a tabbed interface.

  ## Compound API (recommended)

  Pass `:tab` slots with a `label` attr and body content. No `tabs_id` repetition needed.

      <.tabs id="settings" default_value="account">
        <:tab value="account" label="Account" active>
          Account content here...
        </:tab>
        <:tab value="password" label="Password">
          Password content here...
        </:tab>
      </.tabs>

  ## Low-level API

  For custom trigger markup, use `tabs_list`, `tabs_trigger`, and `tabs_content` inside
  the default slot:

      <.tabs id="settings">
        <.tabs_list tabs_id="settings">
          <.tabs_trigger tabs_id="settings" value="account" active>Account</.tabs_trigger>
        </.tabs_list>
        <.tabs_content tabs_id="settings" value="account" active>
          ...
        </.tabs_content>
      </.tabs>
  """
  def tabs(%{tab: [_ | _]} = assigns) do
    ~H"""
    <div id={@id} class={cn(["w-full", @class])} data-tabs data-default-tab={@default_value} {@rest}>
      <div
        id={"#{@id}-tablist"}
        class="inline-flex h-9 items-center justify-center rounded-lg bg-muted p-1 text-muted-foreground"
        role="tablist"
        phx-hook="Tabs"
      >
        <%= for tab <- @tab do %>
          <button
            type="button"
            role="tab"
            id={"#{@id}-tab-#{tab.value}"}
            aria-selected={to_string(Map.get(tab, :active, false))}
            aria-controls={"#{@id}-panel-#{tab.value}"}
            disabled={Map.get(tab, :disabled, false)}
            data-state={if Map.get(tab, :active, false), do: "active", else: "inactive"}
            phx-click={tab_click_js(@id, tab.value)}
            class={cn([
              "inline-flex items-center justify-center whitespace-nowrap rounded-md px-3 py-1 text-sm font-medium ring-offset-background transition-all focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 hover:text-foreground",
              Map.get(tab, :active, false) && "bg-background text-foreground shadow"
            ])}
          >
            {tab.label}
          </button>
        <% end %>
      </div>
      <%= for tab <- @tab do %>
        <div
          id={"#{@id}-panel-#{tab.value}"}
          role="tabpanel"
          aria-labelledby={"#{@id}-tab-#{tab.value}"}
          data-state={if Map.get(tab, :active, false), do: "active", else: "inactive"}
          hidden={!Map.get(tab, :active, false)}
          class="mt-2 ring-offset-background focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2"
          tabindex="0"
        >
          {render_slot(tab)}
        </div>
      <% end %>
    </div>
    """
  end

  def tabs(assigns) do
    ~H"""
    <div id={@id} class={cn(["w-full", @class])} data-tabs data-default-tab={@default_value} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  # Low-level primitives — use tabs/1 with :tab slots for the common case.

  attr :tabs_id, :string, required: true
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Low-level tab list container. Prefer using `tabs` with `:tab` slots."
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

  @doc "Low-level tab trigger button. Prefer using `tabs` with `:tab` slots."
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
      phx-click={tab_click_js(@tabs_id, @value)}
      class={cn([
        "inline-flex items-center justify-center whitespace-nowrap rounded-md px-3 py-1 text-sm font-medium ring-offset-background transition-all focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 hover:text-foreground",
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

  @doc "Low-level tab content panel. Prefer using `tabs` with `:tab` slots."
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

  defp tab_click_js(tabs_id, value) do
    JS.remove_class("bg-background text-foreground shadow",
      to: "##{tabs_id} [role=tab][data-state=active]"
    )
    |> JS.set_attribute({"aria-selected", "false"},
      to: "##{tabs_id} [role=tab][data-state=active]"
    )
    |> JS.set_attribute({"data-state", "inactive"},
      to: "##{tabs_id} [role=tab][data-state=active]"
    )
    |> JS.set_attribute({"hidden", "true"},
      to: "##{tabs_id} [role=tabpanel]:not([hidden])"
    )
    |> JS.set_attribute({"data-state", "inactive"},
      to: "##{tabs_id} [role=tabpanel][data-state=active]"
    )
    |> JS.set_attribute({"data-state", "active"}, to: "##{tabs_id}-tab-#{value}")
    |> JS.set_attribute({"aria-selected", "true"}, to: "##{tabs_id}-tab-#{value}")
    |> JS.add_class("bg-background text-foreground shadow", to: "##{tabs_id}-tab-#{value}")
    |> JS.remove_attribute("hidden", to: "##{tabs_id}-panel-#{value}")
    |> JS.set_attribute({"data-state", "active"}, to: "##{tabs_id}-panel-#{value}")
  end
end
