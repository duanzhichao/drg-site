defmodule DrgSiteWeb.DocController do
  use DrgSiteWeb, :controller
  alias DrgSite.Doc
  alias DrgSite.Page

  def index(conn, %{"doc_type" => doc_type, "limit" => limit}) do
    %{"page" => page, "skip" => skip} = Map.merge(%{"page" => "-1", "skip" => "0"}, conn.params)
    skip = if(page === "-1")do skip else Page.skip(page, limit) end
    query = from(p in Doc)|>where([p], p.doc_type == ^doc_type)
    count = query
      |>select([p], count(p.id))
      |>Repo.all
      |>hd
    [page_num, page_list, _count] = Page.page_list(page, count, limit)
    doc = query
      |>order_by([p], [asc: p.doc_time])
      |>limit([p], ^limit)
      |>offset([p], ^skip)
      |>Repo.all
    render(conn, "index.json", doc: doc, page: page, page_list: page_list)
  end

  def create(conn, %{"doc" => doc_params}) do
    changeset = Doc.changeset(%Doc{}, doc_params)
    IO.inspect changeset
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
