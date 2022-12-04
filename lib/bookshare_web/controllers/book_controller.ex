defmodule BookshareWeb.BookController do
  use BookshareWeb, :controller

  alias Bookshare.Books
  alias Bookshare.Books.Book

  action_fallback BookshareWeb.FallbackController

  def index(conn, _params) do
    books = Books.list_books()
    render(conn, "index.json", books: books)
  end

  def create(conn, %{"book" => book_params}) do
    user = conn.assigns.current_user

    with {:ok, %Book{} = _book} <- Books.create_book(user, book_params) do
      conn
      |> put_status(:created)
      |> json(%{message: "Book created"})
    end
  end

  def show(conn, %{"id" => id}) do
    if book = Books.get_book(id) do
      render(conn, "show.json", book: book)
    else
      conn
      |> put_status(:not_found)
      |> json(%{message: "Book not found"})
    end
  end

  def update(conn, %{"id" => id, "book" => book_params}) do
    user = conn.assigns.current_user

    with book                  <- Books.get_book!(id),
         true                  <- book.user_id == user.id,
         {:ok, %Book{} = book}  <- Books.update_book(book, book_params) do
      render(conn, "show.json", book: book)
    else
      {:error, changeset} -> {:error, changeset}

      false -> json(conn, %{message: "User does not have book yet"})
    end
  end

  def delete(conn, %{"id" => id}) do
    user = conn.assigns.current_user

    with book           <- Books.get_book!(id),
         true           <- book.user_id == user.id,
         {:ok, %Book{}} <- Books.delete_book(book) do

      send_resp(conn, :no_content, "")
    end
  end
end
