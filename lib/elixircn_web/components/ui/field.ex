defmodule ElixircnWeb.Components.UI.Field do
  use Phoenix.Component

  attr :id, :string, default: nil
  attr :label, :string, default: nil
  attr :description, :string, default: nil
  attr :errors, :list, default: []
  attr :class, :string, default: nil
  attr :rest, :global

  slot :inner_block, required: true

  def field(assigns) do
    ~H"""
    <div class={["space-y-2", @class]} {@rest}>
      <label :if={@label} for={@id} class="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70">
        {@label}
      </label>
      {render_slot(@inner_block)}
      <p :if={@description && @errors == []} class="text-[0.8rem] text-muted-foreground">
        {@description}
      </p>
      <p :for={error <- @errors} class="text-[0.8rem] font-medium text-destructive">
        {error}
      </p>
    </div>
    """
  end
end
