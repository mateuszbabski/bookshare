defmodule Bookshare.Repo.Migrations.CreateProfiles do
  use Ecto.Migration

  def change do
    create table(:profiles) do
      add :user_id, references(:users, on_delete: :delete_all), null: false

      add :username, :citext, null: false
      add :first_name, :string
      add :last_name, :string
      add :phone_number, :string
      add :country, :string
      add :city, :string
      add :street, :string
      add :postal_code, :string

      timestamps()
    end

    create index(:profiles, [:user_id])
    create unique_index(:profiles, [:username])
  end
end
