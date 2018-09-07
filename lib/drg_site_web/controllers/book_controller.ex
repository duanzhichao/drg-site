defmodule DrgSiteWeb.BookController do
  use DrgSiteWeb, :controller

  alias DrgSite.Book
  alias DrgSite.Page

  def index(conn, %{"book_type" => book_type, "type" => type, "limit" => limit}) do
    %{"page" => page} = Map.merge(%{"page" => "1"}, conn.params)
    skip = Page.skip(page, limit)
    query = from(p in Book)
      |>where([p], p.type == ^book_type)
    count = query
      |>select([p], count(p.id))
      |>Repo.all
      |>hd
    [page_num, page_list, _count] = Page.page_list(page, count, limit)

    book = query
      |>limit([p], ^limit)
      |> offset([p], ^skip)
      |> order_by([p], [asc: p.num])
      |>Repo.all
    render(conn, "index.json", book: book, page: page, page_list: page_list)
  end

  def create(conn, %{"book" => book_params}) do
    changeset = Book.changeset(%Book{}, book_params)

    case Repo.insert(changeset) do
      {:ok, book} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", book_path(conn, :show, book))
        |> render("show.json", book: book)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(DrgSite.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    book = Repo.get!(Book, id)
    render(conn, "show.json", book: book)
  end

  def update(conn, %{"id" => id, "book" => book_params}) do
    book = Repo.get!(Book, id)
    changeset = Book.changeset(book, book_params)

    case Repo.update(changeset) do
      {:ok, book} ->
        render(conn, "show.json", book: book)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(DrgSite.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    book = Repo.get!(Book, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(book)

    send_resp(conn, :no_content, "")
  end
end
