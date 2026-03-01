defmodule ElixircnWeb.Components.UI.Command do
  use Phoenix.Component
  import ElixircnWeb.Components.UI.Icon

  attr :id, :string, default: nil
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def command(assigns) do
    ~H"""
    <div
      id={@id}
      class={[
        "flex h-full w-full flex-col overflow-hidden rounded-md bg-popover text-popover-foreground",
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

  def command_input(assigns) do
    ~H"""
    <div class="flex items-center border-b px-3" cmdk-input-wrapper>
      <.icon name="search" class="mr-2 h-4 w-4 shrink-0 opacity-50" />
      <input
        type="text"
        class={[
          "flex h-10 w-full rounded-md bg-transparent py-3 text-sm outline-none placeholder:text-muted-foreground disabled:cursor-not-allowed disabled:opacity-50",
          @class
        ]}
        {@rest}
      />
    </div>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def command_list(assigns) do
    ~H"""
    <div class={["max-h-[300px] overflow-y-auto overflow-x-hidden", @class]} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block

  def command_empty(assigns) do
    ~H"""
    <div class={["py-6 text-center text-sm", @class]} {@rest}>
      {if @inner_block != [], do: render_slot(@inner_block), else: "No results found."}
    </div>
    """
  end

  attr :heading, :string, default: nil
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def command_group(assigns) do
    ~H"""
    <div class={["overflow-hidden p-1 text-foreground", @class]} {@rest}>
      <div :if={@heading} class="px-2 py-1.5 text-xs font-medium text-muted-foreground">
        {@heading}
      </div>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global

  def command_separator(assigns) do
    ~H"""
    <div class={["-mx-1 h-px bg-border", @class]} {@rest} />
    """
  end

  attr :class, :string, default: nil
  attr :disabled, :boolean, default: false
  attr :shortcut, :string, default: nil
  attr :rest, :global, include: ~w(phx-click phx-value-id)
  slot :inner_block, required: true

  def command_item(assigns) do
    ~H"""
    <div
      role="option"
      class={[
        "relative flex cursor-pointer select-none items-center gap-2 rounded-sm px-2 py-1.5 text-sm outline-none hover:bg-accent hover:text-accent-foreground [&_svg]:pointer-events-none [&_svg]:size-4 [&_svg]:shrink-0",
        @disabled && "pointer-events-none opacity-50",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
      <span :if={@shortcut} class="ml-auto text-xs tracking-widest text-muted-foreground">
        {@shortcut}
      </span>
    </div>
    """
  end
end
