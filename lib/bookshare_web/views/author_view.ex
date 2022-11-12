defmodule BookshareWeb.AuthorView do
  use BookshareWeb, :view
  alias BookshareWeb.AuthorView

  def render("index.json", %{authors: authors}) do
    %{data: render_many(authors, AuthorView, "author.json")}
  end

  def render("show.json", %{author: author}) do
    #books = render_many(author.books, BookshareWeb.BookView, "book.json")
    books = render_many(author.books, BookshareWeb.BookView, "authors_books.json")

    %{
      author_id: author.id,
      author_name: author.name,
      books: books
    }
  end

  def render("author.json", %{author: author}) do
    %{
      id: author.id,
      name: author.name
    }
  end
end
