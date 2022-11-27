defmodule Bookshare.Comments.CommentNotifier do
  use Phoenix.Swoosh,
    view: BookshareWeb.EmailView

  import Swoosh.Email

  alias Bookshare.Mailer

  def send_notification_about_new_review(reviewed_user, review_author, review) do
    url = "/reviews/#{review.id}"

    email =
    new()
    |> to(reviewed_user.email)
    |> from({"BookShare", "admin@bookshare.com"})
    |> subject("You have new review!")
    |> render_body("new_review.html", %{reviewed_user: reviewed_user, review_author: review_author, review: review, url: url})

    Mailer.deliver(email)
  end
end
