defmodule ElixircnWeb.Components.UI.Avatar do
  use Phoenix.Component

  attr :src, :string, default: nil
  attr :alt, :string, default: ""
  attr :fallback, :string, default: nil
  attr :size, :string, default: "default", values: ~w(sm default lg)
  attr :class, :string, default: nil
  attr :rest, :global

  def avatar(assigns) do
    ~H"""
    <span
      class={[avatar_size(@size), "relative flex shrink-0 overflow-hidden rounded-full", @class]}
      {@rest}
    >
      <img
        :if={@src}
        src={@src}
        alt={@alt}
        class="aspect-square h-full w-full object-cover"
        onerror="this.style.display='none';this.nextElementSibling.style.display='flex'"
      />
      <span
        class={[
          "flex h-full w-full items-center justify-center rounded-full bg-muted text-muted-foreground font-medium text-sm",
          @src && "hidden"
        ]}
      >
        {if @fallback, do: @fallback, else: String.at(@alt, 0) || "?"}
      </span>
    </span>
    """
  end

  defp avatar_size("sm"),      do: "h-8 w-8"
  defp avatar_size("default"), do: "h-10 w-10"
  defp avatar_size("lg"),      do: "h-14 w-14"
end
