defmodule DrgSiteWeb.AdminController do
  use DrgSiteWeb, :controller
  plug :put_layout, "admin.html"

  def index(conn, _params) do
    render conn, "index.html"
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
