defmodule Finances.Session do
  use Finances.Web, :model

  @derive {Poison.Encoder, only: [:expires_at, :token]}
  schema "sessions" do
    belongs_to :user, Finances.User
    field :expires_at, :utc_datetime
    field :token, :string

    timestamps
  end

  @required_fields [:user_id, :token, :expires_at]

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
  end

  def valid?(nil) do
    false
  end

  def valid?(%__MODULE__{expires_at: expires_at}) do
    DateTime.utc_now
    |> DateTime.compare(expires_at) == :lt
  end

  def find_valid_for(user) do
    query = from s in __MODULE__,
      where: s.user_id == ^user.id and
             s.expires_at > ^DateTime.utc_now,
      select: s

    query |> Finances.Repo.all |> List.last
  end

  def find_or_create_for(user) do
    case find_valid_for(user) do
      nil -> create_for(user)
      session -> {:ok, session}
    end
  end

  def create_for(user) do
    valid_token = generate_token_for(user)
    expires_at = generate_expires_at
    session = Ecto.build_assoc(
      user, :sessions, %{token: valid_token, expires_at: expires_at})

    Finances.Repo.insert(session)
  end

  defp generate_token_for(user) do
    now = :calendar.local_time
          |> :calendar.datetime_to_gregorian_seconds
          |> to_string

    :crypto.hash(:sha512, [now, user.email])
      |> Base.encode16
      |> String.downcase
  end

  defp generate_expires_at do
    Timex.now
      |> Timex.shift(hours: 6)
  end
end
