defmodule ElixircnWeb.Router do
  use ElixircnWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {ElixircnWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ElixircnWeb do
    pipe_through :browser

    live "/", ShowcaseLive, :index
    live "/:component", ShowcaseLive, :show
  end
end
