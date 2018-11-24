defmodule Code2pdfWeb.Router do
  use Code2pdfWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Code2pdfWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    post "/convert", PageController, :convert
  end

  # Other scopes may use custom stacks.
  # scope "/api", Code2pdfWeb do
  #   pipe_through :api
  # end
end
