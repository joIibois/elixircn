defmodule ElixircnWeb.Components.UI.Command do
  @moduledoc "Provides command palette components for searchable lists of actions and items."
  use Phoenix.Component
  import ElixircnWeb.Components.UI.Icon
  import ElixircnWeb.Components.UI.Utils

  attr :id, :string, default: nil
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders the command palette root container."
  def command(assigns) do
    ~H"""
    <div
      id={@id}
      class={cn([
        "flex h-full w-full flex-col overflow-hidden rounded-md bg-popover text-popover-foreground",
        @class
      ])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global

  @doc "Renders the search input row at the top of the command palette."
  def command_input(assigns) do
    ~H"""
    <div class="flex items-center border-b px-3" cmdk-input-wrapper>
      <.icon name="search" class="mr-2 h-4 w-4 shrink-0 opacity-50" />
      <input
        type="text"
        class={cn([
          "flex h-10 w-full rounded-md bg-transparent py-3 text-sm outline-none placeholder:text-muted-foreground disabled:cursor-not-allowed disabled:opacity-50",
          @class
        ])}
        {@rest}
      />
    </div>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders the scrollable list area of the command palette."
  def command_list(assigns) do
    ~H"""
    <div class={cn(["max-h-[300px] overflow-y-auto overflow-x-hidden", @class])} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block

  @doc "Renders a centered empty state message when no command results are found."
  def command_empty(assigns) do
    ~H"""
    <div class={cn(["py-6 text-center text-sm", @class])} {@rest}>
      {if @inner_block != [], do: render_slot(@inner_block), else: "No results found."}
    </div>
    """
  end

  attr :heading, :string, default: nil
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders a labeled group section within the command palette list."
  def command_group(assigns) do
    ~H"""
    <div class={cn(["overflow-hidden p-1 text-foreground", @class])} {@rest}>
      <div :if={@heading} class="px-2 py-1.5 text-xs font-medium text-muted-foreground">
        {@heading}
      </div>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global

  @doc "Renders a horizontal separator line between command groups."
  def command_separator(assigns) do
    ~H"""
    <div class={cn(["-mx-1 h-px bg-border", @class])} {@rest} />
    """
  end

  attr :class, :any, default: nil
  attr :disabled, :boolean, default: false
  attr :shortcut, :string, default: nil
  attr :rest, :global, include: ~w(form name value data-confirm)
  slot :inner_block, required: true

  @doc "Renders a selectable command item with optional keyboard shortcut hint."
  def command_item(assigns) do
    ~H"""
    <div
      role="option"
      class={cn([
        "relative flex cursor-pointer select-none items-center gap-2 rounded-sm px-2 py-1.5 text-sm outline-none hover:bg-accent hover:text-accent-foreground [&_svg]:pointer-events-none [&_svg]:size-4 [&_svg]:shrink-0",
        @disabled && "pointer-events-none opacity-50",
        @class
      ])}
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
