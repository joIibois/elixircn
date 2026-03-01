defmodule ElixircnWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, components, channels, and so on.
  """

  def static_paths, do: ~w(assets fonts images favicon.ico robots.txt)

  def router do
    quote do
      use Phoenix.Router, helpers: false

      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
    end
  end

  def controller do
    quote do
      use Phoenix.Controller, formats: [:html, :json]

      use Gettext, backend: ElixircnWeb.Gettext

      import Plug.Conn

      unquote(verified_routes())
    end
  end

  def live_view do
    quote do
      use Phoenix.LiveView

      unquote(html_helpers())
    end
  end

  def live_component do
    quote do
      use Phoenix.LiveComponent

      unquote(html_helpers())
    end
  end

  def html do
    quote do
      use Phoenix.Component

      import Phoenix.Controller,
        only: [get_csrf_token: 0, view_module: 1, view_template: 1]

      unquote(html_helpers())
    end
  end

  defp html_helpers do
    quote do
      use Gettext, backend: ElixircnWeb.Gettext

      import Phoenix.HTML
      import ElixircnWeb.CoreComponents, except: [input: 1, button: 1, table: 1, icon: 1]

      # Import all shadcn/ui components
      import ElixircnWeb.Components.UI.Icon
      import ElixircnWeb.Components.UI.Accordion
      import ElixircnWeb.Components.UI.Alert
      import ElixircnWeb.Components.UI.AlertDialog
      import ElixircnWeb.Components.UI.AspectRatio
      import ElixircnWeb.Components.UI.Avatar
      import ElixircnWeb.Components.UI.Badge
      import ElixircnWeb.Components.UI.Breadcrumb
      import ElixircnWeb.Components.UI.Button
      import ElixircnWeb.Components.UI.ButtonGroup
      import ElixircnWeb.Components.UI.Calendar
      import ElixircnWeb.Components.UI.Card
      import ElixircnWeb.Components.UI.Carousel
      import ElixircnWeb.Components.UI.Checkbox
      import ElixircnWeb.Components.UI.Collapsible
      import ElixircnWeb.Components.UI.Command
      import ElixircnWeb.Components.UI.Combobox
      import ElixircnWeb.Components.UI.ContextMenu
      import ElixircnWeb.Components.UI.DataTable
      import ElixircnWeb.Components.UI.DatePicker
      import ElixircnWeb.Components.UI.Dialog
      import ElixircnWeb.Components.UI.Direction
      import ElixircnWeb.Components.UI.Drawer
      import ElixircnWeb.Components.UI.DropdownMenu
      import ElixircnWeb.Components.UI.Empty
      import ElixircnWeb.Components.UI.Field
      import ElixircnWeb.Components.UI.HoverCard
      import ElixircnWeb.Components.UI.Input
      import ElixircnWeb.Components.UI.InputGroup
      import ElixircnWeb.Components.UI.InputOtp
      import ElixircnWeb.Components.UI.Item
      import ElixircnWeb.Components.UI.Kbd
      import ElixircnWeb.Components.UI.Label
      import ElixircnWeb.Components.UI.Menubar
      import ElixircnWeb.Components.UI.NativeSelect
      import ElixircnWeb.Components.UI.NavigationMenu
      import ElixircnWeb.Components.UI.Pagination
      import ElixircnWeb.Components.UI.Popover
      import ElixircnWeb.Components.UI.Progress
      import ElixircnWeb.Components.UI.RadioGroup
      import ElixircnWeb.Components.UI.Resizable
      import ElixircnWeb.Components.UI.ScrollArea
      import ElixircnWeb.Components.UI.Select
      import ElixircnWeb.Components.UI.Separator
      import ElixircnWeb.Components.UI.Sheet
      import ElixircnWeb.Components.UI.Sidebar
      import ElixircnWeb.Components.UI.Skeleton
      import ElixircnWeb.Components.UI.Slider
      import ElixircnWeb.Components.UI.Spinner
      import ElixircnWeb.Components.UI.Switch
      import ElixircnWeb.Components.UI.Table
      import ElixircnWeb.Components.UI.Tabs
      import ElixircnWeb.Components.UI.Textarea
      import ElixircnWeb.Components.UI.Toast
      import ElixircnWeb.Components.UI.Toggle
      import ElixircnWeb.Components.UI.ToggleGroup
      import ElixircnWeb.Components.UI.Tooltip
      import ElixircnWeb.Components.UI.Typography

      alias Phoenix.LiveView.JS
      alias ElixircnWeb.Layouts

      unquote(verified_routes())
    end
  end

  def verified_routes do
    quote do
      use Phoenix.VerifiedRoutes,
        endpoint: ElixircnWeb.Endpoint,
        router: ElixircnWeb.Router,
        statics: ElixircnWeb.static_paths()
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/live_view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
