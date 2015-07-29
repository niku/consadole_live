defmodule ConsadoleLiveTest do
  use ExUnit.Case, async: true

  def doc, do: Path.join([__DIR__, "fixture", "flash_text.txt"]) |> File.read!

  test "first element of the parsed list is old one" do
    assert List.first(ConsadoleLive.parse(doc)) == {"試合開始", "磐田ボールでキックオフ"}
  end

  test "last element of the parsed list is new one" do
    assert List.last(ConsadoleLive.parse(doc)) == {"試合終了", "J2首位の磐田相手に攻撃陣が爆発。今シーズン初の3得点により快勝。"}
  end

  test "empty string if time is not given" do
    assert Enum.find(ConsadoleLive.parse(doc), &(elem(&1, 1) == "両チームとも選手交代はなし")) == {"", "両チームとも選手交代はなし"}
  end
end
