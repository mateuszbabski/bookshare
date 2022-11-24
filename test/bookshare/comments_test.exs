defmodule Bookshare.CommentsTest do
  use Bookshare.DataCase

  alias Bookshare.Comments

  describe "reviews" do
    alias Bookshare.Comments.Review

    import Bookshare.CommentsFixtures

    @invalid_attrs %{rating: nil, text: nil}
    @reviewed_user %{id: 1, email: "reviewed_user@example.com", password: nil, is_confirmed: true, hash_password: "hash_password"}
    @valid_attrs %{review_author_id: 1000, rating: "4.5", text: "review"}

    test "list_reviews/0 returns all reviews" do
      review = review_fixture(@reviewed_user, @valid_attrs)
      assert Comments.list_reviews(review.user_id)
    end

    test "get_review!/1 returns the review with given id" do
      review = review_fixture(@reviewed_user, @valid_attrs)
      assert Comments.get_review!(review.id)
      assert review.user_id == 1
      assert review.review_author_id == 1000
      assert Decimal.equal?(review.rating, "4.5")
      assert review.text == "review"
    end

    test "create_review/1 with valid data creates a review" do
      valid_attrs = %{rating: "3.0", text: "review text", review_author_id: 1000}

      assert {:ok, %Review{} = review} = Comments.create_review(@reviewed_user, valid_attrs)
      assert review.rating == Decimal.new("3.0")
      assert review.text == "review text"
      assert review.review_author_id == 1000
    end

    test "create_review/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Comments.create_review(@reviewed_user, @invalid_attrs)
    end

    test "update_review/2 with valid data updates the review" do
      review = review_fixture(@reviewed_user, @valid_attrs)
      update_attrs = %{rating: "2.5", text: "some updated review"}

      assert {:ok, %Review{} = review} = Comments.update_review(review, update_attrs)
      assert review.rating == Decimal.new("2.5")
      assert review.text == "some updated review"
    end

    test "update_review/2 with invalid data returns error changeset" do
      review = review_fixture(@reviewed_user, @valid_attrs)
      assert {:error, %Ecto.Changeset{}} = Comments.update_review(review, @invalid_attrs)
    end

    test "delete_review/1 deletes the review" do
      review = review_fixture(@reviewed_user, @valid_attrs)
      assert {:ok, %Review{}} = Comments.delete_review(review)
      assert_raise Ecto.NoResultsError, fn -> Comments.get_review!(review.id) end
    end

    test "change_review/1 returns a review changeset" do
      review = review_fixture(@reviewed_user, @valid_attrs)
      assert %Ecto.Changeset{} = Comments.change_review(review)
    end
  end
end
