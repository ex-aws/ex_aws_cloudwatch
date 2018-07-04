use Mix.Config

case File.stat("config/#{Mix.env}.exs") do
  {:ok, _} -> import_config "#{Mix.env}.exs"
  _ -> :noop
end
