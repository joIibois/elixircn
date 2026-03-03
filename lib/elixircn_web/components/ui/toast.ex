defmodule ElixircnWeb.Components.UI.Toast do
  @moduledoc "Provides toast notification components for displaying transient status messages."
  use Phoenix.Component
  import ElixircnWeb.Components.UI.Icon
  import ElixircnWeb.Components.UI.Utils
  alias Phoenix.LiveView.JS

  attr :toasts, :list, default: []

  attr :position, :string,
    default: "bottom-right",
    values: ~w(top-left top-center top-right bottom-left bottom-center bottom-right)

  attr :class, :any, default: nil

  @doc "Renders the toast viewport container that positions and displays a list of toast notifications."
  def toast_viewport(assigns) do
    ~H"""
    <div
      class={cn([
        toast_position(@position),
        "fixed z-[100] flex flex-col gap-2 w-full sm:max-w-[420px] pointer-events-none p-4",
        @class
      ])}
      aria-live="polite"
      role="region"
      aria-label="Notifications"
    >
      <.toast_item :for={toast <- Enum.reverse(@toasts)} toast={toast} />
    </div>
    """
  end

  defp toast_position("top-left"), do: "top-0 left-0"
  defp toast_position("top-center"), do: "top-0 left-1/2 -translate-x-1/2"
  defp toast_position("top-right"), do: "top-0 right-0"
  defp toast_position("bottom-left"), do: "bottom-0 left-0"
  defp toast_position("bottom-center"), do: "bottom-0 left-1/2 -translate-x-1/2"
  defp toast_position("bottom-right"), do: "bottom-0 right-0"

  attr :toast, :map, required: true
  attr :auto_dismiss, :integer, default: 5000, doc: "milliseconds before the toast auto-dismisses; set to 0 to disable"
  attr :on_dismiss, :string, default: "dismiss_toast", doc: "server event name to push when a toast is dismissed"

  @doc "Renders an individual toast notification item with optional title, description, and dismiss button."
  def toast_item(assigns) do
    ~H"""
    <div
      id={@toast.id}
      phx-hook="ToastAutoDismiss"
      data-auto-dismiss={@auto_dismiss}
      data-on-dismiss={@on_dismiss}
      data-toast-id={@toast.id}
      class={cn([
        "pointer-events-auto group relative flex w-full items-center justify-between space-x-2 overflow-hidden rounded-md border p-4 pr-8 shadow-lg",
        "bg-background text-foreground",
        @toast[:class]
      ])}
    >
      <div class="flex flex-col gap-1">
        <p :if={@toast[:title]} class="text-sm font-semibold leading-none tracking-tight">
          {@toast.title}
        </p>
        <p :if={@toast[:description]} class="text-sm opacity-90">
          {@toast.description}
        </p>
      </div>
      <button
        phx-click={JS.push(@on_dismiss, value: %{id: @toast.id})}
        class="absolute right-1 top-1 rounded-md p-1 text-current opacity-0 transition-opacity hover:opacity-100 focus:opacity-100 focus:outline-none group-hover:opacity-100"
        aria-label="Dismiss"
      >
        <.icon name="x" class="h-4 w-4" />
      </button>
    </div>
    """
  end
end
