defmodule ElixircnWeb.Components.UI.InputOtp do
  @moduledoc """
  One-time password input component that renders a row of single-character
  inputs with automatic focus-advance, backspace navigation, and paste support.
  """
  use Phoenix.Component
  import ElixircnWeb.Components.UI.Utils

  attr :id, :string, required: true
  attr :name, :string, default: nil
  attr :length, :integer, default: 6
  attr :value, :string, default: ""
  attr :mode, :string,
    default: "numeric",
    values: ~w(numeric alphanumeric),
    doc: "\"numeric\" restricts to digits only; \"alphanumeric\" allows letters and digits"
  attr :disabled, :boolean, default: false
  attr :class, :any, default: nil
  attr :rest, :global

  @doc """
  Renders a one-time password (OTP) input field.

  The component renders `length` individual single-character inputs and keeps
  a hidden aggregate input in sync. The `InputOtp` JS hook handles focus
  management and paste splitting.

  ## Examples

      <.input_otp id="otp" name="code" length={6} />

      <.input_otp id="otp-alpha" mode="alphanumeric" length={4} value={@code} />
  """
  def input_otp(assigns) do
    digits =
      assigns.value
      |> String.graphemes()
      |> then(fn g ->
        g ++ List.duplicate("", max(0, assigns.length - length(g)))
      end)
      |> Enum.take(assigns.length)

    joined = Enum.join(digits)
    assigns = assign(assigns, digits: digits, joined: joined)

    ~H"""
    <div
      id={@id}
      class={cn(["flex items-center gap-2", @class])}
      phx-hook="InputOtp"
      data-otp-mode={@mode}
      {@rest}
    >
      <input type="hidden" name={@name || @id} value={@joined} />
      <input
        :for={{digit, idx} <- Enum.with_index(@digits)}
        data-otp-input
        data-otp-index={idx}
        type="text"
        inputmode={if @mode == "numeric", do: "numeric", else: "text"}
        pattern={if @mode == "numeric", do: "[0-9]*", else: "[a-zA-Z0-9]*"}
        autocomplete="one-time-code"
        maxlength="1"
        value={digit}
        disabled={@disabled}
        class="h-9 w-9 rounded-md border border-input bg-transparent text-center text-sm shadow-sm transition-colors placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:cursor-not-allowed disabled:opacity-50"
      />
    </div>
    """
  end
end
