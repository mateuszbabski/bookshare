defmodule Bookshare.Repo.Migrations.CreateBooks do
  use Ecto.Migration

  def change do
    create table(:books) do
      add :user_id, references(:users, on_delete: :delete_all), null: false

      add :title, :string, null: false
      add :description, :string, null: false
      add :published, :integer, null: false
      add :isbn, :string, null: false
      add :is_available, :boolean, default: true
      add :to_borrow, :boolean, default: true
      add :to_sale, :boolean, default: false
      add :price, :decimal

      timestamps()
    end

    create index(:books, [:user_id])
    create unique_index(:books, [:isbn])
  end
end
