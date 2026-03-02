defmodule ElixircnWeb.Components.UI.Empty do
  @moduledoc "Provides an empty state component for displaying placeholder content when no data is present."
  use Phoenix.Component
  import ElixircnWeb.Components.UI.Utils

  attr :class, :any, default: nil
  attr :rest, :global

  slot :icon
  slot :title, required: true
  slot :description
  slot :action

  @doc "Renders a centered empty state with optional icon, title, description, and action slots."
  def empty(assigns) do
    ~H"""
    <div
      class={cn(["flex flex-col items-center justify-center py-12 text-center", @class])}
      {@rest}
    >
      <div :if={@icon != []} class="mb-4 text-muted-foreground">
        {render_slot(@icon)}
      </div>
      <h3 class="text-lg font-semibold">{render_slot(@title)}</h3>
      <p :if={@description != []} class="mt-2 text-sm text-muted-foreground max-w-sm">
        {render_slot(@description)}
      </p>
      <div :if={@action != []} class="mt-6">
        {render_slot(@action)}
      </div>
    </div>
    """
  end
end
