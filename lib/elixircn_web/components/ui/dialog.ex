defmodule ElixircnWeb.Components.UI.Dialog do
  @moduledoc "Provides dialog components for modal overlays with accessible title and description."
  use Phoenix.Component
  alias Phoenix.LiveView.JS
  import ElixircnWeb.Components.UI.Utils

  @doc "Returns a JS command that shows the dialog with the given id."
  def show_dialog(js \\ %JS{}, id) do
    js
    |> JS.show(
      to: "##{id}-backdrop",
      transition: {"ease-out duration-200", "opacity-0", "opacity-100"},
      time: 200
    )
    |> JS.show(
      to: "##{id}-content",
      transition: {"ease-out duration-200", "opacity-0 scale-95", "opacity-100 scale-100"},
      time: 200
    )
    |> JS.add_class("overflow-hidden", to: "body")
    |> JS.focus_first(to: "##{id}-content")
  end

  @doc "Returns a JS command that hides the dialog with the given id."
  def hide_dialog(js \\ %JS{}, id) do
    js
    |> JS.hide(
      to: "##{id}-content",
      transition: {"ease-in duration-150", "opacity-100 scale-100", "opacity-0 scale-95"},
      time: 150
    )
    |> JS.hide(
      to: "##{id}-backdrop",
      transition: {"ease-in duration-150", "opacity-100", "opacity-0"},
      time: 150
    )
    |> JS.remove_class("overflow-hidden", to: "body")
    |> JS.pop_focus()
  end

  attr :id, :string, required: true
  attr :class, :any, default: nil
  attr :rest, :global
  slot :trigger
  slot :inner_block, required: true

  @doc "Renders the dialog root with an optional trigger slot and dismissible modal backdrop."
  def dialog(assigns) do
    ~H"""
    <div id={@id} class={@class} {@rest}>
      <div :if={@trigger != []} phx-click={show_dialog(@id)}>
        {render_slot(@trigger)}
      </div>
      <div
        id={"#{@id}-backdrop"}
        class="hidden fixed inset-0 z-40 bg-black/80"
        phx-click={hide_dialog(@id)}
        data-escape-close
      />
      <div
        id={"#{@id}-content"}
        class="hidden fixed left-[50%] top-[50%] z-50 translate-x-[-50%] translate-y-[-50%] w-full max-w-lg"
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

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders the styled content panel inside a dialog."
  def dialog_content(assigns) do
    ~H"""
    <div
      class={cn([
        "grid w-full gap-4 rounded-lg border bg-background p-6 shadow-lg",
        @class
      ])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders the header section of a dialog."
  def dialog_header(assigns) do
    ~H"""
    <div class={cn(["flex flex-col space-y-1.5 text-center sm:text-left", @class])} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders the footer section of a dialog, typically containing action buttons."
  def dialog_footer(assigns) do
    ~H"""
    <div class={cn(["flex flex-col-reverse sm:flex-row sm:justify-end sm:space-x-2", @class])} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :id, :string, default: nil
  attr :dialog_id, :string, default: nil
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders the title heading of a dialog."
  def dialog_title(assigns) do
    assigns = assign_new(assigns, :resolved_id, fn ->
      assigns.id || (assigns.dialog_id && "#{assigns.dialog_id}-title")
    end)

    ~H"""
    <h2 id={@resolved_id} class={cn(["text-lg font-semibold leading-none tracking-tight", @class])} {@rest}>
      {render_slot(@inner_block)}
    </h2>
    """
  end

  attr :id, :string, default: nil
  attr :dialog_id, :string, default: nil
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders the description text of a dialog."
  def dialog_description(assigns) do
    assigns = assign_new(assigns, :resolved_id, fn ->
      assigns.id || (assigns.dialog_id && "#{assigns.dialog_id}-description")
    end)

    ~H"""
    <p id={@resolved_id} class={cn(["text-sm text-muted-foreground", @class])} {@rest}>
      {render_slot(@inner_block)}
    </p>
    """
  end
end
