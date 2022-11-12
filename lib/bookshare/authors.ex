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

  def get_author_by_name(name), do: Repo.get_by(Author, name: name) |> Repo.preload(:books)

  def all_books_by_author(author) do
    Ecto.assoc(author, :books)
    |> Repo.all()
  end
end
