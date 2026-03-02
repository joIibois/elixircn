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
        "fixed z-[100] flex max-h-screen w-full flex-col-reverse gap-2 p-4 sm:flex-col sm:max-w-[420px] pointer-events-none",
        @class
      ])}
      aria-live="polite"
      role="region"
      aria-label="Notifications"
    >
      <.toast_item :for={toast <- @toasts} toast={toast} />
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

  @doc "Renders an individual toast notification item with optional title, description, and dismiss button."
  def toast_item(assigns) do
    ~H"""
    <div
      id={@toast.id}
      phx-hook="Toast"
      data-auto-dismiss={@auto_dismiss}
      phx-mounted={
        JS.show(
          transition:
            {"ease-out duration-300", "opacity-0 translate-y-2", "opacity-100 translate-y-0"},
          time: 300
        )
      }
      class={cn([
        "pointer-events-auto group relative flex w-full items-center justify-between space-x-2 overflow-hidden rounded-md border p-4 pr-6 shadow-lg transition-all",
        "bg-background text-foreground",
        @toast[:variant] == "destructive" &&
          "border-destructive bg-destructive text-destructive-foreground"
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
        phx-click={
          JS.hide(
            to: "##{@toast.id}",
            transition:
              {"ease-in duration-150", "opacity-100 translate-y-0", "opacity-0 translate-y-2"},
            time: 150
          )
        }
        class="absolute right-1 top-1 rounded-md p-1 text-foreground/50 opacity-0 transition-opacity hover:text-foreground focus:opacity-100 focus:outline-none group-hover:opacity-100"
        aria-label="Dismiss"
      >
        <.icon name="x" class="h-4 w-4" />
      </button>
    </div>
    """
  end
end
