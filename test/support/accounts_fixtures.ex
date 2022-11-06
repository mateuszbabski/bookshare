defmodule Bookshare.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Hello.Accounts` context.
  """

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "hello world!"

  def valid_user_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      email: unique_user_email(),
      password: valid_user_password()
    })
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> valid_user_attributes()
      |> Bookshare.Auth.register_user()

    user = Map.put(user, :is_confirmed, false)
    user
  end

    @doc """
  Generate a unique profile username.
  """
  def unique_profile_username, do: "username#{System.unique_integer([:positive])}"

  @doc """
  Generate a profile.
  """
  def profile_fixture(user, _attrs \\ %{}) do
    attrs = %{
        username: unique_profile_username()
        }

    {:ok, profile} = Bookshare.Accounts.create_profile(user, attrs)

    profile
  end

  def extract_user_token(fun) do
    {:ok, captured_email} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token | _] = String.split(captured_email.text_body, "[TOKEN]")
    token
  end
end
