defmodule Bookshare.Factory do
  use ExMachina.Ecto, repo: Bookshare.Repo

  def user_factory(attrs) do
    password = Map.get(attrs, :password, "password")

    user = %Bookshare.Accounts.User{
      email: sequence(:email, &"email-#{&1}@example.com"),
      hash_password: Bcrypt.hash_pwd_salt(password)
    }

    merge_attributes(user, attrs)
  end
end
