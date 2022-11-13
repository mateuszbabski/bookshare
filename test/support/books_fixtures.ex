defmodule Bookshare.BooksFixtures do

  alias Bookshare.Books
  alias Bookshare.Repo

  def book_fixture(user, attrs \\ %{}) do
    {:ok, book} = Books.create_book(user, attrs)

     book
     |> Repo.preload([:authors, :categories])
  end
end
