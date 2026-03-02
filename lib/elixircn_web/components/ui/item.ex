defmodule ElixircnWeb.Components.UI.Item do
  @moduledoc "Provides a flexible list item component with optional media, content, and action slots."
  use Phoenix.Component
  import ElixircnWeb.Components.UI.Utils

  attr :class, :any, default: nil
  attr :rest, :global

  slot :media
  slot :content, required: true
  slot :action

  @doc "Renders a list item layout with optional leading media and trailing action areas."
  def item(assigns) do
    ~H"""
    <div
      class={cn(["flex items-center gap-4", @class])}
      {@rest}
    >
      <div :if={@media != []} class="flex-none">
        {render_slot(@media)}
      </div>
      <div class="flex-1 min-w-0">
        {render_slot(@content)}
      </div>
      <div :if={@action != []} class="flex-none">
        {render_slot(@action)}
      </div>
    </div>
    """
  end
end
