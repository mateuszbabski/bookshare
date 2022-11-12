defmodule BookshareWeb.AuthorController do
  use BookshareWeb, :controller

  alias Bookshare.Authors

  action_fallback BookshareWeb.FallbackController

  def index(conn, _params) do
    authors = Authors.list_authors()
    render(conn, "index.json", authors: authors)
  end

  def show(conn, %{"id" => id}) do
    if author = Authors.get_author(id) do
      render(conn, "show.json", author: author)
    else
      conn
      |> put_status(:not_found)
      |> json(%{message: "Author not found"})
    end
  end

  def create_author(conn, author) do
    with {:ok, author} <- Authors.add_author(author) do
      conn
      |> put_status(:created)
      |> render("created.json", author: author)
    else
      {:error, changeset} ->
        {:error, changeset}
    end
  end
end
