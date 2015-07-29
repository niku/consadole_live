defmodule ConsadoleLive do
  require Logger

  def run(number, twitter_config) do
    {:ok, twitter_pid} = ConsadoleLive.Twitter.start_link(twitter_config)
    uri = build_uri(number)
    Logger.info("ConsadoleLive.run uri: #{uri}")

    execute(twitter_pid, uri, 0, hash(""))
  end

  def build_uri(number), do: URI.parse("http://www.consadole-sapporo.jp/game/flash_text/?mid=#{number}")
  def fetch(uri), do: HTTPoison.get!(uri) |> Map.get(:body)
  def hash(doc), do: :crypto.hash(:md5, doc)
  def parse(doc) do
    Floki.find(doc, "article table tr")
    |> Enum.map(&Floki.find(&1, "td"))
    |> Enum.map(&Enum.map(&1, fn(x) -> Floki.text(x) end))
    |> Enum.map(fn
         [a]    -> {"",            Floki.text(a)}
         [a, b] -> {Floki.text(a), Floki.text(b)}
       end)
    |> Enum.reverse
  end

  defp execute(_twitter_pid, _uri, dup_times, _hash) when 9 < dup_times do
    Logger.info("Exit, because document has no any changes.")
    exit(0)
  end
  defp execute(twitter_pid, uri, dup_times, hash) do
    Logger.info("ConsadoleLive.execute dup_times: #{dup_times}, hash: #{inspect hash}")
    doc = fetch(uri)
    case hash(doc) do
      ^hash ->
        :timer.sleep(1000 * 60) # sleep 60 seconds
        execute(twitter_pid, uri, dup_times + 1, hash)
      new_hash ->
        Task.start(ConsadoleLive.Twitter, :post, [twitter_pid, parse(doc)])
        :timer.sleep(1000 * 60) # sleep 60 seconds
        execute(twitter_pid, uri, 0, new_hash)
    end
  end
end
