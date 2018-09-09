defmodule DrgSiteWeb.DownloadRecordController do
  use DrgSiteWeb, :controller

  alias DrgSite.DownloadRecord
  alias DrgSite.Page

  def index(conn, %{"search" => search, "page" => page, "limit" => limit}) do
    skip = Page.skip(page, limit)
    query =
      case search do
        "" -> from(p in DownloadRecord)
        _ ->
          search = "%#{search}%"
          from p in DownloadRecord, where: like(p.username, ^search)
      end
    count = query
      |>select([p], count(p.id))
      |>Repo.all
      |>hd
    [page_num, page_list, _count] = Page.page_list(page, count, limit)
    download_record = query
      |>order_by([p], [desc: p.time])
      |>limit([p], ^limit)
      |>offset([p], ^skip)
      |>Repo.all
    render(conn, "index.json", download_record: download_record, page: page, page_list: page_list)
  end

  def create(conn, %{"download_record" => download_record_params}) do
    changeset = DownloadRecord.changeset(%DownloadRecord{}, download_record_params)

    case Repo.insert(changeset) do
      {:ok, download_record} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", download_record_path(conn, :show, download_record))
        |> render("show.json", download_record: download_record)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Drgweb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    download_record = Repo.get!(DownloadRecord, id)
    render(conn, "show.json", download_record: download_record)
  end

  def update(conn, %{"id" => id, "download_record" => download_record_params}) do
    download_record = Repo.get!(DownloadRecord, id)
    changeset = DownloadRecord.changeset(download_record, download_record_params)

    case Repo.update(changeset) do
      {:ok, download_record} ->
        render(conn, "show.json", download_record: download_record)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Drgweb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    download_record = Repo.get!(DownloadRecord, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(download_record)

    send_resp(conn, :no_content, "")
  end
end
