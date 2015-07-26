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
        [x] -> ConsadoleLive.run(x)
        _ ->
          Logger.error "Can't accept argv: #{inspect argv}"
          IO.puts ~s(You have to pass only one argument like: "./consadole_live 596")
          System.halt(1)
      end
    end
  end

  def run(number) do
    build_uri(number)
    |> fetch
    |> parse
  end

  def build_uri(number), do: URI.parse("http://www.consadole-sapporo.jp/game/flash_text/?mid=#{number}")
  def fetch(uri), do: HTTPoison.get!(uri) |> Map.get(:body)
  def parse(doc) do
    Floki.find(doc, "article table tr")
    |> Enum.map(&Floki.find(&1, "td"))
    |> Enum.map(&Enum.map(&1, fn(x) -> Floki.text(x) end))
    |> Enum.map(fn
         [a]    -> {"",            Floki.text(a)}
         [a, b] -> {Floki.text(a), Floki.text(b)}
       end)
  end
end
