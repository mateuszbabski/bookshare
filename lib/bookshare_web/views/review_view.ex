defmodule BookshareWeb.ReviewView do
  use BookshareWeb, :view
  alias BookshareWeb.ReviewView

  def render("index.json", %{reviews: reviews}) do
    %{data: render_many(reviews, ReviewView, "review.json")}
  end

  def render("show.json", %{review: review}) do
    %{data: render_one(review, ReviewView, "review.json")}
  end

  def render("review.json", %{review: review}) do
    %{
      id: review.id,
      text: review.text,
      rating: review.rating
      # author_id: review.review_author_id,
      # user_reviewed: review.user_id
    }
  end
end
