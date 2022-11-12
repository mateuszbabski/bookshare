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

  def get_category_by_name(name), do: Repo.all(from c in Category, where: c.name == ^name)
end
