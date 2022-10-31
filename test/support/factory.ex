defmodule AuthBoilerplate.Factory do
  use ExMachina.Ecto, repo: AuthBoilerplate.Repo

  def user_factory(attrs) do
    password = Map.get(attrs, :password, "password")

    user = %AuthBoilerplate.Accounts.User{
      email: sequence(:email, &"email-#{&1}@example.com"),
      hash_password: Bcrypt.hash_pwd_salt(password)
    }

    merge_attributes(user, attrs)
  end
end
