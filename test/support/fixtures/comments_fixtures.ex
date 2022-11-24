defmodule Bookshare.CommentsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Bookshare.Comments` context.
  """

  @doc """
  Generate a review.
  """
  def review_fixture(user, attrs \\ %{}) do
    {:ok, review} = Bookshare.Comments.create_review(user, attrs)

    review
  end
end
