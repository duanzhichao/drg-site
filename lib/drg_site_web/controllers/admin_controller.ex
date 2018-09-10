defmodule DrgSiteWeb.AdminController do
  use DrgSiteWeb, :controller
  plug :put_layout, "admin.html"
  alias DrgSite.FileService

  def index(conn, _params) do
    user = is_login(conn)
    if(user.login)do
      render conn, "user.html", user: user, page: 1, type: 1, search: ""
    else
      redirect conn, to: "/admin/login"
    end
  end

  def user(conn, _params) do
    %{"page" => page, "type" => type, "search" => search} = Map.merge(%{"page" => "1", "type" => "1", "search" => ""}, conn.params)
    user = is_login(conn)
    if(user.login)do
      render conn, "user.html", user: user,page: page, type: type, search: search
    else
      redirect conn, to: "/admin/login"
    end
  end

  def book(conn, _params) do
    %{"page" => page, "type" => type, "search" => search} = Map.merge(%{"page" => "1", "type" => "1", "search" => ""}, conn.params)
    user = is_login(conn)
    if(user.login)do
      render conn, "book.html", user: user,page: page, type: type, search: search
    else
      redirect conn, to: "/admin/login"
    end
  end

  def doc(conn, _params) do
    %{"page" => page, "type" => type} = Map.merge(%{"page" => "1", "type" => "1"}, conn.params)
    user = is_login(conn)
    if(user.login)do
      render conn, "doc.html", user: user,page: page, type: type
    else
      redirect conn, to: "/admin/login"
    end
  end

  def download_record(conn, _params) do
    %{"page" => page, "search" => search} = Map.merge(%{"page" => "1", "search" => ""}, conn.params)
    user = is_login(conn)
    if(user.login)do
      render conn, "download_record.html", user: user,page: page, search: search
    else
      redirect conn, to: "/admin/login"
    end
  end

  def change_user(conn, _params) do
    user = is_login(conn)
    if(user.login)do
      render conn, "change_user.html", user: user
    else
      redirect conn, to: "/admin/login"
    end
  end

  def data_manage(conn, _params) do
    %{"page" => page, "type" => type} = Map.merge(%{"page" => "1", "type" => "1"}, conn.params)
    user = is_login(conn)
    if(user.login)do
      render conn, "data_manage.html", user: user,page: page, type: type
    else
      redirect conn, to: "/admin/login"
    end
  end

  def tech_manage(conn, _params) do
    %{"page" => page, "type" => type} = Map.merge(%{"page" => "1", "type" => "1"}, conn.params)
    user = is_login(conn)
    if(user.login)do
      render conn, "tech_manage.html", user: user,page: page, type: type
    else
      redirect conn, to: "/admin/login"
    end
  end

  def file_upload(conn, _params) do
    user = is_login(conn)
    if(user.login)do
      render conn, "file_upload.html", user: user
    else
      redirect conn, to: "/admin/login"
    end
  end

  def login(conn, _params) do
    render conn, "login.html", layout: false
  end

  def image_upload(conn, _params) do
    file_path = "/home/images/"
    %{:path => file_path, :file_name => file_name, :file_size => file_size} = FileService.upload_file(file_path, conn.params["file"])
    json conn, %{filename: file_name}
  end

  def logout(conn, _params) do
    conn = put_session(conn, :user, %{login: false, username: ""})
    json conn, %{login: false}
  end

  defp is_login(conn) do
    user = get_session(conn, :user)
    case user do
      nil -> %{login: false, username: ""}
      _ ->
        case user.login do
          false -> %{login: false, username: ""}
          true ->
            case user.admin do
              true -> %{login: true, username: user.username}
              false -> %{login: false, username: ""}
            end
        end
    end
  end
end
