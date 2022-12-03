defmodule Bookshare.Repo.Migrations.CreateResponses do
  use Ecto.Migration

  def change do
    create table("responses") do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :review_id, references(:reviews, on_delete: :delete_all), null: false

      add :text, :string, null: false

      timestamps()
    end

    create index(:responses, [:user_id, :review_id])
  end
end
