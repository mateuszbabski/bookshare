defmodule BookshareWeb.AuthorView do
  use BookshareWeb, :view
  alias BookshareWeb.AuthorView

  def render("index.json", %{authors: authors}) do
    %{data: render_many(authors, AuthorView, "author.json")}
  end

  def render("show.json", %{author: author}) do
    %{data: render_one(author, AuthorView, "author.json")}
  end

  def render("author.json", %{author: author}) do
    %{
      id: author.id,
      name: author.name
    }
  end

  def render("created.json", %{author: author}) do
    %{
      message: "Author created",
      id: author.id,
      name: author.name
    }
  end
end
