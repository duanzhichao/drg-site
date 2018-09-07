defmodule DrgSiteWeb.DocController do
  use DrgSiteWeb, :controller
  alias DrgSite.Doc

  def index(conn, %{"doc_type" => doc_type, "skip" => skip, "type" => type, "limit" => limit}) do
    doc =
      case type do
        "query" ->
          query = from doc in Doc,
            where: doc.doc_type == ^doc_type,
            order_by: [desc: doc.doc_time],
            limit: ^limit,
            offset: ^skip
          Repo.all(query)
        "count" ->
          query = from doc in Doc,
            where: doc.doc_type == ^doc_type
          Repo.all(query)
      end
    render(conn, "index.json", doc: doc)
  end

  def create(conn, %{"doc" => doc_params}) do
    changeset = Doc.changeset(%Doc{}, doc_params)

    case Repo.insert(changeset) do
      {:ok, doc} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", doc_path(conn, :show, doc))
        |> render("show.json", doc: doc)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(DrgSiteWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    doc = Repo.get!(Doc, id)
    render(conn, "show.json", doc: doc)
  end

  def update(conn, %{"id" => id, "doc" => doc_params}) do
    doc = Repo.get!(Doc, id)
    changeset = Doc.changeset(doc, doc_params)

    case Repo.update(changeset) do
      {:ok, doc} ->
        render(conn, "show.json", doc: doc)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(DrgSiteWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    doc = Repo.get!(Doc, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(doc)

    send_resp(conn, :no_content, "")
  end
end
