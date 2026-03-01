defmodule ElixircnWeb.Components.UI.Drawer do
  use Phoenix.Component
  alias Phoenix.LiveView.JS

  def show_drawer(js \\ %JS{}, id) do
    js
    |> JS.show(to: "##{id}-backdrop")
    |> JS.show(
      to: "##{id}-content",
      transition: {"ease-out duration-300", "translate-y-full", "translate-y-0"},
      time: 300
    )
    |> JS.add_class("overflow-hidden", to: "body")
  end

  def hide_drawer(js \\ %JS{}, id) do
    js
    |> JS.hide(
      to: "##{id}-content",
      transition: {"ease-in duration-200", "translate-y-0", "translate-y-full"},
      time: 200
    )
    |> JS.hide(to: "##{id}-backdrop")
    |> JS.remove_class("overflow-hidden", to: "body")
  end

  attr :id, :string, required: true
  attr :class, :string, default: nil
  slot :trigger
  slot :inner_block, required: true

  def drawer(assigns) do
    ~H"""
    <div id={@id} class={@class}>
      <div :if={@trigger != []} phx-click={show_drawer(@id)}>
        {render_slot(@trigger)}
      </div>
      <div
        id={"#{@id}-backdrop"}
        class="hidden fixed inset-0 z-50 bg-black/80"
        phx-click={hide_drawer(@id)}
        data-escape-close
      />
      <div
        id={"#{@id}-content"}
        class="hidden fixed inset-x-0 bottom-0 z-50 mt-24 flex h-auto flex-col rounded-t-[10px] border bg-background"
        role="dialog"
        aria-modal="true"
      >
        <div class="mx-auto w-full max-w-sm">
          <div class="mx-auto mt-4 h-1 w-[100px] rounded-full bg-muted-foreground/30" />
          {render_slot(@inner_block)}
        </div>
      </div>
    </div>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def drawer_header(assigns) do
    ~H"""
    <div class={["grid gap-1.5 p-4 text-center sm:text-left", @class]} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def drawer_title(assigns) do
    ~H"""
    <h2 class={["text-lg font-semibold leading-none tracking-tight", @class]} {@rest}>
      {render_slot(@inner_block)}
    </h2>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def drawer_description(assigns) do
    ~H"""
    <p class={["text-sm text-muted-foreground", @class]} {@rest}>
      {render_slot(@inner_block)}
    </p>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def drawer_content(assigns) do
    ~H"""
    <div class={["p-4", @class]} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def drawer_footer(assigns) do
    ~H"""
    <div class={["mt-auto flex flex-col gap-2 p-4", @class]} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end
end
