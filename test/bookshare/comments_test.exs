# defmodule Bookshare.CommentsTest do
#   use Bookshare.DataCase

#   alias Bookshare.Comments

#   describe "reviews" do
#     alias Bookshare.Comments.Review

#     import Bookshare.CommentsFixtures

#     @invalid_attrs %{rating: nil, text: nil}

#     test "list_reviews/0 returns all reviews" do
#       review = review_fixture()
#       assert Comments.list_reviews() == [review]
#     end

#     test "get_review!/1 returns the review with given id" do
#       review = review_fixture()
#       assert Comments.get_review!(review.id) == review
#     end

#     test "create_review/1 with valid data creates a review" do
#       valid_attrs = %{rating: "120.5", text: "some text"}

#       assert {:ok, %Review{} = review} = Comments.create_review(valid_attrs)
#       assert review.rating == Decimal.new("120.5")
#       assert review.text == "some text"
#     end

#     test "create_review/1 with invalid data returns error changeset" do
#       assert {:error, %Ecto.Changeset{}} = Comments.create_review(@invalid_attrs)
#     end

#     test "update_review/2 with valid data updates the review" do
#       review = review_fixture()
#       update_attrs = %{rating: "456.7", text: "some updated text"}

#       assert {:ok, %Review{} = review} = Comments.update_review(review, update_attrs)
#       assert review.rating == Decimal.new("456.7")
#       assert review.text == "some updated text"
#     end

#     test "update_review/2 with invalid data returns error changeset" do
#       review = review_fixture()
#       assert {:error, %Ecto.Changeset{}} = Comments.update_review(review, @invalid_attrs)
#       assert review == Comments.get_review!(review.id)
#     end

#     test "delete_review/1 deletes the review" do
#       review = review_fixture()
#       assert {:ok, %Review{}} = Comments.delete_review(review)
#       assert_raise Ecto.NoResultsError, fn -> Comments.get_review!(review.id) end
#     end

#     test "change_review/1 returns a review changeset" do
#       review = review_fixture()
#       assert %Ecto.Changeset{} = Comments.change_review(review)
#     end
#   end
# end
