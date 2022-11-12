defmodule BookshareWeb.CategoryView do
  use BookshareWeb, :view
  alias BookshareWeb.CategoryView

  def render("index.json", %{categories: categories}) do
    %{data: render_many(categories, CategoryView, "category.json")}
  end

  def render("show.json", %{category: category}) do
    books = render_many(category.books, BookshareWeb.BookView, "category_books.json")

    %{
      category_id: category.id,
      category_name: category.name,
      books: books
    }
  end

  def render("category.json", %{category: category}) do
    %{
      id: category.id,
      name: category.name
    }
  end
end
