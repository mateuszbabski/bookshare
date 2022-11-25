defmodule BookshareWeb.ReviewControllerTest do
  use BookshareWeb.ConnCase

  import Bookshare.Factory

  alias Bookshare.CommentsFixtures
  alias Bookshare.AccountsFixtures

  @create_attrs %{
    rating: "3.5",
    text: "some review",
    review_author_id: 1000
  }
  @update_attrs %{
    rating: "4.5",
    text: "some updated review"
  }
  @invalid_attrs %{rating: nil, text: nil}

  @reviewed_user %{id: 1, email: "reviewed_user@example.com", password: nil, is_confirmed: true, hash_password: "hash_password"}

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
    test "lists all reviews", %{conn: conn} do
      conn = get(conn, Routes.review_path(conn, :index, @reviewed_user.id))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create review" do
    setup [:create_user]

    test "renders review when data is valid", %{conn: conn, user: user} do
      token = Bookshare.Auth.generate_user_session_token(user)
      conn = conn |> put_req_header("authorization", "Token #{token}")

      reviewed_user = AccountsFixtures.user_fixture()
      valid_attrs = %{rating: "3.5", text: "review", review_author_id: user.id}

      conn = post(conn, Routes.review_path(conn, :add_review, reviewed_user.id), review: valid_attrs)
      assert json_response(conn, 201)
      assert json_response(conn, 201)["rating"] == "3.5"
      assert json_response(conn, 201)["text"] == "review"
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      token = Bookshare.Auth.generate_user_session_token(user)
      conn = conn |> put_req_header("authorization", "Token #{token}")
      reviewed_user = AccountsFixtures.user_fixture()

      conn = post(conn, Routes.review_path(conn, :add_review, reviewed_user.id), review: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders unauthorized when user is not logged id", %{conn: conn} do
      reviewed_user = AccountsFixtures.user_fixture()
      conn = post(conn, Routes.review_path(conn, :add_review, reviewed_user.id), review: @create_attrs)
      assert json_response(conn, 401)["errors"] != %{}
    end
  end

  describe "update review" do
    setup [:create_user]

    test "renders review when data is valid", %{conn: conn, user: user} do
      token = Bookshare.Auth.generate_user_session_token(user)
      conn = conn |> put_req_header("authorization", "Token #{token}")
      valid_attrs = %{rating: "3.5", text: "review", review_author_id: user.id}

      review = create_review(valid_attrs)

      conn = patch(conn, Routes.review_path(conn, :update_review, review), review: @update_attrs)
      assert json_response(conn, 200)["data"]
      assert %{
               "rating" => "4.5",
               "text" => "some updated review"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      token = Bookshare.Auth.generate_user_session_token(user)
      conn = conn |> put_req_header("authorization", "Token #{token}")

      valid_attrs = %{rating: "3.5", text: "review", review_author_id: user.id}
      review = create_review(valid_attrs)

      conn = patch(conn, Routes.review_path(conn, :update_review, review), review: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders unauthorized when user is not review author", %{conn: conn, user: user} do
      token = Bookshare.Auth.generate_user_session_token(user)
      conn = conn |> put_req_header("authorization", "Token #{token}")
      valid_attrs = %{rating: "3.5", text: "review", review_author_id: 1000}
      review = create_review(valid_attrs)

      conn = patch(conn, Routes.review_path(conn, :update_review, review), review: @invalid_attrs)
      assert json_response(conn, 401)["errors"] != %{}
    end
  end

  describe "delete review" do
    setup [:create_user]

    test "deletes chosen review", %{conn: conn, user: user} do
      token = Bookshare.Auth.generate_user_session_token(user)
      conn = conn |> put_req_header("authorization", "Token #{token}")

      valid_attrs = %{rating: "3.5", text: "review", review_author_id: user.id}
      review = create_review(valid_attrs)

      conn = delete(conn, Routes.review_path(conn, :delete, review))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.review_path(conn, :show_review, review))
      end
    end
  end

  defp create_review(attrs) do
    reviewed_user = AccountsFixtures.user_fixture()
    review = CommentsFixtures.review_fixture(reviewed_user, attrs)
    review
  end
end
