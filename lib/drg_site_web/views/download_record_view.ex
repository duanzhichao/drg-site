defmodule DrgSiteWeb.DownloadRecordView do
  use DrgSiteWeb, :view

  def render("index.json", %{download_record: download_record, page: page, page_list: page_list}) do
    %{data: render_many(download_record, DrgSiteWeb.DownloadRecordView, "download_record.json"), page: page, page_list: page_list}
  end

  def render("show.json", %{download_record: download_record}) do
    %{data: render_one(download_record, DrgSiteWeb.DownloadRecordView, "download_record.json")}
  end

  def render("download_record.json", %{download_record: download_record}) do
    %{id: download_record.id,
      username: download_record.username,
      title: download_record.title,
      time: download_record.time}
  end
end
