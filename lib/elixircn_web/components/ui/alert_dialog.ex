defmodule ElixircnWeb.Components.UI.AlertDialog do
  @moduledoc "Provides alert dialog components for modal confirmations that require explicit user action."
  use Phoenix.Component
  alias Phoenix.LiveView.JS
  import ElixircnWeb.Components.UI.Utils

  @doc "Returns a JS command that shows the alert dialog with the given id."
  def show_alert_dialog(js \\ %JS{}, id) do
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

  @doc "Returns a JS command that hides the alert dialog with the given id."
  def hide_alert_dialog(js \\ %JS{}, id) do
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

  @doc "Renders the alert dialog wrapper with an optional trigger slot and modal overlay."
  def alert_dialog(assigns) do
    ~H"""
    <div id={@id} class={cn(@class)} {@rest}>
      <div :if={@trigger != []} phx-click={show_alert_dialog(@id)}>
        {render_slot(@trigger)}
      </div>
      <%!-- Alert dialogs must not be dismissible by clicking the backdrop or pressing
           Escape. The user must explicitly choose an action (confirm/cancel). --%>
      <div
        id={"#{@id}-backdrop"}
        class="hidden fixed inset-0 z-40 bg-black/80"
      />
      <div
        id={"#{@id}-content"}
        class="hidden fixed left-[50%] top-[50%] z-50 translate-x-[-50%] translate-y-[-50%] w-full max-w-lg"
        role="alertdialog"
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

  @doc "Renders the styled content panel inside an alert dialog."
  def alert_dialog_content(assigns) do
    ~H"""
    <div class={cn(["grid w-full gap-4 rounded-lg border bg-background p-6 shadow-lg", @class])} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders the header section of an alert dialog."
  def alert_dialog_header(assigns) do
    ~H"""
    <div class={cn(["flex flex-col space-y-2 text-center sm:text-left", @class])} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders the footer section of an alert dialog, typically containing action buttons."
  def alert_dialog_footer(assigns) do
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

  @doc "Renders the title heading of an alert dialog."
  def alert_dialog_title(assigns) do
    assigns = assign_new(assigns, :resolved_id, fn ->
      assigns.id || (assigns.dialog_id && "#{assigns.dialog_id}-title")
    end)

    ~H"""
    <h2 id={@resolved_id} class={cn(["text-lg font-semibold", @class])} {@rest}>
      {render_slot(@inner_block)}
    </h2>
    """
  end

  attr :id, :string, default: nil
  attr :dialog_id, :string, default: nil
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders the description text of an alert dialog."
  def alert_dialog_description(assigns) do
    assigns = assign_new(assigns, :resolved_id, fn ->
      assigns.id || (assigns.dialog_id && "#{assigns.dialog_id}-description")
    end)

    ~H"""
    <p id={@resolved_id} class={cn(["text-sm text-muted-foreground", @class])} {@rest}>
      {render_slot(@inner_block)}
    </p>
    """
  end

  attr :id, :string, required: true
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders the cancel button that dismisses the alert dialog."
  def alert_dialog_cancel(assigns) do
    ~H"""
    <button
      type="button"
      phx-click={hide_alert_dialog(@id)}
      class={cn([
        "inline-flex items-center justify-center rounded-md border border-input bg-background px-4 py-2 text-sm font-medium shadow-sm hover:bg-accent hover:text-accent-foreground focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring",
        @class
      ])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </button>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global, include: ~w(form name value data-confirm)
  slot :inner_block, required: true

  @doc "Renders the primary action button that confirms the alert dialog action."
  def alert_dialog_action(assigns) do
    ~H"""
    <button
      type="button"
      class={cn([
        "inline-flex items-center justify-center rounded-md bg-primary px-4 py-2 text-sm font-medium text-primary-foreground shadow hover:bg-primary/90 focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring",
        @class
      ])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </button>
    """
  end
end
