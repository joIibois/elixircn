defmodule ElixircnWeb.Components.UI.Accordion do
  use Phoenix.Component
  import ElixircnWeb.Components.UI.Icon
  alias Phoenix.LiveView.JS

  attr :id, :string, required: true
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def accordion(assigns) do
    ~H"""
    <div id={@id} class={@class} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :value, :string, required: true
  attr :accordion_id, :string, required: true
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def accordion_item(assigns) do
    ~H"""
    <div
      id={"#{@accordion_id}-item-#{@value}"}
      class={["border-b", @class]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :value, :string, required: true
  attr :accordion_id, :string, required: true
  attr :open, :boolean, default: false
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def accordion_trigger(assigns) do
    ~H"""
    <button
      type="button"
      id={"#{@accordion_id}-trigger-#{@value}"}
      aria-expanded={to_string(@open)}
      aria-controls={"#{@accordion_id}-content-#{@value}"}
      data-state={if @open, do: "open", else: "closed"}
      phx-click={
        JS.toggle_attribute({"data-state", "open", "closed"}, to: "##{@accordion_id}-trigger-#{@value}")
        |> JS.toggle_attribute({"aria-expanded", "true", "false"}, to: "##{@accordion_id}-trigger-#{@value}")
        |> JS.toggle_attribute({"data-state", "open", "closed"}, to: "##{@accordion_id}-content-#{@value}")
        |> JS.toggle_class("rotate-180", to: "##{@accordion_id}-icon-#{@value}")
      }
      class={[
        "flex flex-1 w-full items-center justify-between py-4 text-sm font-medium transition-all hover:underline text-left",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
      <.icon
        id={"#{@accordion_id}-icon-#{@value}"}
        name="chevron-down"
        class={["h-4 w-4 shrink-0 text-muted-foreground transition-transform duration-200", @open && "rotate-180"]}
      />
    </button>
    """
  end

  attr :value, :string, required: true
  attr :accordion_id, :string, required: true
  attr :open, :boolean, default: false
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def accordion_content(assigns) do
    ~H"""
    <div
      id={"#{@accordion_id}-content-#{@value}"}
      role="region"
      aria-labelledby={"#{@accordion_id}-trigger-#{@value}"}
      data-state={if @open, do: "open", else: "closed"}
      class={[
        "grid grid-rows-[0fr] data-[state=open]:grid-rows-[1fr] transition-[grid-template-rows] duration-200 ease-in-out text-sm",
        @class
      ]}
      {@rest}
    >
      <div class="overflow-hidden">
        <div class="pb-4 pt-0">
          {render_slot(@inner_block)}
        </div>
      </div>
    </div>
    """
  end
end
