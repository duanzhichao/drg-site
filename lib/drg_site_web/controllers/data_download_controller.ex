defmodule DrgSiteWeb.DataDownloadController do
  use DrgSiteWeb, :controller

  alias DrgSite.DataDownload

  def index(conn, %{"skip" => skip, "type" => type, "limit" => limit}) do
    data_download =
    case type do
      "query" ->  query = from data_download in DataDownload,
                  order_by: [asc: data_download.time],
                  limit: ^limit,
                  offset: ^skip
                Repo.all(query)
      "count" -> Repo.all(from p in DataDownload, order_by: [desc: p.time])
    end
    render(conn, "index.json", data_download: data_download)
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
