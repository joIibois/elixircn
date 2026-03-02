defmodule ElixircnWeb.Components.UI.Spinner do
  @moduledoc """
  Animated loading spinner component.
  """
  use Phoenix.Component
  import ElixircnWeb.Components.UI.Utils

  attr :size, :string, default: "default", values: ~w(sm default lg)
  attr :label, :string, default: nil, doc: "visible text shown next to the spinner"
  attr :aria_label, :string, default: nil, doc: "accessible label for screen readers when no visible label is present"
  attr :class, :any, default: nil
  attr :rest, :global

  @doc """
  Renders an animated loading spinner.

  When no `label` is given a visually-hidden `"Loading..."` text is rendered
  for screen readers. Override the screen-reader announcement with `aria_label`.

  ## Examples

      <.spinner />
      <.spinner label="Saving..." />
      <.spinner aria_label="Processing payment" />
  """
  def spinner(assigns) do
    ~H"""
    <span role="status" aria-label={!@label && @aria_label} class="inline-flex items-center gap-2">
      <svg
        class={cn([spinner_size(@size), "animate-spin text-muted-foreground", @class])}
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
      <span :if={@label} class="text-sm text-muted-foreground">{@label}</span>
      <span :if={!@label && !@aria_label} class="sr-only">Loading...</span>
    </span>
    """
  end

  defp spinner_size("sm"), do: "h-4 w-4"
  defp spinner_size("default"), do: "h-6 w-6"
  defp spinner_size("lg"), do: "h-8 w-8"
end
