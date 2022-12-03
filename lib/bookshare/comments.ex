defmodule Bookshare.Comments do
  @moduledoc """
  The Comments context.
  """

  import Ecto.Query, warn: false
  alias Bookshare.Repo

  alias Bookshare.Comments.Review
  alias Bookshare.Comments.Response

  @doc """
  Returns the list of reviews for specific user.

  ## Examples

      iex> list_reviews(id)
      [%Review{}, ...]

  """
  def list_reviews(id) do
    query = from r in Review, where: r.user_id == ^id
    Repo.all(query)
  end

  @doc """
  Gets a single review.

  Raises `Ecto.NoResultsError` if the Review does not exist.

  ## Examples

      iex> get_review!(123)
      %Review{}

      iex> get_review!(456)
      ** (Ecto.NoResultsError)

  """
  def get_review!(id), do: Repo.get!(Review, id)

  def get_review(user_id, review_id) do
    query = from r in Review,
            where: r.user_id == ^user_id,
            where: r.id == ^review_id

    Repo.all(query)
  end

  @doc """
  Checks if user tries to leave a review for himself
  or if already left a review and tries to do it again

  ## Example

      iex> check_if_user_already_left_review(id, id)
           false

      iex> check_if_user_already_left_review(user_id, review_author_id)
           true | nil

  """
  def check_if_user_already_left_review(user_id, user_id), do: false

  def check_if_user_already_left_review(user_id, review_author_id) do
    query = from r in Review,
            where: r.user_id == ^user_id,
            where: r.review_author_id == ^review_author_id

    if Repo.one(query), do: true
  end

  @doc """
  Creates a review and assocciate it with a specific user.

  ## Examples

      iex> create_review(user, %{field: value})
      {:ok, %Review{}}

      iex> create_review(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_review(user, attrs \\ %{}) do
    %Review{}
    |> Review.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.insert()
  end

  @doc """
  Updates a review.

  ## Examples

      iex> update_review(review, %{field: new_value})
      {:ok, %Review{}}

      iex> update_review(review, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_review(%Review{} = review, attrs) do
    review
    |> Review.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a review.

  ## Examples

      iex> delete_review(review)
      {:ok, %Review{}}

      iex> delete_review(review)
      {:error, %Ecto.Changeset{}}

  """
  def delete_review(%Review{} = review) do
    Repo.delete(review)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking review changes.

  ## Examples

      iex> change_review(review)
      %Ecto.Changeset{data: %Review{}}

  """
  def change_review(%Review{} = review, attrs \\ %{}) do
    Review.changeset(review, attrs)
  end

  def create_response(user, review, attrs \\ %{}) do
    %Response{}
    |> Response.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Ecto.Changeset.put_assoc(:review, review)
    |> Repo.insert()
  end

  def check_if_user_can_leave_response(review_id, response_author_id) do
    query = from r in Review,
            where: ^review_id == r.id,
            where: ^response_author_id == r.user_id or ^response_author_id == r.review_author_id

    if Repo.one(query), do: true
  end
end
