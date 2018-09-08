defmodule DrgSiteWeb.PageController do
  use DrgSiteWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def cn_drgs(conn, _params) do
    %{"data_tab" => data_tab} = Map.merge(%{"data_tab" => "first"}, conn.params)
    render conn, "cn_drgs.html", data_tab: data_tab
  end

  def working(conn, _params) do
    render conn, "working.html"
  end

  def goverment(conn, _params) do
    render conn, "goverment.html"
  end

  def application(conn, _params) do
    render conn, "application.html"
  end

  def technical(conn, _params) do
    render conn, "technical.html", user: session(conn)
  end

  def research(conn, _params) do
    %{"zhpage" => zhpage, "enpage" => enpage} = Map.merge(%{"zhpage" => "1", "enpage" => "1"}, conn.params)
    render conn, "research.html", zhpage: zhpage, enpage: enpage
  end

  def edit(conn, %{"type" => type, "id" => id}) do
    render conn, "edit.html", type: type, id: id
  end

  def test(conn, _params) do
    render conn, "test.html", layout: false
  end

  defp session(conn) do
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
