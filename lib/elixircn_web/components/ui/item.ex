defmodule ElixircnWeb.Components.UI.Item do
  use Phoenix.Component

  attr :class, :string, default: nil
  attr :rest, :global

  slot :media
  slot :content, required: true
  slot :action

  def item(assigns) do
    ~H"""
    <div
      class={["flex items-center gap-4", @class]}
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
