defmodule CachedRegexs.Application do
  @moduledoc false
  use Application

  @impl true
  def start(_type, _args) do
    CachedRegexs.__init__()
    children = []
    opts = [strategy: :one_for_one, name: CachedRegexs.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
