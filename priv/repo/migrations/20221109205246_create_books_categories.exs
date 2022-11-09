defmodule Bookshare.Repo.Migrations.CreateBooksCategories do
  use Ecto.Migration

  def change do
    create table(:books_categories, primary_key: false) do
      add :book_id, references(:books), primary_key: true
      add :category_id, references(:categories), primary_key: true
    end

    create unique_index(:books_categories, [:book_id, :category_id])
  end
end
