defmodule Finances.Extranslate do
  alias Extranslate.Translator

  def translate(tag, default \\ :missing, bindings \\ %{}) do
    Translator.translate(tag, default, bindings)
  end
end
