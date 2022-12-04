defmodule Bookshare.CommentsTest do
  use Bookshare.DataCase

  alias Bookshare.Comments

  describe "reviews" do
    alias Bookshare.Comments.Review
    alias Bookshare.Comments.Response

    import Bookshare.CommentsFixtures

    @invalid_attrs %{rating: nil, text: nil}
    @reviewed_user %{id: 1, email: "reviewed_user@example.com", password: nil, is_confirmed: true, hash_password: "hash_password"}
    @valid_attrs %{review_author_id: 1000, rating: "4.5", text: "review"}
    @response_attrs %{text: "response text"}
    @response_author %{id: 2, email: "response_author@example.com", password: nil, is_confirmed: true, hash_password: "hash_password"}

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

    test "check_if_user_already_left_review/2 returns true if finds review" do
      _review = review_fixture(@reviewed_user, @valid_attrs)
      assert true == Comments.check_if_user_already_left_review(@reviewed_user.id, @valid_attrs.review_author_id)
    end

    test "check_if_user_already_left_review/2 returns false if user wants review himself" do
      assert false == Comments.check_if_user_already_left_review(@reviewed_user.id, @reviewed_user.id)
    end

    test "check_if_user_already_left_review/2 returns nil if there is no review" do
      assert nil == Comments.check_if_user_already_left_review(@reviewed_user.id, @reviewed_user.id + 1)
    end

    test "create_response/3 creates response with valid params" do
      review = review_fixture(@reviewed_user, @valid_attrs)
      assert {:ok, %Response{} = _response} = Comments.create_response(@response_author, review, @response_attrs)
    end

    test "create_repsonse/3 raises ecto changeset with invalid params" do
      review = review_fixture(@reviewed_user, @valid_attrs)
      assert {:error, %Ecto.Changeset{}} = Comments.create_response(@response_author, review, %{text: nil})
    end

    test "check_if_user_can_leave_response/2 returns true if user can leave response to review" do
      review = review_fixture(@reviewed_user, @valid_attrs)
      assert true == Comments.check_if_user_can_leave_response(review.id, @valid_attrs.review_author_id)
      assert true == Comments.check_if_user_can_leave_response(review.id, @reviewed_user.id)
    end

    test "check_if_user_can_leave_response/2 returns nil if user can't leave response to review" do
      review = review_fixture(@reviewed_user, @valid_attrs)
      assert nil == Comments.check_if_user_can_leave_response(review.id, @response_author.id)
    end

    test "delete_response/1 returns no content if response deleted" do
      review = review_fixture(@reviewed_user, @valid_attrs)
      {:ok, %Response{} = response} = Comments.create_response(@response_author, review, @response_attrs)

      assert {:ok, %Response{}} = Comments.delete_response(response)
      assert_raise Ecto.NoResultsError, fn -> Comments.get_response!(response.id) end
    end

    test "get_response!/1 returns response with valid id" do
      review = review_fixture(@reviewed_user, @valid_attrs)
      {:ok, %Response{} = response} = Comments.create_response(@response_author, review, @response_attrs)

      assert Comments.get_response!(response.id)
      assert response.text == "response text"
      assert response.user_id == @response_author.id
    end
  end
end
