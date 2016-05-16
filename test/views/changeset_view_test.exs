defmodule ChangesetViewTest do
  use Finances.ConnCase, async: true

  import Phoenix.View

  test "renders translated error messages" do
    Extranslate.put_locale "pt-BR"
    Extranslate.Redix.set("extr|pt-BR|errors|can't be blank", "é obrigatório")
    Extranslate.Redix.set("extr|pt-BR|errors|should be at most %{count} characters", "não pode ultrapassar %{count} caracteres")

    params = %{changeset: %{errors: [
      name: "can't be blank",
      message: {
        "should be at most %{count} characters",
        [count: 140]
      }
    ]}}

    assert render_to_string(
      Finances.ChangesetView,
      "error.json", params) == Poison.encode!(%{
        errors: %{
          name: "é obrigatório",
          message: "não pode ultrapassar 140 caracteres"
        }
      })
  end
end
