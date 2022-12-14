defmodule BookshareWeb.ReviewView do
  use BookshareWeb, :view
  alias BookshareWeb.ReviewView

  def render("index.json", %{reviews: reviews}) do
    %{data: render_many(reviews, ReviewView, "review_list.json")}
  end

  def render("show.json", %{review: review}) do
    %{data: render_one(review, ReviewView, "review.json")}
  end

  def render("review_list.json", %{review: review}) do
    %{
      id: review.id,
      text: review.text,
      rating: review.rating,
      review_author_id: review.review_author_id,
      inserted_at: review.inserted_at
    }
  end

  def render("created_review.json", %{review: review}) do
    %{
      id: review.id,
      text: review.text,
      rating: review.rating,
      review_author_id: review.review_author_id,
      user_reviewed: review.user_id,
      inserted_at: review.inserted_at
    }
  end

  def render("review.json", %{review: review}) do
    responses = render_many(review.responses, BookshareWeb.ResponseView, "response.json")
    %{
      id: review.id,
      text: review.text,
      rating: review.rating,
      review_author_id: review.review_author_id,
      user_reviewed: review.user_id,
      inserted_at: review.inserted_at,
      responses: responses
    }
  end
end
