defmodule DrgSiteWeb.TechnicalDownloadView do
  use DrgSiteWeb, :view

  def render("index.json", %{technical_download: technical_download}) do
    %{data: render_many(technical_download, DrgSiteWeb.TechnicalDownloadView, "technical_download.json")}
  end

  def render("show.json", %{technical_download: technical_download}) do
    %{data: render_one(technical_download, DrgSiteWeb.TechnicalDownloadView, "technical_download.json")}
  end

  def render("technical_download.json", %{technical_download: technical_download}) do
    %{id: technical_download.id,
      file_type: technical_download.file_type,
      file_name: technical_download.file_name,
      up_user: technical_download.up_user,
      up_time: technical_download.up_time}
  end
end
