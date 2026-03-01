defmodule ElixircnWeb.ShowcaseLive do
  use ElixircnWeb, :live_view

  @components [
    %{id: "accordion", label: "Accordion"},
    %{id: "alert", label: "Alert"},
    %{id: "alert-dialog", label: "Alert Dialog"},
    %{id: "aspect-ratio", label: "Aspect Ratio"},
    %{id: "avatar", label: "Avatar"},
    %{id: "badge", label: "Badge"},
    %{id: "breadcrumb", label: "Breadcrumb"},
    %{id: "button", label: "Button"},
    %{id: "button-group", label: "Button Group"},
    %{id: "calendar", label: "Calendar"},
    %{id: "card", label: "Card"},
    %{id: "carousel", label: "Carousel"},
    %{id: "checkbox", label: "Checkbox"},
    %{id: "collapsible", label: "Collapsible"},
    %{id: "combobox", label: "Combobox"},
    %{id: "command", label: "Command"},
    %{id: "context-menu", label: "Context Menu"},
    %{id: "data-table", label: "Data Table"},
    %{id: "date-picker", label: "Date Picker"},
    %{id: "dialog", label: "Dialog"},
    %{id: "direction", label: "Direction"},
    %{id: "drawer", label: "Drawer"},
    %{id: "dropdown-menu", label: "Dropdown Menu"},
    %{id: "empty", label: "Empty State"},
    %{id: "field", label: "Field"},
    %{id: "hover-card", label: "Hover Card"},
    %{id: "input", label: "Input"},
    %{id: "input-group", label: "Input Group"},
    %{id: "input-otp", label: "Input OTP"},
    %{id: "item", label: "Item"},
    %{id: "kbd", label: "Kbd"},
    %{id: "label", label: "Label"},
    %{id: "menubar", label: "Menubar"},
    %{id: "native-select", label: "Native Select"},
    %{id: "navigation-menu", label: "Navigation Menu"},
    %{id: "pagination", label: "Pagination"},
    %{id: "popover", label: "Popover"},
    %{id: "progress", label: "Progress"},
    %{id: "radio-group", label: "Radio Group"},
    %{id: "resizable", label: "Resizable"},
    %{id: "scroll-area", label: "Scroll Area"},
    %{id: "select", label: "Select"},
    %{id: "separator", label: "Separator"},
    %{id: "sheet", label: "Sheet"},
    %{id: "sidebar", label: "Sidebar"},
    %{id: "skeleton", label: "Skeleton"},
    %{id: "slider", label: "Slider"},
    %{id: "spinner", label: "Spinner"},
    %{id: "switch", label: "Switch"},
    %{id: "table", label: "Table"},
    %{id: "tabs", label: "Tabs"},
    %{id: "textarea", label: "Textarea"},
    %{id: "toast", label: "Toast"},
    %{id: "toggle", label: "Toggle"},
    %{id: "toggle-group", label: "Toggle Group"},
    %{id: "tooltip", label: "Tooltip"},
    %{id: "typography", label: "Typography"}
  ]

  alias ElixircnWeb.ShowcaseCode

  def mount(params, _session, socket) do
    active = Map.get(params, "component", "introduction")

    {:ok,
     socket
     |> assign(:page_title, "Elixircn — Phoenix shadcn/ui")
     |> assign(:active_component, active)
     |> assign(:code_snippet, ShowcaseCode.snippet(active))
     |> assign(:components, @components)
     |> assign(:toasts, [])
     |> assign(:calendar_month, Date.utc_today().month)
     |> assign(:calendar_year, Date.utc_today().year)
     |> assign(:calendar_selected, nil)
     |> assign(:slider_value, 40)
     |> assign(:progress_value, 65)
     |> assign(:combobox_value, nil)
     |> assign(:select_value, nil)
     |> assign(:switch_checked, false)
     |> assign(:collapsible_open, false)}
  end

  def handle_params(%{"component" => component}, _uri, socket) do
    {:noreply,
     socket
     |> assign(:active_component, component)
     |> assign(:code_snippet, ShowcaseCode.snippet(component))}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply,
     socket
     |> assign(:active_component, "introduction")
     |> assign(:code_snippet, ShowcaseCode.snippet("introduction"))}
  end

  def handle_event("calendar_prev", _params, socket) do
    {year, month} = prev_month(socket.assigns.calendar_year, socket.assigns.calendar_month)
    {:noreply, socket |> assign(:calendar_year, year) |> assign(:calendar_month, month)}
  end

  def handle_event("calendar_next", _params, socket) do
    {year, month} = next_month(socket.assigns.calendar_year, socket.assigns.calendar_month)
    {:noreply, socket |> assign(:calendar_year, year) |> assign(:calendar_month, month)}
  end

  def handle_event("calendar_select", %{"date" => date_str}, socket) do
    date = Date.from_iso8601!(date_str)
    {:noreply, assign(socket, :calendar_selected, date)}
  end

  def handle_event("date_picker_prev", _params, socket) do
    {year, month} = prev_month(socket.assigns.calendar_year, socket.assigns.calendar_month)
    {:noreply, socket |> assign(:calendar_year, year) |> assign(:calendar_month, month)}
  end

  def handle_event("date_picker_next", _params, socket) do
    {year, month} = next_month(socket.assigns.calendar_year, socket.assigns.calendar_month)
    {:noreply, socket |> assign(:calendar_year, year) |> assign(:calendar_month, month)}
  end

  def handle_event("date_picker_select", %{"date" => date_str}, socket) do
    date = Date.from_iso8601!(date_str)
    {:noreply, assign(socket, :calendar_selected, date)}
  end

  def handle_event("show_toast", params, socket) do
    id = "toast-#{System.unique_integer([:positive])}"
    toast = %{
      id: id,
      title: Map.get(params, "title", "Notification"),
      description: Map.get(params, "description"),
      variant: Map.get(params, "variant")
    }
    Process.send_after(self(), {:dismiss_toast, id}, 4000)
    {:noreply, assign(socket, :toasts, [toast | socket.assigns.toasts])}
  end

  def handle_event("toggle_switch", _params, socket) do
    {:noreply, assign(socket, :switch_checked, !socket.assigns.switch_checked)}
  end

  def handle_event("toggle_collapsible", _params, socket) do
    {:noreply, assign(socket, :collapsible_open, !socket.assigns.collapsible_open)}
  end

  def handle_event("combobox_select", %{"value" => value}, socket) do
    {:noreply, assign(socket, :combobox_value, value)}
  end

  def handle_event("select_changed", %{"value" => value}, socket) do
    {:noreply, assign(socket, :select_value, value)}
  end

  def handle_event("combobox_search", _params, socket), do: {:noreply, socket}

  def handle_event("slider_change", %{"value" => value}, socket) do
    {:noreply, assign(socket, :slider_value, String.to_integer(value))}
  end

  def handle_info({:dismiss_toast, id}, socket) do
    toasts = Enum.reject(socket.assigns.toasts, &(&1.id == id))
    {:noreply, assign(socket, :toasts, toasts)}
  end

  defp prev_month(year, 1), do: {year - 1, 12}
  defp prev_month(year, month), do: {year, month - 1}

  defp next_month(year, 12), do: {year + 1, 1}
  defp next_month(year, month), do: {year, month + 1}

end
