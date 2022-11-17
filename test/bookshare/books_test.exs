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
    @invalid_attrs %{"title" => nil, "description" => nil, "isbn" => nil, "published" => nil, "authors" => nil, "categories" => nil}
    @update_attrs %{"title" => "Updated Book 1", "description" => "Updated Book description"}

    setup do
      %{user: AccountsFixtures.user_fixture()}
    end

    test "list books/0 returns all books", %{user: user} do
      _book = BooksFixtures.book_fixture(user, @valid_attrs)
      assert Books.list_books()
    end

    test "get_book!/1 returns the book with given id", %{user: user} do
      book = BooksFixtures.book_fixture(user, @valid_attrs)
      assert Books.get_book!(book.id)
      assert book.title == "Book 1"
    end

    test "get_book/1 returns the book with given id", %{user: user} do
      book = BooksFixtures.book_fixture(user, @valid_attrs)
      assert Books.get_book(book.id)
      assert book.title == "Book 1"
    end

    test "get_book/1 refute with invalid id" do
      refute Books.get_book(1)
    end

    test "create_book/2 with valid params", %{user: user} do
      assert {:ok, %Book{} = book} = Books.create_book(user, @valid_attrs)
      assert book.title == "Book 1"
      assert book.description == "Book description"
      assert book.published == 2000
      assert book.isbn == "111-111-111"
    end

    test "create_book/2 with invalid params returns error changeset", %{user: user} do
      assert {:error, %Ecto.Changeset{}} = Books.create_book(user, @invalid_attrs)
    end

    test "update/2 updates with valid params", %{user: user} do
      book = BooksFixtures.book_fixture(user, @valid_attrs)
      assert {:ok, %Book{} = book} = Books.update_book(book, @update_attrs)
      assert book.title == "Updated Book 1"
      assert book.description == "Updated Book description"
    end

    test "update/2 with invalid params returns error changeset", %{user: user} do
      book = BooksFixtures.book_fixture(user, @valid_attrs)
      assert {:error, %Ecto.Changeset{}} = Books.update_book(book, @invalid_attrs)
    end

    test "delete/1 with valid param delete book", %{user: user} do
      book = BooksFixtures.book_fixture(user, @valid_attrs)
      assert {:ok, %Book{} = book} = Books.delete_book(book)
      assert_raise Ecto.NoResultsError, fn -> Books.get_book!(book.id) end
    end
  end
end
