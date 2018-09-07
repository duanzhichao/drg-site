defmodule DrgSiteWeb.BookView do
  use DrgSiteWeb, :view

  def render("index.json", %{book: book, page: page, page_list: page_list}) do
    %{data: render_many(book, DrgSiteWeb.BookView, "book.json"), page: page, page_list: page_list}
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
