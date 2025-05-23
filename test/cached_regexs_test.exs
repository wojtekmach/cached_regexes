defmodule CachedRegexsTest do
  use ExUnit.Case, async: true
  use CachedRegexs

  test "it works" do
    assert ~r/foo/.source == "foo"
    assert ~r/bar/.source == "bar"
  end
end
