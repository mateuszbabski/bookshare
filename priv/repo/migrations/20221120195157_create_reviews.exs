defmodule Bookshare.Repo.Migrations.CreateReviews do
  use Ecto.Migration

  def change do
    create table(:reviews) do
      add :user_id, references(:users, on_delete: :delete_all), null: false

      add :review_author_id, :integer, null: false
      add :text, :string, null: false
      add :rating, :decimal, null: false

      timestamps()
    end

    create index(:reviews, [:user_id])
  end
end
