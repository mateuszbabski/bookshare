defmodule BookshareWeb.ProfileController do
  use BookshareWeb, :controller

  alias Bookshare.Accounts
  alias Bookshare.Accounts.Profile

  action_fallback BookshareWeb.FallbackController

  def index(conn, _params) do
    profiles = Accounts.list_profiles()
    render(conn, "index.json", profiles: profiles)
  end

  def show(conn, %{"id" => id}) do
    profile = Accounts.get_profile!(id)
    render(conn, "show.json", profile: profile)
  end

  # def show_by_email(conn, email) do
  #   profile = Accounts.get_profile_by_user_email(email)
  #   render(conn, "show_by_email.json", profile: profile, email: email)
  # end

  def show_me(conn, _params) do
    user = conn.assigns.current_user
    profile = Accounts.get_profile_by_user_id(user.id)
    render(conn, "show_me.json", profile: profile)
  end

  def create(conn, profile_params) do
    user = conn.assigns.current_user

   if Accounts.get_profile_by_user_id(user.id) do
      conn
      |> put_status(:forbidden)
      |> json(%{message: "You are allowed to have only one profile"})
    else
      with {:ok, %Profile{} = profile} <- Accounts.create_profile(user, profile_params) do
        conn
        |> put_status(:created)
        |> json(%{username: profile.username, message: "Profile created"})
      end
    end
  end

  def update(conn, profile_params) do
    user = conn.assigns.current_user

    with %Profile{} = profile <- Accounts.get_profile_by_user_id(user.id),
         {:ok, %Profile{}}    <- Accounts.update_profile(profile, profile_params) do
      render(conn, "profile_updated.json")
    else
      {:error, changeset} -> {:error, changeset}

      nil -> json(conn, %{message: "User does not have profile yet"})
    end
  end
end
