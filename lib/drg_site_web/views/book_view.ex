defmodule DrgSiteWeb.BookView do
  use DrgSiteWeb, :view

  def render("index.json", %{book: book}) do
    %{data: render_many(book, DrgSiteWeb.BookView, "book.json")}
  end

  def render("show.json", %{book: book}) do
    %{data: render_one(book, DrgSiteWeb.BookView, "book.json")}
  end

  def render("book.json", %{book: book}) do
    %{id: book.id,
      num: book.num,
      name: book.name,
      author: book.author,
      from: book.from,
      type: book.type}
  end
end
