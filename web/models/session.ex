defmodule Finances.Session do
  use Finances.Web, :model

  schema "sessions" do
    belongs_to :user, Finances.User
    field :expires_at, Ecto.DateTime
    field :token, :binary

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
end
