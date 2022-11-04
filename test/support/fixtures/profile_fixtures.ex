defmodule Bookshare.ProfileFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Bookshare.Accounts` context.
  """

  @doc """
  Generate a unique profile username.
  """
  def unique_profile_username, do: "some username#{System.unique_integer([:positive])}"

  @doc """
  Generate a profile.
  """
  def profile_fixture(attrs \\ %{}) do
    {:ok, profile} =
      attrs
      |> Enum.into(%{
        username: unique_profile_username(),
        user_id: 1
      })
      |> Bookshare.Accounts.create_profile()

    profile
  end
end
