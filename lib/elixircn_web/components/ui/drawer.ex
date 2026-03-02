defmodule ElixircnWeb.Components.UI.Drawer do
  @moduledoc """
  Drawer (slide-in panel) component that can open from any edge of the screen.

  Provides `show_drawer/2`, `hide_drawer/2`, `drawer/1`, `drawer_header/1`,
  `drawer_title/1`, `drawer_description/1`, `drawer_content/1`, and
  `drawer_footer/1`.
  """
  use Phoenix.Component
  alias Phoenix.LiveView.JS
  import ElixircnWeb.Components.UI.Utils

  @doc "Returns a `%JS{}` command chain that shows the drawer with the given `id`."
  def show_drawer(js \\ %JS{}, id, side \\ "bottom") do
    {enter_from, enter_to} = slide_transition(side)

    js
    |> JS.show(to: "##{id}-backdrop")
    |> JS.show(
      to: "##{id}-content",
      transition: {"ease-out duration-300", enter_from, enter_to},
      time: 300
    )
    |> JS.add_class("overflow-hidden", to: "body")
    |> JS.focus_first(to: "##{id}-content")
  end

  @doc "Returns a `%JS{}` command chain that hides the drawer with the given `id`."
  def hide_drawer(js \\ %JS{}, id, side \\ "bottom") do
    {enter_from, enter_to} = slide_transition(side)

    js
    |> JS.hide(
      to: "##{id}-content",
      transition: {"ease-in duration-200", enter_to, enter_from},
      time: 200
    )
    |> JS.hide(to: "##{id}-backdrop")
    |> JS.remove_class("overflow-hidden", to: "body")
    |> JS.pop_focus()
  end

  defp slide_transition("bottom"), do: {"translate-y-full", "translate-y-0"}
  defp slide_transition("top"),    do: {"-translate-y-full", "translate-y-0"}
  defp slide_transition("left"),   do: {"-translate-x-full", "translate-x-0"}
  defp slide_transition("right"),  do: {"translate-x-full", "translate-x-0"}

  defp side_classes("bottom"),
    do: "fixed inset-x-0 bottom-0 mt-24 flex h-auto flex-col rounded-t-[10px] border"
  defp side_classes("top"),
    do: "fixed inset-x-0 top-0 mb-24 flex h-auto flex-col rounded-b-[10px] border"
  defp side_classes("left"),
    do: "fixed inset-y-0 left-0 h-full w-3/4 max-w-sm flex flex-col border-r"
  defp side_classes("right"),
    do: "fixed inset-y-0 right-0 h-full w-3/4 max-w-sm flex flex-col border-l"

  attr :id, :string, required: true
  attr :side, :string, default: "bottom", values: ~w(bottom top left right),
    doc: "which edge the drawer slides in from"
  attr :class, :any, default: nil
  attr :rest, :global
  slot :trigger
  slot :inner_block, required: true

  @doc """
  Renders a drawer panel that slides in from a screen edge.

  ## Examples

      <.drawer id="settings-drawer" side="right">
        <:trigger><.button>Open</.button></:trigger>
        <.drawer_header>...</.drawer_header>
        <.drawer_content>...</.drawer_content>
      </.drawer>
  """
  def drawer(assigns) do
    ~H"""
    <div id={@id} class={@class} {@rest}>
      <div :if={@trigger != []} phx-click={show_drawer(@id, @side)}>
        {render_slot(@trigger)}
      </div>
      <div
        id={"#{@id}-backdrop"}
        class="hidden fixed inset-0 z-40 bg-black/80"
        phx-click={hide_drawer(@id, @side)}
        data-escape-close
      />
      <div
        id={"#{@id}-content"}
        class={cn(["hidden z-50 bg-background", side_classes(@side)])}
        role="dialog"
        aria-modal="true"
        phx-hook="FocusTrap"
      >
        <div :if={@side == "bottom" || @side == "top"} class="mx-auto w-full max-w-sm">
          <div
            :if={@side == "bottom"}
            class="mx-auto mt-4 h-1 w-[100px] rounded-full bg-muted-foreground/30"
          />
          {render_slot(@inner_block)}
          <div
            :if={@side == "top"}
            class="mx-auto mb-4 h-1 w-[100px] rounded-full bg-muted-foreground/30"
          />
        </div>
        <div :if={@side == "left" || @side == "right"} class="flex h-full flex-col">
          {render_slot(@inner_block)}
        </div>
      </div>
    </div>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders the header section of a drawer."
  def drawer_header(assigns) do
    ~H"""
    <div class={cn(["grid gap-1.5 p-4 text-center sm:text-left", @class])} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders the title inside a drawer header."
  def drawer_title(assigns) do
    ~H"""
    <h2 class={cn(["text-lg font-semibold leading-none tracking-tight", @class])} {@rest}>
      {render_slot(@inner_block)}
    </h2>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders a muted description inside a drawer header."
  def drawer_description(assigns) do
    ~H"""
    <p class={cn(["text-sm text-muted-foreground", @class])} {@rest}>
      {render_slot(@inner_block)}
    </p>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders the scrollable body of a drawer."
  def drawer_content(assigns) do
    ~H"""
    <div class={cn(["p-4", @class])} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders the footer section of a drawer, pinned to the bottom."
  def drawer_footer(assigns) do
    ~H"""
    <div class={cn(["mt-auto flex flex-col gap-2 p-4", @class])} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end
end
