defmodule DrgSiteWeb.PageController do
  use DrgSiteWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def test(conn, _params) do
    render conn, "test.html", layout: false
  end
end
