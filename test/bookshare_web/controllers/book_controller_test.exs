defmodule BookshareWeb.BookControllerTest do
  use BookshareWeb.ConnCase

  import Bookshare.Factory

  alias Bookshare.BooksFixtures

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

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  def fixture(:user) do
    insert(:user, email: "test0@test0.local", password: "test0000", is_confirmed: true)
  end

  def create_user(_) do
    %{user: fixture(:user)}
  end

  describe "index" do
    test "lists all books", %{conn: conn} do
      conn = get(conn, Routes.book_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create book" do
    setup [:create_user]

    test "renders valid message when data is valid", %{conn: conn, user: user} do
      token = Bookshare.Auth.generate_user_session_token(user)
      conn = conn |> put_req_header("authorization", "Token #{token}")

      conn = post(conn, Routes.book_path(conn, :create), %{user: user, book: @valid_attrs})
      assert json_response(conn, 201)["message"] == "Book created"
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      token = Bookshare.Auth.generate_user_session_token(user)
      conn = conn |> put_req_header("authorization", "Token #{token}")

      conn = post(conn, Routes.book_path(conn, :create), %{user: user, book: @invalid_attrs})
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders 401 unauthorized when user is not authorized", %{conn: conn, user: user} do
      conn = post(conn, Routes.book_path(conn, :create), %{user: user, book: @valid_attrs})
      assert json_response(conn, 401)
    end
  end

  describe "update book" do
    setup [:create_user]

    test "renders book when data is valid", %{conn: conn, user: user} do
      token = Bookshare.Auth.generate_user_session_token(user)
      conn = conn |> put_req_header("authorization", "Token #{token}")

      book = BooksFixtures.book_fixture(user, @valid_attrs)
      conn = patch(conn, Routes.book_path(conn, :update, book), %{user: user, book: @update_attrs})

      assert json_response(conn, 200)

      conn = get(conn, Routes.book_path(conn, :show, book))
      assert json_response(conn, 200)["data"]["id"] == book.id
      assert json_response(conn, 200)["data"]["title"] == "Updated Book 1"
      assert json_response(conn, 200)["data"]["description"] == "Updated Book description"
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      token = Bookshare.Auth.generate_user_session_token(user)
      conn = conn |> put_req_header("authorization", "Token #{token}")

      book = BooksFixtures.book_fixture(user, @valid_attrs)
      conn = patch(conn, Routes.book_path(conn, :update, book), book: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete book" do
    setup [:create_user]

    test "deletes chosen book", %{conn: conn, user: user} do
      token = Bookshare.Auth.generate_user_session_token(user)
      conn = conn |> put_req_header("authorization", "Token #{token}")

      book = BooksFixtures.book_fixture(user, @valid_attrs)
      conn = delete(conn, Routes.book_path(conn, :delete, book))
      assert response(conn, 204)
    end
  end

  describe "show book" do
    setup [:create_user]

    test "shows book with valid id", %{conn: conn, user: user} do
      token = Bookshare.Auth.generate_user_session_token(user)
      conn = conn |> put_req_header("authorization", "Token #{token}")

      book = BooksFixtures.book_fixture(user, @valid_attrs)
      conn = get(conn, Routes.book_path(conn, :show, book.id))
      assert json_response(conn, 200)
      assert json_response(conn, 200)["data"]["id"] == book.id
      assert json_response(conn, 200)["data"]["title"] == book.title
    end

    test "show not found message when book doesnt exist", %{conn: conn} do
      conn = get(conn, Routes.book_path(conn, :show, 1))
      assert json_response(conn, 404)
      assert json_response(conn, 404)["message"] == "Book not found"
    end
  end
end
