defmodule BookshareWeb.BookView do
  use BookshareWeb, :view
  alias BookshareWeb.BookView

  def render("index.json", %{books: books}) do
    %{data: render_many(books, BookView, "book.json")}
  end

  def render("show.json", %{book: book}) do
    %{data: render_one(book, BookView, "book.json")}
  end

  def render("deleted.json", _params) do
    %{message: "Book deleted"}
  end

  def render("book.json", %{book: book}) do
    authors = render_many(book.authors, BookshareWeb.AuthorView, "author.json")
    categories = render_many(book.categories, BookshareWeb.CategoryView, "category.json")

    %{
      id: book.id,
      title: book.title,
      description: book.description,
      isbn: book.isbn,
      published: book.published,
      is_available: book.is_available,
      to_borrow: book.to_borrow,
      to_sale: book.to_sale,
      price: book.price,
      authors: authors,
      categories: categories
    }
  end

  def render("authors_books.json", %{book: book}) do
    #categories = render_many(book.categories, BookshareWeb.CategoryView, "category.json")

    %{
      id: book.id,
      title: book.title,
      description: book.description,
      isbn: book.isbn,
      published: book.published,
      is_available: book.is_available,
      to_borrow: book.to_borrow,
      to_sale: book.to_sale,
      price: book.price
      #categories: categories
    }
  end

  def render("category_books.json", %{book: book}) do
    #authors = render_many(book.authors, BookshareWeb.AuthorView, "author.json")

    %{
      id: book.id,
      title: book.title,
      description: book.description,
      isbn: book.isbn,
      published: book.published,
      is_available: book.is_available,
      to_borrow: book.to_borrow,
      to_sale: book.to_sale,
      price: book.price
      #authors: authors
    }
  end
end
