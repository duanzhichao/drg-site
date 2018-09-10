defmodule DrgSiteWeb.DataDownloadView do
  use DrgSiteWeb, :view

  def render("index.json", %{data_download: data_download, page: page, page_list: page_list}) do
    %{data: render_many(data_download, DrgSiteWeb.DataDownloadView, "data_download.json"), page: page, page_list: page_list}
  end

  def render("show.json", %{data_download: data_download}) do
    %{data: render_one(data_download, DrgSiteWeb.DataDownloadView, "data_download.json")}
  end

  def render("data_download.json", %{data_download: data_download}) do
    %{id: data_download.id,
      title: data_download.title,
      time: data_download.time,
      notice: data_download.notice,
      schedule: data_download.schedule,
      download: data_download.download,
      up_user: data_download.up_user,
      up_time: data_download.up_time}
  end
end
