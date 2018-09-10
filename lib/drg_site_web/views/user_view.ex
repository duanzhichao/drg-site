defmodule DrgSiteWeb.UserView do
  use DrgSiteWeb, :view

  def render("login.json", %{user: user, login: login}) do
    %{data: render_one(user, DrgSiteWeb.UserView, "user.json"), login: login}
  end

  def render("validate.json", %{user: user, ishave: ishave}) do
    %{data: render_one(user, DrgSiteWeb.UserView, "user.json"), ishave: ishave}
  end

  def render("index.json", %{user: user, page: page, page_list: page_list}) do
    %{data: render_many(user, DrgSiteWeb.UserView, "user.json"), page: page, page_list: page_list}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, DrgSiteWeb.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      username: user.username,
      org_code: user.org_code,
      org_name: user.org_name,
      phone: user.phone,
      address: user.address,
      person: user.person,
      time: user.time,
      email: user.email,
      type: user.type}
  end
end
