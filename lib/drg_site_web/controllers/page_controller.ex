defmodule DrgSiteWeb.PageController do
  use DrgSiteWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def cn_drgs(conn, _params) do
    %{"data_tab" => data_tab} = Map.merge(%{"data_tab" => "first"}, conn.params)
    render conn, "cn_drgs.html", data_tab: data_tab
  end

  def test(conn, _params) do
    render conn, "test.html", layout: false
  end
end
