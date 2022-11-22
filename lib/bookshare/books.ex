defmodule Bookshare.Books do
  @moduledoc """
  The Books context.
  """

  import Ecto.Query, warn: false
  alias Ecto.Multi
  alias Bookshare.Repo

  alias Bookshare.Books.Book
  alias Bookshare.Books.Author
  alias Bookshare.Books.Category

  @doc """
  Returns the list of books.

  ## Examples

      iex> list_books()
      [%Book{}, ...]

  """
  def list_books do
    Repo.all(Book) |> Repo.preload([:authors, :categories])
  end

  @doc """
  Gets a single book.

  Raises `Ecto.NoResultsError` if the Book does not exist.

  ## Examples

      iex> get_book!(123)
      %Book{}

      iex> get_book!(456)
      ** (Ecto.NoResultsError)

  """
  def get_book(id), do: Repo.get(Book, id) |> Repo.preload([:authors, :categories])

  def get_book!(id), do: Repo.get!(Book, id) |> Repo.preload([:authors, :categories])

  def get_book_by_user_id(user_id) do
    Repo.get_by(Book, [user_id: user_id]) |> Repo.preload(:user)
  end

  @doc """
  Creates a book.

  ## Examples

      iex> create_book(user, %{field: value})
      {:ok, %Book{}}

      iex> create_book(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """

  def create_book(user, attrs \\ %{}) do
    multi_result =
      Multi.new()
      |> ensure_authors(attrs)
      |> ensure_categories(attrs)
      |> Multi.insert(:book, fn %{authors: authors, categories: categories} ->
        %Book{}
        |> Book.changeset(Map.drop(attrs, ["authors", "categories"]))
        |> Ecto.Changeset.put_assoc(:user, user)
        |> Ecto.Changeset.put_assoc(:authors, authors)
        |> Ecto.Changeset.put_assoc(:categories, categories)
      end)
      |> Repo.transaction()

      case multi_result do
        {:ok, %{book: book}} -> {:ok, book}
        {:error, :book, changeset, _} -> {:error, changeset}
      end
  end

  defp parse_inputs(nil), do: []

  defp parse_inputs(inputs) do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

    for input <- String.split(inputs, ","),
        input = input |> String.trim(),
        input != "",
        do: %{name: input, inserted_at: now, updated_at: now}
  end

  defp ensure_authors(multi, attrs) do
    authors = parse_inputs(attrs["authors"])

    multi
    |> Multi.insert_all(:insert_authors, Author, authors, on_conflict: :nothing)
    |> Multi.run(:authors, fn repo, _changes ->
      author_names = for a <- authors, do: a.name
      {:ok, repo.all(from a in Author, where: a.name in ^author_names)}
    end)
  end

  defp ensure_categories(multi, attrs) do
    categories = parse_inputs(attrs["categories"])

    multi
    |> Multi.insert_all(:insert_categories, Category, categories, on_conflict: :nothing)
    |> Multi.run(:categories, fn repo, _changes ->
      category_names = for c <- categories, do: c.name
      {:ok, repo.all(from c in Category, where: c.name in ^category_names)}
    end)
  end

  @doc """
  Updates a book.

  ## Examples

      iex> update_book(book, %{field: new_value})
      {:ok, %Book{}}

      iex> update_book(book, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_book(%Book{} = book, attrs) do
    multi_result =
      Multi.new()
      |> ensure_authors(attrs)
      |> ensure_categories(attrs)
      |> Multi.update(:book, fn %{authors: authors, categories: categories} ->
        book
        |> Book.changeset(Map.drop(attrs, ["authors", "categories"]))
        |> Ecto.Changeset.put_assoc(:authors, authors)
        |> Ecto.Changeset.put_assoc(:categories, categories)
      end)
      |> Repo.transaction()

    case multi_result do
      {:ok, %{book: book}} -> {:ok, book}
      {:error, :book, changeset, _} -> {:error, changeset}
    end
  end

  @doc """
  Deletes a book.

  ## Examples

      iex> delete_book(book)
      {:ok, %Book{}}

      iex> delete_book(book)
      {:error, %Ecto.Changeset{}}

  """
  def delete_book(%Book{} = book) do
    Repo.delete(book)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking book changes.

  ## Examples

      iex> change_book(book)
      %Ecto.Changeset{data: %Book{}}

  """
  def change_book(%Book{} = book, attrs \\ %{}) do
    Book.changeset(book, attrs)
  end
end
