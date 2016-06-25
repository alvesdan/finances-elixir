defmodule Finances.PageControllerTest do
  use Finances.ConnCase

  test "GET /" do
    conn = get build_conn(), "/"
    assert html_response(conn, 200) =~ "Finances"
  end
end
