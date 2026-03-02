defmodule ElixircnWeb.Components.UI.DataTable do
  @moduledoc """
  Data table component that renders a list of rows with optional column
  headers, actions, and clickable-row support with full keyboard accessibility.
  """
  use Phoenix.Component
  import ElixircnWeb.Components.UI.Table

  attr :id, :string, default: nil
  attr :rows, :list, required: true
  attr :row_id, :any, default: nil
  attr :row_click, :any, default: nil
  attr :empty_message, :string, default: "No results."
  attr :class, :any, default: nil
  attr :rest, :global

  slot :col, required: true do
    attr :label, :string, required: true
    attr :class, :string
  end

  slot :action do
    attr :label, :string
  end

  @doc """
  Renders a data table.

  When `row_click` is provided each row becomes keyboard-focusable
  (`tabindex="0"`, `role="button"`) and responds to Enter/Space in addition
  to click events.

  ## Examples

      <.data_table rows={@users} row_click={fn u -> JS.navigate(~p"/users/\#{u}") end}>
        <:col label="Name">{user.name}</:col>
        <:col label="Email">{user.email}</:col>
      </.data_table>
  """
  def data_table(assigns) do
    ~H"""
    <div id={@id} class={@class} {@rest}>
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
            tabindex={@row_click && "0"}
            role={@row_click && "button"}
            phx-key={@row_click && "Enter"}
            phx-keydown={@row_click && @row_click.(row)}
            class={@row_click && "cursor-pointer focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring"}
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
