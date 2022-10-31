defmodule BookshareWeb.AuthController do
  use BookshareWeb, :controller

  alias Bookshare.Auth

  import BookshareWeb.Auth

  action_fallback BookshareWeb.FallbackController

  plug :require_authenticated_user when action in [:index, :update]
  plug :require_guest_user when action in [:login, :register]
  plug :get_user_by_reset_password_token when action in [:reset_password]

  def index(conn, _) do
    render(conn, "index.json", user: conn.assigns[:current_user])
  end

  def login(conn, %{"email" => email, "password" => password}) do
    if user = Auth.get_user_by_email_and_password(email, password) do
      token = get_token(user)
      conn
      |> put_status(:ok)
      |> render("login.json", user: user, token: token)
    else
      {:error, :bad_request, "invalid email or password"}
    end
  end

  def register(conn, %{"user" => params}) do
    with {:ok, user} <- Auth.register_user(params) do
        conn
        |> put_status(:created)
        |> render("register.json", user: user)
      else
        {:error, changeset} ->
          {:error, changeset}
    end
  end

  def forgot_password(conn, %{"email" => email}) do
    if user = Auth.get_user_by_email(email) do
      # token url
      Auth.deliver_user_reset_password_instructions(user, fn token -> "#{token}" end)
    end

    render(conn, "forgot_password.json")
  end

  def reset_password(conn, %{
        "password" => password,
        "password_confirmation" => password_confirmation
        }) do
      Auth.reset_user_password(conn.assigns.user, %{
        password: password,
        password_confirmation: password_confirmation})

      render(conn, "reset_password.json")
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
