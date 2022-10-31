defmodule Bookshare.AccountTest do
  use BookshareWeb.ConnCase, async: true

  import Bookshare.DataCase
  import Bookshare.AccountsFixtures

  alias Bookshare.Accounts.{User, UserToken}
  alias Bookshare.Auth
  alias Bookshare.Repo

  @correct_credentials %{email: "test@test0.local", password: "test0000"}

  describe "get_user_by_email/1" do
    setup do
      %{user: user_fixture()}
    end

    test "returns the user if email exist", %{user: user} do
      assert Auth.get_user_by_email(user.email)
    end

    test "does not return the user if email doesnt exist" do
      refute Auth.get_user_by_email("bad@email.com")
    end
  end

  describe "get_user_by_email_and_password/2" do
    setup do
      %{user: user_fixture()}
    end

    test "does not return the user if email is invalid" do
      refute Auth.get_user_by_email_and_password("invalid@email.com", "password")
    end

    test "does not return the user if password is invalid", %{user: user} do
      refute Auth.get_user_by_email_and_password(user.email, "password")
    end

    test "returns the user if email and password are valid", %{user: user} do
      assert Auth.get_user_by_email_and_password(user.email, valid_user_password())
    end
  end

  describe "get_user!/1" do
    setup do
      %{user: user_fixture()}
    end

    test "raise if id is invalid" do
      assert_raise Ecto.NoResultsError, fn ->
          Auth.get_user!(-1)
      end
    end

    test "returns the user with given id", %{user: user} do
      assert Auth.get_user!(user.id)
    end
  end

  describe "register_user/1" do
    setup do
      %{user: user_fixture()}
    end

    test "requires email and password" do
      assert {:error, changeset} = Auth.register_user(%{})

      assert %{
               password: ["can't be blank"],
               email: ["can't be blank"]
             } == errors_on(changeset)
    end

    test "validates maximum values for email and password" do
      too_long = String.duplicate("iv", 100)
      {:error, changeset} = Auth.register_user(%{email: "#{too_long}@email.com", password: too_long})

      assert "should be at most 160 character(s)" in errors_on(changeset).email
      assert "should be at most 50 character(s)" in errors_on(changeset).password
    end

    test "validates email uniqueness", %{user: user} do
      {:error, changeset} = Auth.register_user(%{email: user.email, password: user.password})
      assert "has already been taken" in errors_on(changeset).email

      {:error, changeset} = Auth.register_user(%{email: String.upcase(user.email), password: user.password})
      assert "has already been taken" in errors_on(changeset).email
    end

    test "register user with hashed password" do
      {:ok, user} = Auth.register_user(@correct_credentials)
      assert user.email == "test@test0.local"
      assert is_binary(user.hash_password)
    end
  end

  describe "change_user_password/2" do
    setup do
      %{user: user_fixture()}
    end

    test "returns a user changeset", %{user: user} do
      assert %Ecto.Changeset{} = changeset = Auth.change_user_password(user)
      assert changeset.required == [:password]
    end

    test "allows fields to be set", %{user: user} do
      password = "new valid password"
      changeset = Auth.change_user_password(user, %{"password" => password})

      assert changeset.valid?
      assert is_binary(changeset.changes.hash_password)
    end
  end


  describe "update_user_password/3" do
    setup do
      %{user: user_fixture()}
    end

    test "validates password", %{user: user} do
      {:error, changeset} = Auth.update_user_password(user, valid_user_password(), %{
        password: "bad",
        password_confirmation: "also bad"
      })

      assert %{
                password: ["should be at least 6 character(s)"],
                password_confirmation: ["does not match password"]
              } = errors_on(changeset)
    end

    test "validates maximum values for password", %{user: user} do
      too_long = String.duplicate("iv", 100)
      {:error, changeset} = Auth.update_user_password(user, valid_user_password(), %{password: too_long})

      assert "should be at most 50 character(s)" in errors_on(changeset).password
    end

    test "validates current password", %{user: user} do
      {:error, changeset} = Auth.update_user_password(user, "invalid", %{password: "new password"})

      assert %{current_password: ["is not valid"]} = errors_on(changeset)
    end

    test "updates the password", %{user: user} do
      {:ok, user} = Auth.update_user_password(user, valid_user_password(), %{password: "new valid password"})

      assert is_nil(user.password)
      assert Auth.get_user_by_email_and_password(user.email, "new valid password")
      refute Auth.get_user_by_email_and_password(user.email, valid_user_password())
    end

    test "deletes all tokens for the given user", %{user: user} do
      token = Auth.generate_user_session_token(user)
      assert Auth.get_user_by_session_token(token)

      {:ok, _} = Auth.update_user_password(user, valid_user_password(), %{password: "new valid password"})

      refute Repo.get_by(UserToken, user_id: user.id)
    end
  end

  describe "generate_user_session_token/1" do
    setup do
      %{user: user_fixture()}
    end

    test "generates a token", %{user: user} do
      token = Auth.generate_user_session_token(user)
      assert user_token = Repo.get_by(UserToken, token: token)
      assert user_token.context == "session"

      assert_raise Ecto.ConstraintError, fn ->
        Repo.insert!(%UserToken{
          token: user_token.token,
          user_id: user_fixture().id,
          context: "session"
        })
      end
    end
  end


  describe "get_user_by_session_token/1" do
    setup do
      user = user_fixture()
      token = Auth.generate_user_session_token(user)
      %{user: user, token: token}
    end

    test "returns user by token", %{user: user, token: token} do
      assert session_user = Auth.get_user_by_session_token(token)
      assert session_user.id == user.id
    end

    test "does not return user for expired token", %{token: token} do
      {1, nil} = Repo.update_all(UserToken, set: [inserted_at: ~N[2022-01-01 00:00:00]])
      refute Auth.get_user_by_session_token(token)
    end

     test "does not return user for invalid token" do
      refute Auth.get_user_by_session_token("fake token")
    end
  end

  describe "delete_session_token/1" do
    setup do
      %{user: user_fixture()}
    end

    test "deletes the token", %{user: user} do
      token = Auth.generate_user_session_token(user)
      assert Auth.delete_session_token(token) == :ok
      refute Auth.get_user_by_session_token(token)
    end
  end

  describe "deliver_user_reset_password_instructions/2" do
    setup do
      %{user: user_fixture()}
    end

    test "sends token through notification", %{user: user} do
      token =
        extract_user_token(fn url ->
          Auth.deliver_user_reset_password_instructions(user, url)
        end)
      {:ok, token} = Base.url_decode64(token, padding: false)
      assert user_token = Repo.get_by(UserToken, token: :crypto.hash(:sha256, token))
      assert user_token.user_id == user.id
      assert user_token.sent_to == user.email
      assert user_token.context == "reset_password"
    end
  end

  describe "get_user_by_reset_password_token/1" do
    setup do
      user = user_fixture()

      token =
        extract_user_token(fn url ->
          Auth.deliver_user_reset_password_instructions(user, url)
        end)

      %{user: user, token: token}
    end

    test "returns the user with invalid token", %{user: %{id: id}, token: token} do
      assert %User{id: ^id} = Auth.get_user_by_reset_password_token(token)
      assert Repo.get_by(UserToken, user_id: id)
    end

    test "does not return the user with invalid token", %{user: user} do
      refute Auth.get_user_by_reset_password_token("fake token")
      assert Repo.get_by(UserToken, user_id: user.id)
    end

    test "does not return the user if token expired", %{user: user, token: token} do
      {1, nil} = Repo.update_all(UserToken, set: [inserted_at: ~N[2022-01-01 00:00:00]])
      refute Auth.get_user_by_reset_password_token(token)
      assert Repo.get_by(UserToken, user_id: user.id)
    end
  end

  describe "reset_user_password/2" do
    setup do
      %{user: user_fixture()}
    end

    test "validates password", %{user: user} do
    {:error, changeset} =
      Auth.reset_user_password(user, %{
        password: "valid",
        password_confirmation: "another"
      })

    assert %{
      password: ["should be at least 6 character(s)"],
      password_confirmation: ["does not match password"]
    } = errors_on(changeset)
    end

    test "validates maximum values for password", %{user: user} do
      too_long = String.duplicate("iv", 100)
      {:error, changeset} = Auth.reset_user_password(user, %{password: too_long})
      assert "should be at most 50 character(s)" in errors_on(changeset).password
    end

    test "updates the password", %{user: user} do
      {:ok, updated_user} = Auth.reset_user_password(user, %{password: "new valid password"})
      assert is_nil(updated_user.password)
      assert Auth.get_user_by_email_and_password(user.email, "new valid password")
    end

    test "deletes all tokens for the given user", %{user: user} do
      _ = Auth.generate_user_session_token(user)

      {:ok, _} = Auth.reset_user_password(user, %{password: "new valid password"})

      refute Repo.get_by(UserToken, user_id: user.id)
    end
  end
end
