defmodule Bookshare.Accounts.Profile do
  use Ecto.Schema
  import Ecto.Changeset

  schema "profiles" do
    field :username, :string
    field :first_name, :string
    field :last_name, :string
    field :phone_number, :string
    field :country, :string
    field :city, :string
    field :street, :string
    field :postal_code, :string

    belongs_to :user, Bookshare.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(profile, attrs) do
    profile
    |> cast(attrs, [:username])
    |> validate_required([:username])
    |> unique_constraint(:username)
  end
end
