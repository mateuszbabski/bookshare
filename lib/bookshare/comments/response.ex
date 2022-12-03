defmodule Bookshare.Comments.Response do
  use Ecto.Schema
  import Ecto.Changeset

  schema "responses" do
    field :text, :string

    belongs_to :user, Bookshare.Accounts.User, foreign_key: :user_id

    timestamps()
  end

  def changeset(response, attrs) do
    response
    |> cast(attrs, [:text])
    |> validate_required([:text])
    |> validate_length(:text, [min: 1, max: 500, message: "Review text has to have max 500 characters and can not be empty"])
  end
end
