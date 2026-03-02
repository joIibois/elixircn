defmodule ElixircnWeb.Components.UI.Table do
  @moduledoc "Provides table components including header, body, footer, rows, head cells, data cells, and captions."
  use Phoenix.Component
  import ElixircnWeb.Components.UI.Utils

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders a scrollable table wrapper with a full-width caption-bottom table."
  def table(assigns) do
    ~H"""
    <div class="relative w-full overflow-auto">
      <table class={cn(["w-full caption-bottom text-sm", @class])} {@rest}>
        {render_slot(@inner_block)}
      </table>
    </div>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders a table thead element with bottom borders on rows."
  def table_header(assigns) do
    ~H"""
    <thead class={cn(["[&_tr]:border-b", @class])} {@rest}>
      {render_slot(@inner_block)}
    </thead>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders a table tbody element with no border on the last row."
  def table_body(assigns) do
    ~H"""
    <tbody class={cn(["[&_tr:last-child]:border-0", @class])} {@rest}>
      {render_slot(@inner_block)}
    </tbody>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders a table tfoot element with muted background and top border styling."
  def table_footer(assigns) do
    ~H"""
    <tfoot class={cn(["border-t bg-muted/50 font-medium [&>tr]:last:border-b-0", @class])} {@rest}>
      {render_slot(@inner_block)}
    </tfoot>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders a table tr element with hover and selected state styling."
  def table_row(assigns) do
    ~H"""
    <tr
      class={cn([
        "border-b transition-colors hover:bg-muted/50 data-[state=selected]:bg-muted",
        @class
      ])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </tr>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders a table th element styled for column headers with muted foreground text."
  def table_head(assigns) do
    ~H"""
    <th
      class={cn([
        "h-10 px-2 text-left align-middle font-medium text-muted-foreground [&:has([role=checkbox])]:pr-0 [&>[role=checkbox]]:translate-y-[2px]",
        @class
      ])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </th>
    """
  end

  attr :class, :any, default: nil
  attr :colspan, :integer, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders a table td element with consistent padding and checkbox alignment support."
  def table_cell(assigns) do
    ~H"""
    <td
      colspan={@colspan}
      class={cn([
        "p-2 align-middle [&:has([role=checkbox])]:pr-0 [&>[role=checkbox]]:translate-y-[2px]",
        @class
      ])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </td>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders a table caption element with top margin and muted foreground styling."
  def table_caption(assigns) do
    ~H"""
    <caption class={cn(["mt-4 text-sm text-muted-foreground", @class])} {@rest}>
      {render_slot(@inner_block)}
    </caption>
    """
  end
end
