defmodule Bookshare.BooksTest do
  use Bookshare.DataCase

  alias Bookshare.Books
  alias Bookshare.Books.Book
  alias Bookshare.BooksFixtures
  alias Bookshare.AccountsFixtures

    describe "books" do

    @valid_attrs %{
                    "title" => "Book 1",
                    "description" => "Book description",
                    "isbn" => "111-111-111",
                    "published" => 2000,
                    "authors" => "author",
                    "categories" => "category"
                  }
    @invalid_attrs %{}
    @update_attrs %{"title" => "Updated Book 1", "description" => "Updated Book description"}

    setup do
      %{user: AccountsFixtures.user_fixture()}
    end

    test "list books/0 returns all books", %{user: user} do
      book = BooksFixtures.book_fixture(user, @valid_attrs)
      assert Books.list_books() == [book]
    end

    test "get_book!/1 returns the book with given id", %{user: user} do
      book = BooksFixtures.book_fixture(user, @valid_attrs)
      assert Books.get_book!(book.id) == book
    end

    test "get_book/1 returns the book with given id", %{user: user} do
      book = BooksFixtures.book_fixture(user, @valid_attrs)
      assert Books.get_book(book.id) == book
    end

    test "get_book/1 refute with invalid id" do
      refute Books.get_book(1)
    end

    test "create_book/2 with valid params", %{user: user} do
      book = BooksFixtures.book_fixture(user, @valid_attrs)
      assert book.title == "Book 1"
      assert book.description == "Book description"
      assert book.published == 2000
      assert book.isbn == "111-111-111"
    end

    test "create_book/2 with invalid params", %{user: user} do
      #assert {:error, %Ecto.Changeset{}} = BooksFixtures.book_fixture(user, @invalid_attrs)
    end
  end
end
