defmodule ElixircnWeb.Components.UI.Progress do
  @moduledoc """
  Progress bar component with accessible ARIA attributes.
  """
  use Phoenix.Component
  import ElixircnWeb.Components.UI.Utils

  attr :value, :integer, default: 0
  attr :max, :integer, default: 100
  attr :aria_label, :string, default: nil, doc: "describes what is progressing, e.g. \"Uploading file\""
  attr :class, :any, default: nil
  attr :rest, :global

  @doc """
  Renders a progress bar.

  ## Examples

      <.progress value={@upload_pct} aria_label="Uploading profile photo" />
  """
  def progress(assigns) do
    pct = if assigns.max > 0, do: min(100, max(0, round(assigns.value / assigns.max * 100))), else: 0
    assigns = assign(assigns, :pct, pct)

    ~H"""
    <div
      class={cn(["relative h-2 w-full overflow-hidden rounded-full bg-primary/20", @class])}
      role="progressbar"
      aria-valuemin="0"
      aria-valuemax={@max}
      aria-valuenow={@value}
      aria-label={@aria_label}
      {@rest}
    >
      <div
        class="h-full w-full flex-1 bg-primary transition-all"
        style={"transform: translateX(-#{100 - @pct}%)"}
      />
    </div>
    """
  end
end
