defmodule BookshareWeb.ProfileControllerTest do
  use BookshareWeb.ConnCase

  alias Bookshare.AccountsFixtures
  alias Bookshare.Auth

  import Bookshare.Factory

  @create_attrs %{
    username: "Username"
  }
  @update_attrs %{
    username: "UpdatedUsername"
  }
  @invalid_attrs %{username: nil}

  def fixture(:user) do
    insert(:user, email: "test0@test0.local", password: "test0000", is_confirmed: true)
  end

  def create_user(_) do
    %{user: fixture(:user)}
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all profiles", %{conn: conn} do
      conn = get(conn, Routes.profile_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create profile" do
    setup [:create_user]

    test "creates profile when data is valid", %{conn: conn, user: user} do
      token = Bookshare.Auth.generate_user_session_token(user)
      conn = conn |> put_req_header("authorization", "Token #{token}")

      conn = post(conn, Routes.profile_path(conn, :create), @create_attrs)
      assert json_response(conn, 201)
      assert json_response(conn, 201)["message"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      token = Bookshare.Auth.generate_user_session_token(user)
      conn = conn |> put_req_header("authorization", "Token #{token}")

      conn = post(conn, Routes.profile_path(conn, :create), @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders errors when user is unauthorized", %{conn: conn} do
      conn = post(conn, Routes.profile_path(conn, :create), @invalid_attrs)
      assert json_response(conn, 401)["errors"] != %{}
    end
  end

  describe "update profile" do
    setup [:create_user]

    test "renders profile when data is valid", %{conn: conn, user: user} do
      token = Bookshare.Auth.generate_user_session_token(user)
      conn = conn |> put_req_header("authorization", "Token #{token}")
      profile = AccountsFixtures.profile_fixture(user)

      conn = patch(conn, Routes.profile_path(conn, :update), @update_attrs)
      assert json_response(conn, 200)["message"] == "User's profile updated"

      conn = get(conn, Routes.profile_path(conn, :show, profile.id))
      assert json_response(conn, 200)["username"] == "UpdatedUsername"
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      token = Bookshare.Auth.generate_user_session_token(user)
      conn = conn |> put_req_header("authorization", "Token #{token}")
      _profile = AccountsFixtures.profile_fixture(user)

      conn = patch(conn, Routes.profile_path(conn, :update), @invalid_attrs)
      assert json_response(conn, 422)["errors"]
      assert json_response(conn, 422)["errors"]["username"] == ["can't be blank"]
    end
  end

  describe "show profile" do
    setup [:create_user]

    test "renders profile when data is valid", %{conn: conn, user: user} do
      profile = AccountsFixtures.profile_fixture(user)
      conn = get(conn, Routes.profile_path(conn, :show, profile.id))
      assert json_response(conn, 200)
      assert json_response(conn, 200)["username"] == profile.username
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = get(conn, Routes.profile_path(conn, :show, 1))
      assert json_response(conn, 404)
      assert json_response(conn, 404)["message"] == "Profile not found"
    end
  end

  describe "show_me profile" do
    setup [:create_user]

    test "renders profile when data is valid", %{conn: conn, user: user} do
      token = Auth.generate_user_session_token(user)
      conn = conn |> put_req_header("authorization", "Token #{token}")

      profile = AccountsFixtures.profile_fixture(user)

      conn = get(conn, Routes.profile_path(conn, :show_me))
      assert json_response(conn, 200)
      assert json_response(conn, 200)["username"] == profile.username
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      _profile = AccountsFixtures.profile_fixture(user)
      conn = get(conn, Routes.profile_path(conn, :show_me))

      assert json_response(conn, 401)
      assert json_response(conn, 401)["errors"]["detail"] == "Unauthorized"
    end
  end
end
