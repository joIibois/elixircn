defmodule ElixircnWeb.Components.UI.InputOtp do
  use Phoenix.Component

  attr :id, :string, required: true
  attr :name, :string, default: nil
  attr :length, :integer, default: 6
  attr :value, :string, default: ""
  attr :disabled, :boolean, default: false
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(phx-change)

  def input_otp(assigns) do
    digits = assigns.value |> String.graphemes() |> then(fn g ->
      g ++ List.duplicate("", max(0, assigns.length - length(g)))
    end) |> Enum.take(assigns.length)
    assigns = assign(assigns, :digits, digits)

    ~H"""
    <div
      id={@id}
      class={["flex items-center gap-2", @class]}
      phx-hook="InputOtp"
      {@rest}
    >
      <input
        :for={{digit, idx} <- Enum.with_index(@digits)}
        data-otp-input
        type="text"
        inputmode="numeric"
        pattern="[0-9]*"
        maxlength="1"
        value={digit}
        name={"#{@name || @id}[#{idx}]"}
        disabled={@disabled}
        class="h-9 w-9 rounded-md border border-input bg-transparent text-center text-sm shadow-sm transition-colors placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:cursor-not-allowed disabled:opacity-50"
      />
    </div>
    """
  end
end
