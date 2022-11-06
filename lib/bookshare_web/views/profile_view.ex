defmodule BookshareWeb.ProfileView do
  use BookshareWeb, :view
  alias BookshareWeb.ProfileView

  def render("index.json", %{profiles: profiles}) do
    %{data: render_many(profiles, ProfileView, "profile.json")}
  end

  def render("show.json", %{profile: profile}) do
    %{
      user_id: profile.user_id,
      username: profile.username
    }
  end

  def render("show_me.json", %{profile: profile}) do
    %{
      user_id: profile.user_id,
      username: profile.username,
      first_name: profile.first_name,
      last_name: profile.last_name,
      phone_number: profile.phone_number,
      country: profile.country,
      city: profile.city,
      street: profile.street,
      postal_code: profile.postal_code
    }
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
