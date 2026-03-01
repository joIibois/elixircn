defmodule ElixircnWeb.PageController do
  use ElixircnWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
