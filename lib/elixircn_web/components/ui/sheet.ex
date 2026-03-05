defmodule ElixircnWeb.Components.UI.Sheet do
  @moduledoc "Provides a slide-in sheet (drawer) component with configurable side, header, title, description, and footer."
  use Phoenix.Component
  alias Phoenix.LiveView.JS
  import ElixircnWeb.Components.UI.Utils

  @doc "Returns a JS command to show the sheet panel sliding in from the given side."
  def show_sheet(id, side \\ "right") do
    {from_class, to_class} = slide_classes(side)

    %JS{}
    |> JS.show(
      to: "##{id}-backdrop",
      transition: {"ease-out duration-300", "opacity-0", "opacity-100"},
      time: 300
    )
    |> JS.show(
      to: "##{id}-content",
      transition: {"ease-out duration-300", from_class, to_class},
      time: 300
    )
    |> JS.add_class("overflow-hidden", to: "body")
    |> JS.focus_first(to: "##{id}-content")
  end

  @doc "Returns a JS command to hide the sheet panel sliding out toward the given side."
  def hide_sheet(id, side \\ "right") do
    {from_class, to_class} = slide_classes(side)

    %JS{}
    |> JS.hide(
      to: "##{id}-content",
      transition: {"ease-in duration-200", to_class, from_class},
      time: 200
    )
    |> JS.hide(
      to: "##{id}-backdrop",
      transition: {"ease-in duration-200", "opacity-100", "opacity-0"},
      time: 200
    )
    |> JS.remove_class("overflow-hidden", to: "body")
    |> JS.pop_focus()
  end

  defp slide_classes("left"), do: {"-translate-x-full", "translate-x-0"}
  defp slide_classes("top"), do: {"-translate-y-full", "translate-y-0"}
  defp slide_classes("bottom"), do: {"translate-y-full", "translate-y-0"}
  defp slide_classes(_), do: {"translate-x-full", "translate-x-0"}

  attr :id, :string, required: true
  attr :side, :string, default: "right", values: ~w(left right top bottom)
  attr :class, :any, default: nil
  attr :rest, :global
  slot :trigger
  slot :inner_block, required: true

  @doc "Renders the sheet root with an optional trigger, backdrop, and sliding content panel."
  def sheet(assigns) do
    ~H"""
    <div id={@id} class={cn(@class)} {@rest}>
      <div :if={@trigger != []} phx-click={show_sheet(@id, @side)}>
        {render_slot(@trigger)}
      </div>
      <div
        id={"#{@id}-backdrop"}
        class="hidden fixed inset-0 z-40 bg-black/80"
        phx-click={hide_sheet(@id, @side)}
        data-escape-close
      />
      <div
        id={"#{@id}-content"}
        class={cn(["hidden fixed z-50 bg-background shadow-lg transition ease-in-out", sheet_side(@side)])}
        role="dialog"
        aria-modal="true"
        aria-labelledby={"#{@id}-title"}
        aria-describedby={"#{@id}-description"}
        phx-hook="FocusTrap"
      >
        {render_slot(@inner_block)}
      </div>
    </div>
    """
  end

  defp sheet_side("right"), do: "inset-y-0 right-0 h-full w-3/4 border-l sm:max-w-sm"
  defp sheet_side("left"), do: "inset-y-0 left-0 h-full w-3/4 border-r sm:max-w-sm"
  defp sheet_side("top"), do: "inset-x-0 top-0 border-b"
  defp sheet_side("bottom"), do: "inset-x-0 bottom-0 border-t"

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders the main content area of a sheet with full-height flex column padding."
  def sheet_content(assigns) do
    ~H"""
    <div class={cn(["flex h-full flex-col p-6", @class])} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders the header section of a sheet for grouping the title and description."
  def sheet_header(assigns) do
    ~H"""
    <div class={cn(["flex flex-col space-y-2 text-center sm:text-left", @class])} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :id, :string, default: nil
  attr :sheet_id, :string, default: nil
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders the title heading of a sheet, automatically resolving the element id."
  def sheet_title(assigns) do
    assigns = assign_new(assigns, :resolved_id, fn ->
      assigns.id || (assigns.sheet_id && "#{assigns.sheet_id}-title")
    end)

    ~H"""
    <h2 id={@resolved_id} class={cn(["text-lg font-semibold text-foreground", @class])} {@rest}>
      {render_slot(@inner_block)}
    </h2>
    """
  end

  attr :id, :string, default: nil
  attr :sheet_id, :string, default: nil
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders the description paragraph of a sheet, automatically resolving the element id."
  def sheet_description(assigns) do
    assigns = assign_new(assigns, :resolved_id, fn ->
      assigns.id || (assigns.sheet_id && "#{assigns.sheet_id}-description")
    end)

    ~H"""
    <p id={@resolved_id} class={cn(["text-sm text-muted-foreground", @class])} {@rest}>
      {render_slot(@inner_block)}
    </p>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders the footer section of a sheet with responsive action button layout."
  def sheet_footer(assigns) do
    ~H"""
    <div class={cn(["flex flex-col-reverse sm:flex-row sm:justify-end sm:space-x-2", @class])} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end
end
