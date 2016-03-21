defmodule Finances.FormHelperView do
  def parse_error_message(message) do
    case message do
      {text, list} ->
        Enum.reduce(list, text, fn({k, v}, acc) ->
          Regex.replace(~r/%\{#{k}\}/, acc, to_string(v))
        end)
      _ -> message
    end
  end
end
