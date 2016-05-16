defmodule Finances.ChangesetView do
  use Finances.Web, :view

  def render("error.json", %{changeset: changeset}) do
    %{errors: parse_errors(changeset.errors)}
  end

  def parse_errors(errors) do
    errors
    |> Enum.reduce(%{}, fn({key, value}, acc) ->
      message = Finances.FormHelperView.translate_error_message(value)
      Map.put(acc, key, message)
    end)
  end
end
