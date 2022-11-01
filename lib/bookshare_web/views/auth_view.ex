defmodule BookshareWeb.AuthView do
  use BookshareWeb, :view
  alias BookshareWeb.AuthView

def render("index.json", %{user: user}) do
    %{data: render_one(user, AuthView, "privileged_user.json", as: :user)}
  end

  def render("update.json", %{user: user}) do
    %{data: render_one(user, AuthView, "privileged_user.json", as: :user)}
  end

  def render("login.json", %{:user => user, :token => token}) do
    %{
      data: %{
        user: render_one(user, AuthView, "privileged_user.json", as: :user)
      },
      token: token
    }
  end

  def render("register.json", %{:user => user}) do
    %{
      data: render_one(user, AuthView, "privileged_user.json", as: :user)
    }
  end

  def render("forgot_password.json", %{encoded_token: encoded_token}) do
    %{
      messages: ["If the account exists, we've sent an email."],
      encoded_token: encoded_token
    }
  end

    def render("forgot_password.json", _params) do
    %{
      messages: ["If the account exists, we've sent an email."]
    }
  end

  def render("reset_password.json", _params) do
    %{
      messages: ["Successfully reset password."]
    }
  end

  def render("confirm_email.json", _params) do
    %{
      messages: ["Successfully confirmed email."]
    }
  end

  def render("user.json", %{user: user}) do
    %{
      username: user.username
    }
  end

  def render("privileged_user.json", %{user: user}) do
    %{
      id: user.id,
      email: user.email
    }
  end

  def render("logout.json", _params) do
    %{
      messages: ["Successfully logout"]
    }
  end
end
