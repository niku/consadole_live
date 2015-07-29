defmodule ConsadoleLive.CLI do
  require Logger

  def main(argv), do: argv |> parse_args |> process
  defp parse_args(args) do
    {parsed, argv, errors} = OptionParser.parse(args, strict: [])
    Logger.info "Parse ARGV to parsed: #{inspect parsed}, argv: #{inspect argv}, errors: #{inspect errors}"
    unless Enum.empty?(errors) do
      Logger.warn "Invalid ARGV: #{inspect errors}"
    end
    {parsed, argv}
  end
  defp process({_parsed, argv}) do
    twitter_config = %{consumer_key: System.get_env("TWITTER_CONSUMER_KEY"),
                       consumer_secret: System.get_env("TWITTER_CONSUMER_SECRET"),
                       access_token: System.get_env("TWITTER_ACCESS_TOKEN"),
                       access_token_secret: System.get_env("TWITTER_ACCESS_SECRET")}
    case argv do
      [x] -> ConsadoleLive.run(x, twitter_config)
      _ ->
        Logger.error "Can't accept argv: #{inspect argv}"
        IO.puts ~s(You have to pass only one argument like: "./consadole_live 596")
        System.halt(1)
    end
  end
end
