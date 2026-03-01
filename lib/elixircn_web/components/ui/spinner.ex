defmodule ElixircnWeb.Components.UI.Spinner do
  use Phoenix.Component

  attr :size, :string, default: "default", values: ~w(sm default lg)
  attr :class, :string, default: nil
  attr :rest, :global

  def spinner(assigns) do
    ~H"""
    <svg
      class={[spinner_size(@size), "animate-spin text-muted-foreground", @class]}
      xmlns="http://www.w3.org/2000/svg"
      fill="none"
      viewBox="0 0 24 24"
      aria-hidden="true"
      {@rest}
    >
      <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4" />
      <path
        class="opacity-75"
        fill="currentColor"
        d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
      />
    </svg>
    """
  end

  defp spinner_size("sm"),      do: "h-4 w-4"
  defp spinner_size("default"), do: "h-6 w-6"
  defp spinner_size("lg"),      do: "h-8 w-8"
end
