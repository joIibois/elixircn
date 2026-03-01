defmodule ElixircnWeb.Components.UI.Alert do
  use Phoenix.Component

  attr :variant, :string, default: "default", values: ~w(default destructive)
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def alert(assigns) do
    ~H"""
    <div
      role="alert"
      class={[
        "relative w-full rounded-lg border px-4 py-3 text-sm [&>svg+div]:translate-y-[-3px] [&>svg]:absolute [&>svg]:left-4 [&>svg]:top-4 [&>svg~*]:pl-7",
        @variant == "default" && "bg-background text-foreground [&>svg]:text-foreground",
        @variant == "destructive" && "border-destructive/50 text-destructive [&>svg]:text-destructive dark:border-destructive",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def alert_title(assigns) do
    ~H"""
    <h5 class={["mb-1 font-medium leading-none tracking-tight", @class]} {@rest}>
      {render_slot(@inner_block)}
    </h5>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def alert_description(assigns) do
    ~H"""
    <div class={["text-sm [&_p]:leading-relaxed", @class]} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end
end
