defmodule Bookshare.Books.Book do
  use Ecto.Schema
  import Ecto.Changeset

  schema "books" do
    field :title, :string
    field :description, :string
    field :published, :integer
    field :isbn, :string
    field :is_available, :boolean, default: true
    field :to_borrow, :boolean, default: true
    field :to_sale, :boolean, default: false
    field :price, :decimal

    belongs_to :user, Bookshare.Accounts.User, foreign_key: :user_id
    many_to_many :categories, Bookshare.Books.Category, join_through: "books_categories", on_replace: :delete, on_delete: :delete_all
    many_to_many :authors, Bookshare.Books.Author, join_through: "books_authors", on_replace: :delete, on_delete: :delete_all

    timestamps()
  end

  @doc false
  def changeset(book, attrs) do
    book
    |> cast(attrs, [:title, :description, :published, :isbn, :is_available, :to_borrow, :to_sale, :price])
    |> cast_assoc(:categories)
    |> cast_assoc(:authors)
    |> validate_required([:title, :description, :published, :isbn])
    |> unique_constraint(:isbn)
  end
end
