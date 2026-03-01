defmodule ElixircnWeb.ShowcaseLive do
  use ElixircnWeb, :live_view

  @components [
    # Display
    %{id: "badge", label: "Badge", group: "Display"},
    %{id: "separator", label: "Separator", group: "Display"},
    %{id: "skeleton", label: "Skeleton", group: "Display"},
    %{id: "spinner", label: "Spinner", group: "Display"},
    %{id: "kbd", label: "Kbd", group: "Display"},
    %{id: "typography", label: "Typography", group: "Display"},
    %{id: "aspect-ratio", label: "Aspect Ratio", group: "Display"},
    %{id: "avatar", label: "Avatar", group: "Display"},
    %{id: "progress", label: "Progress", group: "Display"},
    # Layout
    %{id: "card", label: "Card", group: "Layout"},
    %{id: "alert", label: "Alert", group: "Layout"},
    %{id: "scroll-area", label: "Scroll Area", group: "Layout"},
    %{id: "resizable", label: "Resizable", group: "Layout"},
    %{id: "aspect-ratio", label: "Aspect Ratio", group: "Layout"},
    # Forms
    %{id: "button", label: "Button", group: "Forms"},
    %{id: "button-group", label: "Button Group", group: "Forms"},
    %{id: "label", label: "Label", group: "Forms"},
    %{id: "input", label: "Input", group: "Forms"},
    %{id: "textarea", label: "Textarea", group: "Forms"},
    %{id: "checkbox", label: "Checkbox", group: "Forms"},
    %{id: "radio-group", label: "Radio Group", group: "Forms"},
    %{id: "switch", label: "Switch", group: "Forms"},
    %{id: "slider", label: "Slider", group: "Forms"},
    %{id: "select", label: "Select", group: "Forms"},
    %{id: "native-select", label: "Native Select", group: "Forms"},
    %{id: "toggle", label: "Toggle", group: "Forms"},
    %{id: "toggle-group", label: "Toggle Group", group: "Forms"},
    %{id: "field", label: "Field", group: "Forms"},
    %{id: "input-group", label: "Input Group", group: "Forms"},
    %{id: "input-otp", label: "Input OTP", group: "Forms"},
    %{id: "combobox", label: "Combobox", group: "Forms"},
    %{id: "date-picker", label: "Date Picker", group: "Forms"},
    # Data
    %{id: "table", label: "Table", group: "Data"},
    %{id: "data-table", label: "Data Table", group: "Data"},
    %{id: "calendar", label: "Calendar", group: "Data"},
    # Navigation
    %{id: "breadcrumb", label: "Breadcrumb", group: "Navigation"},
    %{id: "pagination", label: "Pagination", group: "Navigation"},
    %{id: "tabs", label: "Tabs", group: "Navigation"},
    %{id: "navigation-menu", label: "Navigation Menu", group: "Navigation"},
    %{id: "menubar", label: "Menubar", group: "Navigation"},
    %{id: "sidebar", label: "Sidebar", group: "Navigation"},
    # Overlays
    %{id: "dialog", label: "Dialog", group: "Overlays"},
    %{id: "alert-dialog", label: "Alert Dialog", group: "Overlays"},
    %{id: "sheet", label: "Sheet", group: "Overlays"},
    %{id: "drawer", label: "Drawer", group: "Overlays"},
    %{id: "popover", label: "Popover", group: "Overlays"},
    %{id: "hover-card", label: "Hover Card", group: "Overlays"},
    %{id: "dropdown-menu", label: "Dropdown Menu", group: "Overlays"},
    %{id: "context-menu", label: "Context Menu", group: "Overlays"},
    %{id: "tooltip", label: "Tooltip", group: "Overlays"},
    %{id: "toast", label: "Toast", group: "Overlays"},
    # Complex
    %{id: "accordion", label: "Accordion", group: "Complex"},
    %{id: "collapsible", label: "Collapsible", group: "Complex"},
    %{id: "carousel", label: "Carousel", group: "Complex"},
    %{id: "command", label: "Command", group: "Complex"},
    # Utilities
    %{id: "empty", label: "Empty State", group: "Utilities"},
    %{id: "item", label: "Item", group: "Utilities"},
    %{id: "direction", label: "Direction", group: "Utilities"}
  ]

  alias ElixircnWeb.ShowcaseCode

  def mount(params, _session, socket) do
    active = Map.get(params, "component", "badge")
    {:ok,
     socket
     |> assign(:page_title, "Elixircn — Phoenix shadcn/ui")
     |> assign(:active_component, active)
     |> assign(:code_snippet, ShowcaseCode.snippet(active))
     |> assign(:components, @components |> Enum.uniq_by(& &1.id) |> Enum.sort_by(& &1.label))
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
     |> assign(:active_component, "badge")
     |> assign(:code_snippet, ShowcaseCode.snippet("badge"))}
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
