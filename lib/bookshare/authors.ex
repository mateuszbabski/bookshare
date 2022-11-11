defmodule Bookshare.Authors do
  @moduledoc """
  The Books context.
  """

  import Ecto.Query, warn: false
  alias Bookshare.Repo

  alias Bookshare.Books.Author

  def list_authors do
    Repo.all(Author)
  end

  @spec get_author(any) :: nil | [%{optional(atom) => any}] | %{optional(atom) => any}
  def get_author(id), do: Repo.get(Author, id) |> Repo.preload(:books)

  def get_author_by_name(name), do: Repo.one(from a in Author, where: a.name == ^name)

  def add_author(attrs) do
    %Author{}
    |> Author.changeset(attrs)
    |> Repo.insert()
  end
end
