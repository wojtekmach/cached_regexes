defmodule CachedRegexes.Application do
  @moduledoc false
  use Application

  @impl true
  def start(_type, _args) do
    CachedRegexes.__init__()
    children = []
    opts = [strategy: :one_for_one, name: CachedRegexes.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
