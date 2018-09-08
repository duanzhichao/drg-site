defmodule DrgSiteWeb.UserView do
  use DrgSiteWeb, :view

  def render("login.json", %{user: user, login: login}) do
    %{data: render_one(user, DrgSiteWeb.UserView, "user.json"), login: login}
  end

  def render("index.json", %{user: user}) do
    %{data: render_many(user, DrgSiteWeb.UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, DrgSiteWeb.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      username: user.username,
      hashpw: user.hashpw,
      org_code: user.org_code,
      org_name: user.org_name,
      phone: user.phone,
      address: user.address,
      person: user.person,
      time: user.time,
      email: user.email,
      type: user.type,
      admin: user.admin}
  end
end
