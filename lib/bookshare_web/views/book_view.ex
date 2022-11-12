defmodule BookshareWeb.BookView do
  use BookshareWeb, :view
  alias BookshareWeb.BookView

  def render("index.json", %{books: books}) do
    %{data: render_many(books, BookView, "book.json")}
  end

  def render("show.json", %{book: book}) do
    %{data: render_one(book, BookView, "book.json")}
  end

  def render("book.json", %{book: book}) do
    %{
      id: book.id,
      title: book.title,
      isbn: book.isbn
    }
  end
end
