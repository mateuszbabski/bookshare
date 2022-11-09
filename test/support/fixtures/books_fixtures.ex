defmodule Bookshare.BooksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Bookshare.Books` context.
  """

  @doc """
  Generate a book.
  """
  def book_fixture(attrs \\ %{}) do
    {:ok, book} =
      attrs
      |> Enum.into(%{

      })
      |> Bookshare.Books.create_book()

    book
  end
end
