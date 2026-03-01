defmodule ElixircnWeb.Components.UI.DataTable do
  use Phoenix.Component
  import ElixircnWeb.Components.UI.Table

  attr :id, :string, default: nil
  attr :rows, :list, required: true
  attr :row_id, :any, default: nil
  attr :row_click, :any, default: nil
  attr :empty_message, :string, default: "No results."
  attr :class, :string, default: nil

  slot :col, required: true do
    attr :label, :string, required: true
    attr :class, :string
  end

  slot :action do
    attr :label, :string
  end

  def data_table(assigns) do
    ~H"""
    <div id={@id} class={@class}>
      <.table>
        <.table_header>
          <.table_row>
            <.table_head :for={col <- @col} class={col[:class]}>
              {col.label}
            </.table_head>
            <.table_head :if={@action != []} class="text-right">
              Actions
            </.table_head>
          </.table_row>
        </.table_header>
        <.table_body>
          <.table_row
            :for={row <- @rows}
            id={@row_id && @row_id.(row)}
            phx-click={@row_click && @row_click.(row)}
            class={@row_click && "cursor-pointer"}
          >
            <.table_cell :for={col <- @col} class={col[:class]}>
              {render_slot(col, row)}
            </.table_cell>
            <.table_cell :if={@action != []} class="text-right">
              {render_slot(@action, row)}
            </.table_cell>
          </.table_row>
          <.table_row :if={@rows == []}>
            <.table_cell
              class="text-center text-muted-foreground h-24"
              colspan={length(@col) + if(@action != [], do: 1, else: 0)}
            >
              {@empty_message}
            </.table_cell>
          </.table_row>
        </.table_body>
      </.table>
    </div>
    """
  end
end
