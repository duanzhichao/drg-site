defmodule DrgSiteWeb.AdminController do
  use DrgSiteWeb, :controller
  plug :put_layout, "admin.html"
  alias DrgSite.FileService

  def index(conn, _params) do
    render conn, "index.html"
  end

  def user(conn, _params) do
    %{"page" => page, "type" => type, "search" => search} = Map.merge(%{"page" => "1", "type" => "1", "search" => ""}, conn.params)
    render conn, "user.html", page: page, type: type, search: search
  end

  def book(conn, _params) do
    %{"page" => page, "type" => type, "search" => search} = Map.merge(%{"page" => "1", "type" => "1", "search" => ""}, conn.params)
    render conn, "book.html", page: page, type: type, search: search
  end

  def doc(conn, _params) do
    %{"page" => page, "type" => type} = Map.merge(%{"page" => "1", "type" => "1"}, conn.params)
    render conn, "doc.html", page: page, type: type
  end

  def download_record(conn, _params) do
    %{"page" => page, "search" => search} = Map.merge(%{"page" => "1", "search" => ""}, conn.params)
    render conn, "download_record.html", page: page, search: search
  end

  def change_user(conn, _params) do
    render conn, "change_user.html"
  end

  def data_manage(conn, _params) do
    %{"page" => page, "type" => type} = Map.merge(%{"page" => "1", "type" => "1"}, conn.params)
    render conn, "data_manage.html", page: page, type: type
  end

  def tech_manage(conn, _params) do
    %{"page" => page, "type" => type} = Map.merge(%{"page" => "1", "type" => "1"}, conn.params)
    render conn, "tech_manage.html", page: page, type: type
  end

  def file_upload(conn, _params) do
    render conn, "file_upload.html"
  end

  def image_upload(conn, _params) do
    file_path = "/home/images/"
    %{:path => file_path, :file_name => file_name, :file_size => file_size} = FileService.upload_file(file_path, conn.params["file"])
    json conn, %{filename: file_name}
  end

  defp is_login(conn) do
    user = get_session(conn, :user)
    case user do
      nil -> %{login: false, username: ""}
      _ ->
        case user.login do
          false -> %{login: false, username: ""}
          true -> %{login: true, username: user.username}
        end
    end
  end
end
