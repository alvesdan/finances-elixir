defmodule Finances.FormHelperView do
  def parse_error_message(message) do
    case message do
      {text, list} -> "have to figure out"
      _ -> message
    end
  end
end
