defmodule DrgSiteWeb.TechnicalDownloadController do
  use DrgSiteWeb, :controller

  alias DrgSite.TechnicalDownload
  alias DrgSite.Page

  def index(conn, %{"type" => type, "limit" => limit}) do
    %{"page" => page, "search" => search, "skip" => skip} = Map.merge(%{"page" => "-1", "search" => "", "skip" => "0"}, conn.params)
    skip = if(page === "-1")do skip else Page.skip(page, limit) end
    query =
      case type do
        "" -> from(p in TechnicalDownload)
        _ -> from(p in TechnicalDownload)|>where([p], p.file_type == ^type)
      end
    count = query
      |>select([p], count(p.id))
      |>Repo.all
      |>hd
    [page_num, page_list, _count] = Page.page_list(page, count, limit)
    technical_download = query
      |>order_by([p], [asc: p.up_time])
      |>limit([p], ^limit)
      |>offset([p], ^skip)
      |>Repo.all
    render(conn, "index.json", technical_download: technical_download, page: page, page_list: page_list)
  end

  def create(conn, %{"technical_download" => technical_download_params}) do
    changeset = TechnicalDownload.changeset(%TechnicalDownload{}, technical_download_params)
    case Repo.insert(changeset) do
      {:ok, technical_download} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", technical_download_path(conn, :show, technical_download))
        |> render("show.json", technical_download: technical_download)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Drgweb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    technical_download = Repo.get!(TechnicalDownload, id)
    render(conn, "show.json", technical_download: technical_download)
  end

  def update(conn, %{"id" => id, "technical_download" => technical_download_params}) do
    technical_download = Repo.get!(TechnicalDownload, id)
    changeset = TechnicalDownload.changeset(technical_download, technical_download_params)

    case Repo.update(changeset) do
      {:ok, technical_download} ->
        render(conn, "show.json", technical_download: technical_download)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Drgweb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    technical_download = Repo.get!(TechnicalDownload, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(technical_download)

    send_resp(conn, :no_content, "")
  end
end
