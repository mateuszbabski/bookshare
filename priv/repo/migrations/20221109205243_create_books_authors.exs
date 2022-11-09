defmodule Bookshare.Repo.Migrations.CreateBooksAuthors do
  use Ecto.Migration

  def change do
    create table(:books_authors, primary_key: false) do
      add :book_id, references(:books), primary_key: true
      add :author_id, references(:authors), primary_key: true
    end

    create unique_index(:books_authors, [:book_id, :author_id])
  end
end
