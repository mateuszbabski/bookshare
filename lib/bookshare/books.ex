defmodule Bookshare.Books do
  @moduledoc """
  The Books context.
  """

  import Ecto.Query, warn: false
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
  def get_book!(id), do: Repo.get!(Book, id) |> Repo.preload([:authors, :categories])

  @doc """
  Creates a book.

  ## Examples

      iex> create_book(%{field: value})
      {:ok, %Book{}}

      iex> create_book(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_book(user, %{"authors" => _authors, "categories" => _categories} = attrs) do
    %Book{}
    |> Book.changeset(Map.drop(attrs, ["authors", "categories"]))
    |> Ecto.Changeset.put_assoc(:user, user)
    |> load_authors_assoc(attrs)
    #|> load_categories_assoc(attrs)
    |> Repo.insert()
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
    book
    |> Book.changeset(attrs)
    |> Repo.update()
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

  defp load_authors_assoc(book, %{"authors" => authors} = attrs) do
    if Repo.exists?(from a in Author, where: a.name == ^attrs["authors"]) do
      authors = Repo.all(from a in Author, where: a.name == ^authors)
      book
      |> Ecto.Changeset.change()
      |> Ecto.Changeset.put_assoc(:authors, authors)
    else
      {:ok, %Author{} = authors} = Repo.insert(%Author{name: authors}, returning: true)
      authors = Repo.all(from a in Author, where: a.name == ^authors.name)
      book
      |> Ecto.Changeset.change()
      |> Ecto.Changeset.put_assoc(:authors, authors)
    end
  end

  # defp load_categories_assoc(book, %{"categories" => categories} = _attrs) do

  # end
end
