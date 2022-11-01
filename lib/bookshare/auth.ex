defmodule Bookshare.Auth do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Bookshare.Repo

  alias Bookshare.Accounts.{User, UserToken, UserNotifier}

  @doc """
  Gets a user by email.
  ## Examples
      iex> get_user_by_email("foo@example.com")
      %User{}
      iex> get_user_by_email("unknown@example.com")
      nil
  """

  def get_user_by_email(email) when is_binary(email) do
    Repo.get_by(User, email: email)
  end

  @doc """
  Gets a user by email and password.
  ## Examples
      iex> get_user_by_email_and_password("foo@example.com", "correct_password")
      %User{}
      iex> get_user_by_email_and_password("foo@example.com", "invalid_password")
      nil
  """

  def get_user_by_email_and_password(email, password)
    when is_binary(email) and is_binary(password) do
      user = Repo.get_by(User, email: email)
      if User.valid_password?(user, password), do: user
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)


  ## User registration

  @doc """
  Registers a user.
  ## Examples
      iex> register_user(%{field: value})
      {:ok, %User{}}
      iex> register_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  def register_user(attrs) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  def register_user!(attrs) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert!()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for changing the user password.
  ## Examples
      iex> change_user_password(user)
      %Ecto.Changeset{data: %User{}}
  """
  def change_user_password(user, attrs \\ %{}) do
    User.password_changeset(user, attrs)
  end

  @doc """
  Updates the user password.
  ## Examples
      iex> update_user_password(user, "valid password", %{password: ...})
      {:ok, %User{}}
      iex> update_user_password(user, "invalid password", %{password: ...})
      {:error, %Ecto.Changeset{}}
  """
  def update_user_password(user, password, attrs) do
    changeset =
      user
      |> User.password_changeset(attrs)
      |> User.validate_current_password(password)

    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, changeset)
    |> Ecto.Multi.delete_all(:tokens, UserToken.user_and_contexts_query(user, :all))
    |> Repo.transaction()
    |> case do
      {:ok, %{user: user}} -> {:ok, user}
      {:error, :user, changeset, _} -> {:error, changeset}
    end
  end

  ## Session

  @doc """
  Generates a session token.
  """

  def generate_user_session_token(user) do
    {token, user_token} = UserToken.build_session_token(user)
    Repo.insert!(user_token)
    # Change to string representation for authorization.
    # This is a deviation from the mix.phx.gen one
    # Eventually could switch to Phoenix.Token or JWT
    token
  end

   @doc """
  Gets the user with the given signed token.
  """

  def get_user_by_session_token(token) do
    {:ok, query} = UserToken.verify_session_token_query(token)
    Repo.one(query)
  end

  @doc """
  Deletes the signed token with the given context.
  """

  def delete_session_token(token) do
    Repo.delete_all(UserToken.token_and_context_query(token, "session"))
    :ok
  end

  def delete_all_session_tokens_for_user(user) do
    Repo.delete_all(UserToken.user_and_contexts_query(user, "session"))
    :ok
  end

  ## Reset password

  @doc """
  Delivers the reset password email to the given user.
  ## Examples
      iex> deliver_user_reset_password_instructions(user)
      {:ok, %{to: ..., body: ...}}
  """

  def deliver_user_reset_password_instructions(%User{} = user) do
      {encoded_token, user_token} = UserToken.build_email_token(user, "reset_password")
      Repo.insert!(user_token)
      UserNotifier.send_forgot_password_email(user, encoded_token)
      {:ok, encoded_token}
  end

  @doc """
  Gets the user by reset password token.
  ## Examples
      iex> get_user_by_reset_password_token("validtoken")
      %User{}
      iex> get_user_by_reset_password_token("invalidtoken")
      nil
  """

  def get_user_by_reset_password_token(token) do
    with {:ok, query} <- UserToken.verify_email_token_query(token, "reset_password"),
          %User{} = user <- Repo.one(query) do
        user
    else
        _ -> nil
    end
  end

  @doc """
  Resets the user password.
  ## Examples
      iex> reset_user_password(user, %{password: "new long password", password_confirmation: "new long password"})
      {:ok, %User{}}
      iex> reset_user_password(user, %{password: "valid", password_confirmation: "not the same"})
      {:error, %Ecto.Changeset{}}
  """

  def reset_user_password(user, attrs) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, User.password_changeset(user, attrs))
    |> Ecto.Multi.delete_all(:tokens, UserToken.user_and_contexts_query(user, :all))
    |> Repo.transaction()
    |> case do
      {:ok, %{user: user}} -> {:ok, user}
      {:error, :user, changeset, _} -> {:error, changeset}
    end
  end

end
