defmodule ChangesetViewTest do
  use Finances.ConnCase, async: true

  import Phoenix.View

  test "renders error messages" do
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
          name: "can't be blank",
          message: "should be at most 140 characters"
        }
      })
  end
end
