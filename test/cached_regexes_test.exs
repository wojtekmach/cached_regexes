defmodule CachedRegexesTest do
  use ExUnit.Case, async: true
  use CachedRegexes

  test "it works" do
    assert ~r/foo/.source == "foo"
    assert ~r/bar/.source == "bar"
  end
end
