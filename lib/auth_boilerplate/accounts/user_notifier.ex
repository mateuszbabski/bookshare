defmodule AuthBoilerplate.Accounts.UserNotifier do
  use Phoenix.Swoosh,
    view: AuthBoilerplateWeb.EmailView

  alias AuthBoilerplate.Mailer

  #def deliver_reset_password_instructions(user, token) do
  #  new()
  #  |> from("admin@admin.com")
  #  |> to(user.email)
  #  |> subject("Password reset link")
  #  |> render_body("forgot_password.html", %{user: user, token: token})
  #  |> Mailer.deliver()
  #end

  # Delivers the email using the application mailer.
  defp deliver(recipient, subject, body) do
    email =
      new()
      |> to(recipient)
      |> from({"MyApp", "contact@example.com"})
      |> subject(subject)
      |> text_body(body)

    with {:ok, _metadata} <- Mailer.deliver(email) do
      {:ok, email}
    end
  end

  @doc """
  Deliver instructions to reset a user password.
  """
  def deliver_reset_password_instructions(user, url) do
    deliver(user.email, "Reset password instructions", """
    ==============================
    Hi #{user.email},
    You can reset your password by visiting the URL below:
    #{url}
    If you didn't request this change, please ignore this.
    ==============================
    """)
  end



end
