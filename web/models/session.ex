defmodule Finances.Session do
  use Finances.Web, :model

  @derive {Poison.Encoder, only: [:expires_at]}
  schema "sessions" do
    belongs_to :user, Finances.User
    field :expires_at, Ecto.DateTime
    field :token, :string

    timestamps
  end

  @required_fields ~w(user_id token expires_at)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def valid?(nil) do
    false
  end

  def valid?(%Finances.Session{expires_at: expires_at}) do
    now = Ecto.DateTime.from_erl(:calendar.local_time)
    Ecto.DateTime.compare(now, expires_at) == :lt
  end
end
