defmodule Bookshare.Repo.Migrations.CreateBooks do
  use Ecto.Migration

  def change do
    create table(:books) do
      add :user_id, references(:users, on_delete: :delete_all), null: false

      add :authors, {:array, :string}, null: false
      add :title, :string, null: false
      add :description, :string, null: false
      add :category, :string, null: false
      add :published, :integer, null: false
      add :isbn, :string, null: false
      add :available, :boolean, default: true
      add :status, :string, null: false
      add :price, :decimal

      timestamps()
    end

    create index(:books, [:user_id])
    create unique_index(:books, [:isbn])
  end
end
