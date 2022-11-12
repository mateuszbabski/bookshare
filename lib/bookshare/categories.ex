defmodule Bookshare.Categories do
  @moduledoc """
  The Books context.
  """

  import Ecto.Query, warn: false
  alias Bookshare.Repo

  alias Bookshare.Books.Category

  def list_categories do
    Repo.all(Category)
  end

  def get_category(id), do: Repo.get(Category, id) |> Repo.preload(:books)

  def get_category_by_name(name), do: Repo.get_by(Category, name: name) |> Repo.preload(:books)

  def all_books_by_category(category) do
    Ecto.assoc(category, :books)
    |> Repo.all()
  end
end
