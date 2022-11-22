defmodule Bookshare.Comments do
  @moduledoc """
  The Comments context.
  """

  import Ecto.Query, warn: false
  alias Bookshare.Repo

  alias Bookshare.Comments.Review

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
end
