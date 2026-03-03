defmodule ElixircnWeb.Components.UI.Accordion do
  @moduledoc "Provides accordion components for collapsible content sections."
  use Phoenix.Component
  import ElixircnWeb.Components.UI.Icon
  import ElixircnWeb.Components.UI.Utils

  attr :id, :string, required: true
  attr :type, :string,
    default: "multiple",
    values: ~w(single multiple),
    doc: "\"single\" allows only one item open at a time; \"multiple\" (default) allows any number"
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders the accordion container with configurable single or multiple open behavior."
  def accordion(assigns) do
    ~H"""
    <div id={@id} class={@class} data-accordion-type={@type} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :value, :string, required: true
  attr :accordion_id, :string, required: true
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders an individual accordion item with a bottom border."
  def accordion_item(assigns) do
    ~H"""
    <div
      id={"#{@accordion_id}-item-#{@value}"}
      class={cn(["border-b", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :value, :string, required: true
  attr :accordion_id, :string, required: true
  attr :open, :boolean, default: false
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders the clickable trigger button that toggles an accordion item open or closed."
  def accordion_trigger(assigns) do
    ~H"""
    <button
      type="button"
      id={"#{@accordion_id}-trigger-#{@value}"}
      aria-expanded={to_string(@open)}
      aria-controls={"#{@accordion_id}-content-#{@value}"}
      data-state={if @open, do: "open", else: "closed"}
      phx-hook="AccordionTrigger"
      class={cn([
        "flex flex-1 w-full items-center justify-between py-4 text-sm font-medium transition-all text-left cursor-pointer",
        @class
      ])}
      {@rest}
    >
      <span class="hover:underline">{render_slot(@inner_block)}</span>
      <.icon
        id={"#{@accordion_id}-icon-#{@value}"}
        name="chevron-down"
        class={cn([
          "h-4 w-4 shrink-0 text-muted-foreground transition-transform duration-200",
          @open && "rotate-180"
        ])}
      />
    </button>
    """
  end

  attr :value, :string, required: true
  attr :accordion_id, :string, required: true
  attr :open, :boolean, default: false
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders the collapsible content panel for an accordion item."
  def accordion_content(assigns) do
    ~H"""
    <div
      id={"#{@accordion_id}-content-#{@value}"}
      role="region"
      aria-labelledby={"#{@accordion_id}-trigger-#{@value}"}
      data-state={if @open, do: "open", else: "closed"}
      phx-hook="AccordionContent"
      class={cn([
        "grid grid-rows-[0fr] data-[state=open]:grid-rows-[1fr] transition-[grid-template-rows] duration-200 ease-in-out text-sm",
        @class
      ])}
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
