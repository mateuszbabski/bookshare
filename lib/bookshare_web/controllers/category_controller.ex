defmodule BookshareWeb.CategoryController do
  use BookshareWeb, :controller

  alias Bookshare.Categories

  action_fallback BookshareWeb.FallbackController

  def index(conn, _params) do
    categories = Categories.list_categories()
    render(conn, "index.json", categories: categories)
  end

  def show(conn, %{"id" => id}) do
    if category = Categories.get_category(id) do
      render(conn, "show.json", category: category)
    else
      conn
      |> put_status(:not_found)
      |> json(%{message: "Category not found"})
    end
  end
end
