# defmodule Bookshare.CommentsFixtures do
#   @moduledoc """
#   This module defines test helpers for creating
#   entities via the `Bookshare.Comments` context.
#   """

#   @doc """
#   Generate a review.
#   """
#   def review_fixture(attrs \\ %{}) do
#     {:ok, review} =
#       attrs
#       |> Enum.into(%{
#         rating: "120.5",
#         text: "some text"
#       })
#       |> Bookshare.Comments.create_review()

#     review
#   end
# end
