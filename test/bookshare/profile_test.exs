defmodule Bookshare.ProfileTest do
  use Bookshare.DataCase

  alias Bookshare.Accounts

  describe "profiles" do
    alias Bookshare.Accounts.Profile
    alias Bookshare.AccountsFixtures

    @invalid_attrs %{username: nil}

    setup do
      %{user: AccountsFixtures.user_fixture()}
    end

    # test "get_profile!/1 returns the profile with given id", %{user: user} do
    #   profile = profile_fixture(user)
    #   assert Accounts.get_profile!(profile.id) == profile
    # end

    test "create_profile/1 with valid data creates a profile", %{user: user} do
      valid_attrs = %{username: "username"}

      assert {:ok, %Profile{} = profile} = Accounts.create_profile(user, valid_attrs)
      assert profile.username == "username"
    end

    test "create_profile/1 with invalid data returns error changeset", %{user: user} do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_profile(user, @invalid_attrs)
    end

    test "update_profile/2 with valid data updates the profile", %{user: user} do
      profile = AccountsFixtures.profile_fixture(user)
      update_attrs = %{username: "updatedUsername"}

      assert {:ok, %Profile{} = profile} = Accounts.update_profile(profile, update_attrs)
      assert profile.username == "updatedUsername"
    end

    test "update_profile/2 with invalid data returns error changeset", %{user: user} do
      profile = AccountsFixtures.profile_fixture(user)
      assert {:error, %Ecto.Changeset{}} = Accounts.update_profile(profile, @invalid_attrs)
      assert profile == Accounts.get_profile!(profile.id)
    end

    test "change_profile/1 returns a profile changeset", %{user: user} do
      profile = AccountsFixtures.profile_fixture(user)
      assert %Ecto.Changeset{} = Accounts.change_profile(profile)
    end

    test "get_profile_by_user_id/1 returns valid profile", %{user: user} do
      profile = AccountsFixtures.profile_fixture(user)
      assert profile == Accounts.get_profile_by_user_id(user.id)
    end

    test "get_profile_by_user_id/1", %{user: user} do
      _profile = AccountsFixtures.profile_fixture(user)
      refute Accounts.get_profile_by_user_id(user.id + 1)
    end
  end
end
