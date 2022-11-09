defmodule Bookshare.Books.Book do
  use Ecto.Schema
  import Ecto.Changeset

  schema "books" do
    #field :authors, {:array, :string}
    #field :category, {:array, :string}
    field :title, :string
    field :description, :string
    field :published, :integer
    field :isbn, :string
    field :is_available, :boolean, default: true
    field :to_borrow, :boolean, default: true
    field :to_sale, :boolean, default: false
    field :price, :decimal

    belongs_to :user, Bookshare.Accounts.User, foreign_key: :user_id
    many_to_many :categories, Bookshare.Books.Category, join_through: "books_categories", on_replace: :delete
    many_to_many :authors, Bookshare.Books.Authors, join_through: "books_authors", on_replace: :delete

    timestamps()
  end

  @doc false
  def changeset(book, attrs) do
    book
    |> cast(attrs, [:title, :description, :published, :isbn, :available, :price])
    |> cast_assoc(:categories)
    |> cast_assoc(:authors)
    |> validate_required([:title, :description, :published, :isbn, :available])
    |> unique_constraint(:isbn)
  end
end
