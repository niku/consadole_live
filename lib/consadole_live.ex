defmodule ConsadoleLive do
  require Logger

  defmodule CLI do
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
      case argv do
        [x] -> IO.inspect(x)
        _ ->
          Logger.error "Can't accept argv: #{inspect argv}"
          IO.puts ~s(You have to pass only one argument like: "./consadole_live 596")
          System.halt(1)
      end
    end
  end
end
