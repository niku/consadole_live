defmodule ConsadoleLive.Twitter do
  use GenServer

  def start_link(twitter_config) do
    GenServer.start_link(__MODULE__, twitter_config)
  end

  def post(pid, posts) do
    Enum.each(posts, fn (post) -> GenServer.cast(pid, {:post, post}) end)
  end

  def already_posts(pid) do
    GenServer.call(pid, :already_posts)
  end

  # Server

  def init(twitter_config) do
    ExTwitter.configure(:process, twitter_config)
    {:ok, []}
  end

  def handle_cast({:post, post}, already_posts) do
    if Enum.member?(already_posts, post) do
      {:noreply, already_posts}
    else
      text = case post do
               {"",   body} -> "#{body} #consadole"
               {time, body} -> "#{time} #{body} #consadole"
             end
      ExTwitter.update(text)
      {:noreply, [post | already_posts]}
    end
  end

  def handle_call(:already_posts, _from, state) do
    {:reply, state, state}
  end
end
