defmodule Finances.FormHelperViewTest do
  use Finances.ConnCase, async: true

  test "#parse_error_message returns the correct error string" do
    message = {"Ops, %{count} errors found", [count: 3]}

    assert Finances.FormHelperView.parse_error_message(message) == "Ops, 3 errors found"
  end

  test "#parse_error_message returns the correct string with multiple variables" do
    message = {"Ops, %{count} errors found %{user}", [count: 3, user: "Tester"]}

    assert Finances.FormHelperView.parse_error_message(message) == "Ops, 3 errors found Tester"
  end
end
