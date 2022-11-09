defmodule Bookshare.Books.Book do
  use Ecto.Schema
  import Ecto.Changeset

  schema "books" do
    field :authors, {:array, :string}
    field :title, :string
    field :description, :string
    field :category, :string
    field :published, :integer
    field :isbn, :string
    field :available, :boolean, default: true
    field :status, :string
    field :price, :decimal

    belongs_to :user, Bookshare.Accounts.User, foreign_key: :user_id

    timestamps()
  end

  @doc false
  def changeset(book, attrs) do
    book
    |> cast(attrs, [:authors, :title, :description, :category, :published, :isbn, :available, :status, :price])
    |> validate_required([:authors, :title, :description, :category, :published, :isbn, :available, :status])
    |> unique_constraint(:isbn)
  end
end
