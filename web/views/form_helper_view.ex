defmodule Finances.FormHelperView do
  import Finances.Extranslate

  def parse_error_message(message) do
    case message do
      {text, list} ->
        Enum.reduce(list, text, fn({k, v}, acc) ->
          Regex.replace(~r/%\{#{k}\}/, acc, to_string(v))
        end)
      _ -> message
    end
  end

  def translate_error_message(message) do
    case message do
      {text, list} ->
        Enum.reduce(list, text, fn({k, v}, acc) ->
          default = Regex.replace(~r/%\{#{k}\}/, acc, to_string(v))
          translate("errors|" <> text, default, %{k => v})
        end)
      _ -> translate(message, message)
    end
  end
end
