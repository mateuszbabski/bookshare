defmodule Bookshare.Repo.Migrations.CreateAuthor do
  use Ecto.Migration

  def change do
    create table(:authors) do
      add :name, :string

      timestamps()
    end

    create unique_index(:authors, [:name])
  end
end
