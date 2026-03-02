defmodule ElixircnWeb.Components.UI.Kbd do
  @moduledoc "Provides a keyboard key component for displaying keyboard shortcuts and hotkeys."
  use Phoenix.Component
  import ElixircnWeb.Components.UI.Utils

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders a styled keyboard key element."
  def kbd(assigns) do
    ~H"""
    <kbd
      class={cn([
        "pointer-events-none inline-flex h-5 select-none items-center gap-1 rounded border bg-muted px-1.5 font-mono text-[10px] font-medium text-muted-foreground opacity-100",
        @class
      ])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </kbd>
    """
  end
end
