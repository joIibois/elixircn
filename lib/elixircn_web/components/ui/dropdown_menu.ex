defmodule ElixircnWeb.Components.UI.DropdownMenu do
  use Phoenix.Component
  alias Phoenix.LiveView.JS

  def show_dropdown(id) do
    %JS{}
    |> JS.show(to: "##{id}-backdrop")
    |> JS.show(
      to: "##{id}-content",
      transition: {"ease-out duration-100", "opacity-0 scale-95", "opacity-100 scale-100"},
      time: 100
    )
  end

  def hide_dropdown(id) do
    %JS{}
    |> JS.hide(to: "##{id}-backdrop")
    |> JS.hide(
      to: "##{id}-content",
      transition: {"ease-in duration-75", "opacity-100 scale-100", "opacity-0 scale-95"},
      time: 75
    )
  end

  attr :id, :string, required: true
  attr :class, :string, default: nil
  slot :trigger, required: true
  slot :inner_block, required: true

  def dropdown_menu(assigns) do
    ~H"""
    <div id={@id} class={["relative inline-block", @class]}>
      <div
        id={"#{@id}-backdrop"}
        class="hidden fixed inset-0 z-40"
        phx-click={hide_dropdown(@id)}
      />
      <div phx-click={JS.toggle(to: "##{@id}-content",
        in:  {"ease-out duration-100", "opacity-0 scale-95", "opacity-100 scale-100"},
        out: {"ease-in duration-75", "opacity-100 scale-100", "opacity-0 scale-95"},
        time: 100
      ) |> JS.toggle(to: "##{@id}-backdrop")}>
        {render_slot(@trigger)}
      </div>
      <div
        id={"#{@id}-content"}
        class="hidden absolute right-0 top-full z-50 mt-1 min-w-[8rem] overflow-hidden rounded-md border bg-popover p-1 text-popover-foreground shadow-md"
        role="menu"
      >
        {render_slot(@inner_block)}
      </div>
    </div>
    """
  end

  attr :class, :string, default: nil
  attr :disabled, :boolean, default: false
  attr :rest, :global, include: ~w(phx-click phx-target phx-value-id)
  slot :inner_block, required: true

  def dropdown_menu_item(assigns) do
    ~H"""
    <div
      role="menuitem"
      class={[
        "relative flex cursor-pointer select-none items-center gap-2 rounded-sm px-2 py-1.5 text-sm outline-none transition-colors hover:bg-accent hover:text-accent-foreground focus:bg-accent focus:text-accent-foreground",
        @disabled && "pointer-events-none opacity-50",
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

  def dropdown_menu_label(assigns) do
    ~H"""
    <div class={["px-2 py-1.5 text-sm font-semibold", @class]} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global

  def dropdown_menu_separator(assigns) do
    ~H"""
    <div class={["-mx-1 my-1 h-px bg-muted", @class]} {@rest} />
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def dropdown_menu_group(assigns) do
    ~H"""
    <div class={@class} role="group" {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end
end
