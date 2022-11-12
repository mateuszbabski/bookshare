defmodule Bookshare.Repo.Migrations.CreateAuthor do
  use Ecto.Migration

  def change do
    create table(:authors) do
      add :name, :citext, null: false

      timestamps()
    end

    create unique_index(:authors, [:name])
  end
end
