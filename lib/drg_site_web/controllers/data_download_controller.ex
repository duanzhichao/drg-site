defmodule DrgSiteWeb.DataDownloadController do
  use DrgSiteWeb, :controller

  alias DrgSite.DataDownload
  alias DrgSite.Page

  def index(conn, %{"type" => type, "page" => page, "limit" => limit}) do
    %{"page" => page, "search" => search, "skip" => skip} = Map.merge(%{"page" => "-1", "search" => "", "skip" => "0"}, conn.params)
    skip = if(page === "-1")do skip else Page.skip(page, limit) end
    query = from(p in DataDownload)
    count = query
      |>select([p], count(p.id))
      |>Repo.all
      |>hd
    [page_num, page_list, _count] = Page.page_list(page, count, limit)
    data_download = query
      |>order_by([p], [asc: p.time])
      |>limit([p], ^limit)
      |>offset([p], ^skip)
      |>Repo.all
    render(conn, "index.json", data_download: data_download, page: page, page_list: page_list)
  end

  def create(conn, %{"data_download" => data_download_params}) do

    changeset = DataDownload.changeset(%DataDownload{}, data_download_params)
    case Repo.insert(changeset) do
      {:ok, data_download} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", data_download_path(conn, :show, data_download))
        |> render("show.json", data_download: data_download)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Drgweb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    data_download = Repo.get!(DataDownload, id)
    render(conn, "show.json", data_download: data_download)
  end

  def update(conn, %{"id" => id, "data_download" => data_download_params}) do
    data_download = Repo.get!(DataDownload, id)
    changeset = DataDownload.changeset(data_download, data_download_params)

    case Repo.update(changeset) do
      {:ok, data_download} ->
        render(conn, "show.json", data_download: data_download)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Drgweb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    data_download = Repo.get!(DataDownload, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(data_download)

    send_resp(conn, :no_content, "")
  end
end
