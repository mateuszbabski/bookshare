defmodule Bookshare.AuthTest do
  use BookshareWeb.ConnCase, async: true

  import Bookshare.Factory
  alias BookshareWeb.Auth

  def fixture(:user) do
    insert(:user, email: "test0@test0.local", password: "test0000")
  end

  def create_user(_) do
    %{user: fixture(:user)}
  end

  describe "fetch_current_user/2" do
    setup [:create_user]

    test "fetches user for valid token", %{conn: conn, user: user} do
      token = Auth.get_token(user)

      conn =
        conn
        |> put_req_header("authorization", "Token #{token}")
        |> Auth.fetch_current_user([])

    assert conn.assigns.current_user.id == user.id
    end

    test "sets current_user to nil on invalid token" do
      fake_token =
        build_conn()
        |> put_req_header("authorization", "Token fake_token")
        |> Auth.fetch_current_user([])

      missing_token =
        build_conn()
        |> put_req_header("authorization", "Token fake_token")
        |> Auth.fetch_current_user([])

      assert fake_token.assigns.current_user == nil
      assert missing_token.assigns.current_user == nil
    end
  end

  describe "require guest user/2" do
    setup [:create_user]

    test "rejects authenticated user", %{conn: conn, user: user} do
      conn =
        conn
        |> bypass_through(BookshareWeb.Router, :api)
        |> get("/api/auth/")
        |> assign(:current_user, user)
        |> Auth.require_guest_user([])

    assert conn.halted
    end

    test "accepts guest user", %{conn: conn} do
      conn =
        conn
        |> bypass_through(BookshareWeb.Router, :api)
        |> get("/api/auth/")
        |> Auth.require_guest_user([])

    refute conn.halted
    end
  end

  describe "require_authenticated_user/2" do
    setup [:create_user]

    test "rejects guest user", %{conn: conn} do
      conn =
        conn
        |> bypass_through(BookshareWeb.Router, :api)
        |> get("/api/auth/")
        |> Auth.require_authenticated_user([])

    assert conn.halted
    end

    test "accepts authenticated user", %{conn: conn, user: user} do
      conn =
        conn
        |> bypass_through(BookshareWeb.Router, :api)
        |> get("/api/auth/")
        |> assign(:current_user, user)
        |> Auth.require_authenticated_user([])

    refute conn.halted
    end
  end
end
