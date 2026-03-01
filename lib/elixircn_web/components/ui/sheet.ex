defmodule ElixircnWeb.Components.UI.Sheet do
  use Phoenix.Component
  alias Phoenix.LiveView.JS

  def show_sheet(id, side \\ "right") do
    {from_class, to_class} = slide_classes(side)
    %JS{}
    |> JS.show(to: "##{id}-backdrop")
    |> JS.show(
      to: "##{id}-content",
      transition: {"ease-out duration-300", from_class, to_class},
      time: 300
    )
    |> JS.add_class("overflow-hidden", to: "body")
  end

  def hide_sheet(id, side \\ "right") do
    {from_class, to_class} = slide_classes(side)
    %JS{}
    |> JS.hide(
      to: "##{id}-content",
      transition: {"ease-in duration-200", to_class, from_class},
      time: 200
    )
    |> JS.hide(to: "##{id}-backdrop")
    |> JS.remove_class("overflow-hidden", to: "body")
  end

  defp slide_classes("left"),   do: {"-translate-x-full", "translate-x-0"}
  defp slide_classes("top"),    do: {"-translate-y-full", "translate-y-0"}
  defp slide_classes("bottom"), do: {"translate-y-full", "translate-y-0"}
  defp slide_classes(_),        do: {"translate-x-full", "translate-x-0"}

  attr :id, :string, required: true
  attr :side, :string, default: "right", values: ~w(left right top bottom)
  attr :class, :string, default: nil
  slot :trigger
  slot :inner_block, required: true

  def sheet(assigns) do
    ~H"""
    <div id={@id} class={@class}>
      <div :if={@trigger != []} phx-click={show_sheet(@id, @side)}>
        {render_slot(@trigger)}
      </div>
      <div
        id={"#{@id}-backdrop"}
        class="hidden fixed inset-0 z-50 bg-black/80"
        phx-click={hide_sheet(@id, @side)}
      />
      <div
        id={"#{@id}-content"}
        class={["hidden fixed z-50 bg-background shadow-lg transition ease-in-out", sheet_side(@side)]}
        role="dialog"
        aria-modal="true"
      >
        {render_slot(@inner_block)}
      </div>
    </div>
    """
  end

  defp sheet_side("right"),  do: "inset-y-0 right-0 h-full w-3/4 border-l sm:max-w-sm"
  defp sheet_side("left"),   do: "inset-y-0 left-0 h-full w-3/4 border-r sm:max-w-sm"
  defp sheet_side("top"),    do: "inset-x-0 top-0 border-b"
  defp sheet_side("bottom"), do: "inset-x-0 bottom-0 border-t"

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def sheet_content(assigns) do
    ~H"""
    <div class={["flex h-full flex-col p-6", @class]} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def sheet_header(assigns) do
    ~H"""
    <div class={["flex flex-col space-y-2 text-center sm:text-left", @class]} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def sheet_title(assigns) do
    ~H"""
    <h2 class={["text-lg font-semibold text-foreground", @class]} {@rest}>
      {render_slot(@inner_block)}
    </h2>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def sheet_description(assigns) do
    ~H"""
    <p class={["text-sm text-muted-foreground", @class]} {@rest}>
      {render_slot(@inner_block)}
    </p>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def sheet_footer(assigns) do
    ~H"""
    <div class={["flex flex-col-reverse sm:flex-row sm:justify-end sm:space-x-2", @class]} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end
end
