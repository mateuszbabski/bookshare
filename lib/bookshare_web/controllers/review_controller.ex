defmodule BookshareWeb.ReviewController do
  use BookshareWeb, :controller

  alias Bookshare.Auth
  alias Bookshare.Comments
  alias Bookshare.Comments.Review
  alias Bookshare.Comments.CommentNotifier

  action_fallback BookshareWeb.FallbackController

  def index(conn, %{"id" => id}) do
    reviews = Comments.list_reviews(id)
    render(conn, "index.json", reviews: reviews)
  end

  def add_review(conn, %{"id" => id, "review" => review_params}) do
    review_author = conn.assigns.current_user
    review_params = Map.put(review_params, "review_author_id", review_author.id)

    with  reviewed_user                 <- Auth.get_user!(id),
          nil                           <- Comments.check_if_user_already_left_review(reviewed_user.id, review_author.id),
          {:ok, %Review{} = review}     <- Comments.create_review(reviewed_user, review_params) do
      CommentNotifier.send_notification_about_new_review(reviewed_user, review_author, review)
      conn
      |> put_status(:created)
      |> render("review.json", review: review)
    else
      false -> conn
               |> put_status(:forbidden)
               |> json(%{message: "You can't leave review for yourself"})

      true -> conn
              |> put_status(:forbidden)
              |> json(%{message: "You've already left a review for this user"})

      {:error, %Ecto.Changeset{} = changeset} -> {:error, changeset}
    end
  end

  def show_review(conn, %{"id" => id}) do
    review = Comments.get_review(id)
    render(conn, "show.json", review: review)
  end

  def update_review(conn, %{"id" => id, "review" => review_params}) do
    review_author = conn.assigns.current_user

    with  review                   <- Comments.get_review!(id),
          true                     <- review.review_author_id == review_author.id,
         {:ok, %Review{} = review} <- Comments.update_review(review, review_params) do
      render(conn, "show.json", review: review)
    else
      {:error, changeset} -> {:error, changeset}

      false -> conn
                |> put_status(:unauthorized)
                |> json(%{message: "You cant update this review"})
    end
  end

  def delete(conn, %{"id" => id}) do
    review_author = conn.assigns.current_user

    with review           <- Comments.get_review!(id),
         true             <- review.review_author_id == review_author.id,
         {:ok, %Review{}} <- Comments.delete_review(review) do
      send_resp(conn, :no_content, "")
    end
  end
end
