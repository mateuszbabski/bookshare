defmodule BookshareWeb.ResponseControllerTest do
  use BookshareWeb.ConnCase

  import Bookshare.Factory

  alias Bookshare.CommentsFixtures
  alias Bookshare.AccountsFixtures

  @create_review_attrs %{
    rating: "3.5",
    text: "some review",
    review_author_id: 1000
  }

  @reviewed_user %{id: 1, email: "reviewed_user@example.com", password: nil, is_confirmed: true, hash_password: "hash_password"}
  @response_author %{id: 2, email: "response_author@example.com", password: nil, is_confirmed: true, hash_password: "hash_password"}
  @invalid_response_params %{}
  @valid_response_params %{text: "response text"}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  def fixture(:user) do
    insert(:user, email: "test0@test0.local", password: "test0000", is_confirmed: true)
  end

  def create_user(_) do
    %{user: fixture(:user)}
  end

  describe "create response" do
    setup [:create_user]

    test "raises unauthorized when reponse author is not review creator or reviewed user", %{conn: conn, user: user} do
      token = Bookshare.Auth.generate_user_session_token(user)
      conn = conn |> put_req_header("authorization", "Token #{token}")

      review = create_review(@create_review_attrs)

      conn = post(conn, Routes.response_path(conn, :add_response, review.id), response: @valid_response_params)
      assert json_response(conn, 403)
      assert json_response(conn, 403)["message"] == "You can't leave response to review that isn't about you or you aren't its author"
    end

    test "render response when user and data are valid", %{conn: conn, user: user} do
      token = Bookshare.Auth.generate_user_session_token(user)
      conn = conn |> put_req_header("authorization", "Token #{token}")

      valid_review_attrs = %{rating: "4", text: "review", review_author_id: user.id}

      review = create_review(valid_review_attrs)

      conn = post(conn, Routes.response_path(conn, :add_response, review.id), response: @valid_response_params)
      assert json_response(conn, 201)
      assert json_response(conn, 201)["text"] == "response text"
      assert json_response(conn, 201)["review"] == review.id
      assert json_response(conn, 201)["response_author_id"] == user.id
    end

    test "raises forbidden when user is invalid", %{conn: conn, user: user} do
      token = Bookshare.Auth.generate_user_session_token(user)
      conn = conn |> put_req_header("authorization", "Token #{token}")

      valid_review_attrs = %{rating: "4", text: "review", review_author_id: user.id + 1}

      review = create_review(valid_review_attrs)

      conn = post(conn, Routes.response_path(conn, :add_response, review.id), response: @valid_response_params)
      assert json_response(conn, 403)
      assert json_response(conn, 403)["message"] == "You can't leave response to review that isn't about you or you aren't its author"
    end

    # test "returns ecto changeset when data is invalid", %{conn: conn, user: user} do
    #   token = Bookshare.Auth.generate_user_session_token(user)
    #   conn = conn |> put_req_header("authorization", "Token #{token}")

    #   valid_review_attrs = %{rating: "4", text: "review", review_author_id: user.id}

    #   review = create_review(valid_review_attrs)

    #   conn = post(conn, Routes.response_path(conn, :add_response, review.id), response: @invalid_response_params)
    #   assert json_response(conn, 422)["errors"] != %{}
    # end
  end

  describe "delete response" do
    setup [:create_user]

    test "deletes chosen review", %{conn: conn, user: user} do
      token = Bookshare.Auth.generate_user_session_token(user)
      conn = conn |> put_req_header("authorization", "Token #{token}")

      valid_review_attrs = %{rating: "4", text: "review", review_author_id: user.id}

      review = create_review(valid_review_attrs)
      {:ok, %Bookshare.Comments.Response{} = response} = Bookshare.Comments.create_response(user, review, @valid_response_params)

      conn = delete(conn, Routes.response_path(conn, :delete, response))
      assert response(conn, 204)
    end
  end

  defp create_review(attrs) do
    reviewed_user = AccountsFixtures.user_fixture()
    review = CommentsFixtures.review_fixture(reviewed_user, attrs)
    review
  end
end
