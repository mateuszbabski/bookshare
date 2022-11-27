defmodule BookshareWeb.AuthController do
  use BookshareWeb, :controller

  import BookshareWeb.Auth

  alias Bookshare.Auth

  action_fallback BookshareWeb.FallbackController

  plug :require_authenticated_user when action in [:index, :update, :logout]
  plug :require_guest_user when action in [:login, :register]
  plug :get_user_by_reset_password_token when action in [:reset_password]

  def index(conn, _) do
    render(conn, "index.json", user: conn.assigns[:current_user])
  end

  def login(conn, %{"email" => email, "password" => password}) do
    if user = Auth.get_user_by_email_and_password(email, password) do
      if user.is_confirmed do
        token = get_token(user)
        conn
        |> put_status(:ok)
        |> render("login.json", user: user, token: token)
      else
        {:error, :unauthorized, "Account not confirmed"}
      end
    else
      {:error, :bad_request, "Invalid email or password"}
    end
  end

  def register(conn, %{"user" => params}) do
    with {:ok, user} <- Auth.register_user(params),
         {:ok, encoded_token} <- Auth.deliver_confirmation_instructions(user) do

      conn
      |> put_status(:created)
      |> render("register.json", user: user, encoded_token: encoded_token)
    else
      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def confirm_email(conn, %{"token" => token}) do
    case Auth.confirm_user(token) do
      {:ok, _} -> render(conn, "confirm_email.json")

      :error -> {:error, :bad_request, "Invalid token"}
    end
  end

  def forgot_password(conn, %{"email" => email}) do
    if user = Auth.get_user_by_email(email) do
      {:ok, encoded_token} = Auth.deliver_user_reset_password_instructions(user)
      render(conn, "forgot_password.json", encoded_token: encoded_token)
    else
      render(conn, "forgot_password.json")
    end
  end

  def reset_password(conn, %{ "password" => password, "password_confirmation" => password_confirmation}) do
      with {:ok, _user} <- Auth.reset_user_password(conn.assigns.user, %{
                            password: password,
                            password_confirmation: password_confirmation}) do
        render(conn, "reset_password.json")
      else
        {:error, changeset} -> {:error, changeset}
      end
  end

  def logout(conn, _params) do
    delete_session_tokens_by_user(conn)

    render(conn, "logout.json")
  end

  defp get_user_by_reset_password_token(conn, _opts) do
    if conn.params["token"] do
      %{"token" => token} = conn.params

      if user = Auth.get_user_by_reset_password_token(token) do
        conn |> assign(:user, user) |> assign(:token, token)
      else
        conn
        |> put_status(401)
        |> put_view(BookshareWeb.ErrorView)
        |> render(:"401")
        |> halt()
      end
    else
      conn
      |> put_status(401)
      |> put_view(BookshareWeb.ErrorView)
      |> render(:"401")
      |> halt()
    end
  end
end
