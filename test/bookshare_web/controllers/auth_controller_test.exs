defmodule BookshareWeb.AuthControllerTest do
  use BookshareWeb.ConnCase, async: true

  import Swoosh.TestAssertions
  import Bookshare.Factory

  alias Bookshare.Accounts
  alias Bookshare.Auth
  alias Bookshare.Repo


  @correct_credentials %{email: "test0@test0.local", password: "test0000"}
  @incorrect_credentials %{email: "incorrect", password: "incorrect"}

  def fixture(:user) do
    insert(:user, email: "test0@test0.local", password: "test0000", is_confirmed: true)
  end

  def create_user(_) do
    %{user: fixture(:user)}
  end

  def create_register_params(_) do
    %{
      register_params: %{
        user: Map.put(params_for(:user, %{}), :password, "test1234")
      }
    }
  end

  describe "login view" do
    setup [:create_user]

    test "returns a token on correct credentials", %{conn: conn} do
      conn = post(conn, Routes.auth_path(conn, :login), @correct_credentials)
      assert %{"token" => _token} = json_response(conn, 200)
    end

    test "fails on incorrect credentials", %{conn: conn} do
      conn = post(conn, Routes.auth_path(conn, :login), @incorrect_credentials)
      assert response(conn, 400)
    end
  end

  describe "user view" do
    setup [:create_user]

    test "returns privileged user", %{conn: conn, user: user} do
      token = Auth.generate_user_session_token(user)
      conn = conn |> put_req_header("authorization", "Token #{token}")
      conn = get(conn, Routes.auth_path(conn, :index))
      assert json_response(conn, 200)
    end

    test "allows only logged in user", %{conn: conn} do
      conn = get(conn, Routes.auth_path(conn, :index))
      assert json_response(conn, 401)
    end
  end

  describe "register view" do
    setup [:create_user, :create_register_params]

    test "allows only unauthenticated user", %{conn: conn, user: user} do
      token = Auth.generate_user_session_token(user)
      conn = conn |> put_req_header("authorization", "Token #{token}")
      conn = post(conn, Routes.auth_path(conn, :register))
      assert json_response(conn, 401)
    end

    test "register a new user", %{conn: conn, register_params: register_params} do
      conn = post(
              conn,
              Routes.auth_path(conn, :register),
              register_params
              )

      assert json_response(conn, 201)
      assert Auth.get_user!(json_response(conn, 201)["data"]["id"])
    end
  end

  describe "forgot password flow" do
    setup [:create_user]

    test "sends forgot password email", %{conn: conn, user: user} do
      conn = post(
              conn,
              Routes.auth_path(conn, :forgot_password),
              %{email: user.email}
              )

      user_email = user.email
      assert json_response(conn, 200)
      assert_email_sent(to: user_email)
    end

    test "doesnt divulge user existence", %{conn: conn, user: user} do
      conn_real = post(conn, Routes.auth_path(conn, :forgot_password), %{email: user.email})
      conn_fake = post(conn, Routes.auth_path(conn, :forgot_password), %{email: "fake@email.com"})
      assert json_response(conn_real, 200)["messages"] == json_response(conn_fake, 200)["messages"]
    end

    test "resets password successfully", %{conn: conn, user: user} do
      new_password = "newpassword"
      {token, user_token} = Accounts.UserToken.build_email_token(user, "reset_password")
      Repo.insert!(user_token)

      conn = post(
        conn,
        Routes.auth_path(conn, :reset_password),
          %{
          token: token,
          password: new_password,
          password_confirmation: new_password
          })

      assert json_response(conn, 200)
      assert Auth.get_user_by_email_and_password(user.email, new_password)
    end

    test "reset password rejects invalid tokens", %{conn: conn} do
      conn = post(
        conn,
        Routes.auth_path(conn, :reset_password),
        %{
          token: "fake_token",
          password: "new_password",
          password_confirmation: "new_password"
        })

      assert json_response(conn, 401)
    end
  end
end
