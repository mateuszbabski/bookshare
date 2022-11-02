defmodule Bookshare.Accounts.UserNotifier do
  use Phoenix.Swoosh,
    view: BookshareWeb.EmailView

  import Swoosh.Email

  alias Bookshare.Mailer

  def send_forgot_password_email(user, token) do
    url = "/auth/reset_password?token=#{token}"

    email =
    new()
    |> to(user.email)
    |> from({"BookShare", "admin@bookshare.com"})
    |> subject("BookShare - Reset Password")
    |> render_body("forgot_password.html", %{email: user.email, url: url, token: token})

    Mailer.deliver(email)
  end

  def send_confirmation_email(user, token) do
    url = "/auth/confirm?token=#{token}"

    email =
    new()
    |> to(user.email)
    |> from({"BookShare", "admin@bookshare.com"})
    |> subject("BookShare - Confirm account")
    |> render_body("confirm_account.html", %{email: user.email, url: url, token: token})

    Mailer.deliver(email)
  end
end
