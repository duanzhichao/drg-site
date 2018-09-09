defmodule DrgSiteWeb.BookController do
  use DrgSiteWeb, :controller

  alias DrgSite.Book
  alias DrgSite.Page

  def index(conn, %{"book_type" => book_type, "limit" => limit}) do
    %{"page" => page, "search" => search} = Map.merge(%{"page" => "1", "search" => ""}, conn.params)
    skip = Page.skip(page, limit)
    query = from(p in Book)|>where([p], p.type == ^book_type)
    num = Repo.all(query|>order_by([p], [desc: p.num])|>limit([p], 1))
    num =
      case num do
        [] -> 1
        _ -> hd(num).num + 1
      end
    query =
      case search do
        "" -> query
        _ ->
          search = "%#{search}%"
          from p in Book, where: p.type == ^book_type and (like(p.name, ^search) or like(p.author, ^search) or like(p.from, ^search))
      end
    count = query
      |>select([p], count(p.id))
      |>Repo.all
      |>hd
    [page_num, page_list, _count] = Page.page_list(page, count, limit)
    book = query
      |>order_by([p], [asc: p.num])
      |>limit([p], ^limit)
      |>offset([p], ^skip)
      |>Repo.all
    render(conn, "index.json", book: book, page: page, page_list: page_list, num: num)
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

    send_resp(conn, :no_content, "test")
  end
end
