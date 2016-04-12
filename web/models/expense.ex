defmodule Finances.Expense do
  use Finances.Web, :model

  schema "expenses" do
    belongs_to :user, Finances.User
    belongs_to :category, Finances.Category
    field :amount, :decimal
    field :spent_at, Ecto.DateTime
    field :notes, :string
    timestamps
  end

  @required_fields ~w(user_id category_id amount spent_at)
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
