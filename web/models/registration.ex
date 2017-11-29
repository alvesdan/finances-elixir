defmodule Finances.Registration do
  import Ecto.Changeset, only: [put_change: 3]
  import Ecto.Query
  import Comeonin.Bcrypt, only: [checkpw: 2, hashpwsalt: 1]

  def create(changeset, repo) do
    crypted_password = hashed_password(
      changeset.params["password"])

    changeset
    |> put_change(:crypted_password, crypted_password)
    |> repo.insert()
  end

  def valid?(email, password) do
    case Finances.Repo.get_by(Finances.User, email: email) do
      nil -> :invalid
      user ->
        if checkpw(password, user.crypted_password),
          do: {:ok, user}, else: :invalid
    end
  end

  defp hashed_password(password) do
    hashpwsalt(password || "")
  end
end

