defmodule Bookshare.Comments.Review do
  use Ecto.Schema
  import Ecto.Changeset


  schema "reviews" do
    field :rating, :decimal
    field :text, :string
    field :review_author_id, :integer

    belongs_to :user, Bookshare.Accounts.User, foreign_key: :user_id

    timestamps()
  end

  @doc false
  def changeset(review, attrs) do
    review
    |> cast(attrs, [:text, :rating])
    |> validate_required([:text, :rating])
    |> validate_number(:rating, [min: 1, max: 5, message: "Rating needs to be between 1 and 5"])
  end
end
