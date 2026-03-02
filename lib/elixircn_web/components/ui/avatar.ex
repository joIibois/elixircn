defmodule ElixircnWeb.Components.UI.Avatar do
  @moduledoc "Provides an avatar component with image display and fallback initials support."
  use Phoenix.Component
  import ElixircnWeb.Components.UI.Utils

  attr :id, :string, default: nil
  attr :src, :string, default: nil
  attr :alt, :string, default: ""
  attr :fallback, :string, default: nil
  attr :size, :string, default: "default", values: ~w(sm default lg)
  attr :class, :any, default: nil
  attr :rest, :global

  @doc "Renders a circular avatar with an image and a fallback initial or custom text."
  def avatar(assigns) do
    ~H"""
    <span
      id={@id}
      class={cn([avatar_size(@size), "relative flex shrink-0 overflow-hidden rounded-full", @class])}
      phx-hook={@src && @id && "AvatarFallback"}
      {@rest}
    >
      <img
        :if={@src}
        src={@src}
        alt={@alt}
        class="aspect-square h-full w-full object-cover"
      />
      <span
        data-avatar-fallback
        style={@src && "display:none"}
        class="flex h-full w-full items-center justify-center rounded-full bg-muted text-muted-foreground font-medium text-sm"
      >
        {if @fallback, do: @fallback, else: String.at(@alt, 0) || "?"}
      </span>
    </span>
    """
  end

  defp avatar_size("sm"), do: "h-8 w-8"
  defp avatar_size("default"), do: "h-10 w-10"
  defp avatar_size("lg"), do: "h-14 w-14"
end
