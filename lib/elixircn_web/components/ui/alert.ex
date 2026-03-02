defmodule ElixircnWeb.Components.UI.Alert do
  @moduledoc "Provides alert components for displaying feedback messages with optional variants."
  use Phoenix.Component
  import ElixircnWeb.Components.UI.Utils

  attr :variant, :string, default: "default", values: ~w(default destructive)
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders an alert container with default or destructive styling."
  def alert(assigns) do
    ~H"""
    <div
      role="alert"
      class={cn([
        "relative w-full rounded-lg border px-4 py-3 text-sm [&>svg+div]:translate-y-[-3px] [&>svg]:absolute [&>svg]:left-4 [&>svg]:top-4 [&>svg~*]:pl-7",
        @variant == "default" && "bg-background text-foreground [&>svg]:text-foreground",
        @variant == "destructive" &&
          "border-destructive/50 text-destructive [&>svg]:text-destructive dark:border-destructive",
        @class
      ])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders the title heading within an alert."
  def alert_title(assigns) do
    ~H"""
    <h5 class={cn(["mb-1 font-medium leading-none tracking-tight", @class])} {@rest}>
      {render_slot(@inner_block)}
    </h5>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders the descriptive body text within an alert."
  def alert_description(assigns) do
    ~H"""
    <div class={cn(["text-sm [&_p]:leading-relaxed", @class])} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end
end
