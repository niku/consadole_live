defmodule ConsadoleLive do
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
