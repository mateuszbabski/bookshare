defmodule Bookshare.Repo.Migrations.CreateProfiles do
  use Ecto.Migration

  def change do
    create table(:profiles, primary_key: false) do
      add :user_id, references(:users, on_delete: :delete_all), null: false

      add :username, :citext, null: false
      add :first_name, :string, null: false
      add :last_name, :string, null: false
      add :phone_number, :string, null: false
      add :country, :string, null: false
      add :city, :string
      add :street, :string
      add :postal_code, :string


      timestamps()
    end

    create index(:profiles, [:user_id])
    create unique_index(:profiles, [:username])
  end
end
