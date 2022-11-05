defmodule BookshareWeb.ProfileView do
  use BookshareWeb, :view
  alias BookshareWeb.ProfileView

  def render("index.json", %{profiles: profiles}) do
    %{data: render_many(profiles, ProfileView, "profile.json")}
  end

  def render("show.json", %{profile: profile}) do
    %{data: render_one(profile, ProfileView, "profile.json")}
  end

  def render("profile.json", %{profile: profile}) do
    %{
      user_id: profile.user_id,
      username: profile.username
    }
  end

  def render("profile_updated.json", _params) do
    %{
      message: "User's profile updated"
    }
  end
end
