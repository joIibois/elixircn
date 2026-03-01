defmodule ElixircnWeb.Components.UI.Dialog do
  use Phoenix.Component
  alias Phoenix.LiveView.JS

  def show_dialog(js \\ %JS{}, id) do
    js
    |> JS.show(to: "##{id}-backdrop")
    |> JS.show(
      to: "##{id}-content",
      transition: {"ease-out duration-200", "opacity-0 scale-95", "opacity-100 scale-100"},
      time: 200
    )
    |> JS.add_class("overflow-hidden", to: "body")
  end

  def hide_dialog(js \\ %JS{}, id) do
    js
    |> JS.hide(
      to: "##{id}-content",
      transition: {"ease-in duration-150", "opacity-100 scale-100", "opacity-0 scale-95"},
      time: 150
    )
    |> JS.hide(to: "##{id}-backdrop")
    |> JS.remove_class("overflow-hidden", to: "body")
  end

  attr :id, :string, required: true
  attr :class, :string, default: nil
  slot :trigger
  slot :inner_block, required: true

  def dialog(assigns) do
    ~H"""
    <div id={@id} class={@class}>
      <div :if={@trigger != []} phx-click={show_dialog(@id)}>
        {render_slot(@trigger)}
      </div>
      <div
        id={"#{@id}-backdrop"}
        class="hidden fixed inset-0 z-50 bg-black/80"
        phx-click={hide_dialog(@id)}
        data-escape-close
      />
      <div
        id={"#{@id}-content"}
        class="hidden fixed left-[50%] top-[50%] z-50 translate-x-[-50%] translate-y-[-50%] w-full max-w-lg"
        role="dialog"
        aria-modal="true"
      >
        {render_slot(@inner_block)}
      </div>
    </div>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def dialog_content(assigns) do
    ~H"""
    <div
      class={[
        "grid w-full gap-4 rounded-lg border bg-background p-6 shadow-lg",
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

  def dialog_header(assigns) do
    ~H"""
    <div class={["flex flex-col space-y-1.5 text-center sm:text-left", @class]} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def dialog_footer(assigns) do
    ~H"""
    <div class={["flex flex-col-reverse sm:flex-row sm:justify-end sm:space-x-2", @class]} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def dialog_title(assigns) do
    ~H"""
    <h2 class={["text-lg font-semibold leading-none tracking-tight", @class]} {@rest}>
      {render_slot(@inner_block)}
    </h2>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def dialog_description(assigns) do
    ~H"""
    <p class={["text-sm text-muted-foreground", @class]} {@rest}>
      {render_slot(@inner_block)}
    </p>
    """
  end
end
