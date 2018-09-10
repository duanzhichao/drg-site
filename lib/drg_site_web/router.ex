defmodule DrgSiteWeb.Router do
  use DrgSiteWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  scope "/", DrgSiteWeb do
    pipe_through :browser # Use the default browser stack
    get "/", PageController, :index
    get "/cn_drgs", PageController, :cn_drgs
    get "/working", PageController, :working
    get "/goverment", PageController, :goverment
    get "/application", PageController, :application
    get "/technical", PageController, :technical
    get "/research", PageController, :research
    get "/edit", PageController, :edit
    get "/file", PageController, :file
    get "/login", PageController, :login
  end

  scope "/admin/", DrgSiteWeb do
    pipe_through :browser # Use the default browser stack
    get "/", AdminController, :index
    get "/user", AdminController, :user
    get "/book", AdminController, :book
    get "/doc", AdminController, :doc
    get "/download_record", AdminController, :download_record
    get "/change_user", AdminController, :change_user
    get "/data_manage", AdminController, :data_manage
  end

  scope "/api/", DrgSiteWeb do
    pipe_through :api
    get "/download_key", PageController, :download_key
    post "/login", UserController, :login
    get "/validate_username", UserController, :validate_username
    post "/image_upload", AdminController, :image_upload
    resources "/book", BookController, except: [:new, :edit]
    resources "/doc", DocController, except: [:new, :edit]
    resources "/technical_download", TechnicalDownloadController, except: [:new, :edit]
    resources "/data_download", DataDownloadController, except: [:new, :edit]
    resources "/user", UserController, except: [:new, :edit]
    resources "/download_record", DownloadRecordController, except: [:new, :edit]
  end

  # Other scopes may use custom stacks.
  # scope "/api", DrgSiteWeb do
  #   pipe_through :api
  # end
end
