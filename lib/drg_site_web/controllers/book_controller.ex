defmodule DrgSiteWeb.BookController do
  use DrgSiteWeb, :controller

  alias DrgSite.Book

  def index(conn, %{"type" => type, "skip" => skip, "style" => style}) do
    book =
    case style do
      "sql" -> query = from book in Book,
                where: book.type == ^type,
                order_by: [asc: book.num],
                limit: 5,
                offset: ^skip
                Repo.all(query)
      "count" -> query = from book in Book,
                where: book.type == ^type
                Repo.all(query)
    end
    render(conn, "index.json", book: book)
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
