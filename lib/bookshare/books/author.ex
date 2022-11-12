defmodule Bookshare.Books.Author do
  use Ecto.Schema
  import Ecto.Changeset

  schema "authors" do
    field :name, :string

    many_to_many :books, Bookshare.Books.Book, join_through: "books_authors"

    timestamps()
  end

  def changeset(author, attrs) do
    author
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)

  end
end
