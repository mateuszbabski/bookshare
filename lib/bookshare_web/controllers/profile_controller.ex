defmodule BookshareWeb.ProfileController do
  use BookshareWeb, :controller

  alias Bookshare.Accounts
  alias Bookshare.Accounts.Profile

  action_fallback BookshareWeb.FallbackController

  # def index(conn, _params) do
  #   profiles = Accounts.list_profiles()
  #   render(conn, "index.json", profiles: profiles)
  # end

  def create(conn, profile_params) do
    user = conn.assigns.current_user

    if Accounts.check_if_user_has_profile(user.id) do
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
  # def create(conn, profile_params) do
  #   user = conn.assigns.current_user

  #   with {:ok, %Profile{} = profile} <- Accounts.create_profile(user, profile_params) do
  #     conn
  #     |> put_status(:created)
  #     |> json(%{username: profile.username, message: "Profile created"})
  #   end

  # def show(conn, %{"user_id" => user_id}) do
  #   profile = Accounts.get_profile!(user_id)
  #   render(conn, "show.json", profile: profile)
  # end

  # def update(conn, %{"id" => id, "profile" => profile_params}) do
  #   profile = Accounts.get_profile!(id)

  #   with {:ok, %Profile{} = profile} <- Accounts.update_profile(profile, profile_params) do
  #     render(conn, "show.json", profile: profile)
  #   end
  # end

end
end
