defmodule DrgSiteWeb.TechnicalDownloadController do
  use DrgSiteWeb, :controller

  alias DrgSite.TechnicalDownload

  def index(conn, %{"type" => type, "skip" => skip, "limit" => limit}) do
    technical_download =
      case type do
        "" ->
          query = from p in TechnicalDownload,
            order_by: [desc: p.up_time],
            limit: ^limit,
            offset: ^skip
          Repo.all(query)
        _ ->
          query = from p in TechnicalDownload,
            where: p.file_type == ^type,
            order_by: [desc: p.up_time],
            limit: ^limit,
            offset: ^skip
          Repo.all(query)
      end
    render(conn, "index.json", technical_download: technical_download)
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
