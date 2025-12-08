defmodule SampleWeb.Router do
  use SampleWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {SampleWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SampleWeb do
    pipe_through :browser

    get "/", PageController, :home

    live "/urls", UrlLive.Index, :index
    live "/urls/new", UrlLive.Form, :new
    live "/urls/:id", UrlLive.Show, :show
    live "/urls/:id/edit", UrlLive.Form, :edit

    get "/shorten", UrlController, :new
    post "/shorten", UrlController, :create
    get "/s/:code", UrlController, :redirect_to_url
  end

  # Other scopes may use custom stacks.
  # scope "/api", SampleWeb do
  #   pipe_through :api
  # end
end
