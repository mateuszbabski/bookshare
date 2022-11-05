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

    belongs_to :user, Bookshare.Accounts.User, foreign_key: :user_id

    timestamps()
  end

  @doc false
  def changeset(profile, attrs) do
    profile
    |> cast(attrs, [:username, :first_name, :last_name, :phone_number, :country, :city, :street, :postal_code])
    |> validate_username()
    |> unique_constraint(:username)
  end

  defp validate_username(profile) do
    profile
    |> validate_required([:username])
    |> validate_format(:username, ~r/^[A-Za-z0-9]+$/, message: "Only letters and digits are allowed")
    |> validate_length(:username, max: 25)
    |> unsafe_validate_unique(:username, Bookshare.Repo)
    |> unique_constraint(:username)
  end
end
