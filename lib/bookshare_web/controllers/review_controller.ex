defmodule BookshareWeb.ReviewController do
  use BookshareWeb, :controller

  alias Bookshare.Auth
  alias Bookshare.Comments
  alias Bookshare.Comments.Review

  action_fallback BookshareWeb.FallbackController

#   def index(conn, _params) do
#     reviews = Comments.list_reviews()
#     render(conn, "index.json", reviews: reviews)
#   end

  def add_review(conn, %{"id" => id, "review" => review_params}) do
    reviewed_user = Auth.get_user!(id)
    review_author = conn.assigns.current_user
    review_params = Map.put(review_params, "review_author_id", review_author.id)

    with {:ok, %Review{} = review} <- Comments.create_review(reviewed_user, review_params) do
      conn
      |> put_status(:created)
      |> render("show.json", review: review)
    end
  end

#   def show(conn, %{"id" => id}) do
#     review = Comments.get_review!(id)
#     render(conn, "show.json", review: review)
#   end

#   def update(conn, %{"id" => id, "review" => review_params}) do
#     review = Comments.get_review!(id)

#     with {:ok, %Review{} = review} <- Comments.update_review(review, review_params) do
#       render(conn, "show.json", review: review)
#     end
#   end

#   def delete(conn, %{"id" => id}) do
#     review = Comments.get_review!(id)

#     with {:ok, %Review{}} <- Comments.delete_review(review) do
#       send_resp(conn, :no_content, "")
#     end
#   end
end
