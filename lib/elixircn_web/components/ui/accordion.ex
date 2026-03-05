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
    <div id={@id} class={cn(@class)} data-accordion-type={@type} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :value, :string, required: true
  attr :accordion_id, :string, required: true
  attr :open, :boolean, default: false
  attr :class, :any, default: nil
  attr :rest, :global

  slot :trigger, required: true, doc: "The clickable header content for this accordion item."
  slot :content, required: true, doc: "The collapsible body content for this accordion item."

  @doc """
  Renders an accordion item with integrated trigger and content panels.

  ## Example

      <.accordion id="faq" type="single">
        <.accordion_item accordion_id="faq" value="q1" open>
          <:trigger>Is it accessible?</:trigger>
          <:content>Yes. It adheres to the WAI-ARIA design pattern.</:content>
        </.accordion_item>
      </.accordion>
  """
  def accordion_item(assigns) do
    ~H"""
    <div
      id={"#{@accordion_id}-item-#{@value}"}
      class={cn(["border-b", @class])}
      {@rest}
    >
      <button
        type="button"
        id={"#{@accordion_id}-trigger-#{@value}"}
        aria-expanded={to_string(@open)}
        aria-controls={"#{@accordion_id}-content-#{@value}"}
        data-state={if @open, do: "open", else: "closed"}
        phx-hook="AccordionTrigger"
        class="flex flex-1 w-full items-center justify-between py-4 text-sm font-medium transition-all text-left cursor-pointer"
      >
        <span class="hover:underline">{render_slot(@trigger)}</span>
        <.icon
          id={"#{@accordion_id}-icon-#{@value}"}
          name="chevron-down"
          class={cn([
            "h-4 w-4 shrink-0 text-muted-foreground transition-transform duration-200",
            @open && "rotate-180"
          ])}
        />
      </button>
      <div
        id={"#{@accordion_id}-content-#{@value}"}
        role="region"
        aria-labelledby={"#{@accordion_id}-trigger-#{@value}"}
        data-state={if @open, do: "open", else: "closed"}
        phx-hook="AccordionContent"
        class="grid grid-rows-[0fr] data-[state=open]:grid-rows-[1fr] transition-[grid-template-rows] duration-200 ease-in-out text-sm"
      >
        <div class="overflow-hidden">
          <div class="pb-4 pt-0">
            {render_slot(@content)}
          </div>
        </div>
      </div>
    </div>
    """
  end

  # Lower-level primitives — use accordion_item with slots for the common case.

  attr :value, :string, required: true
  attr :accordion_id, :string, required: true
  attr :open, :boolean, default: false
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Low-level accordion trigger button. Prefer using `accordion_item` with a `:trigger` slot."
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

  @doc "Low-level accordion content panel. Prefer using `accordion_item` with a `:content` slot."
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
