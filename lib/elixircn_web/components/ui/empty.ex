defmodule ElixircnWeb.Components.UI.Empty do
  use Phoenix.Component

  attr :class, :string, default: nil
  attr :rest, :global

  slot :icon
  slot :title, required: true
  slot :description
  slot :action

  def empty(assigns) do
    ~H"""
    <div
      class={["flex flex-col items-center justify-center py-12 text-center", @class]}
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
