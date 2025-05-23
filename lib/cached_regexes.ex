defmodule CachedRegexes do
  defmacro __using__(_) do
    quote do
      import Kernel, except: [sigil_r: 2]
      import CachedRegexes
    end
  end

  @path Path.join(Mix.Project.build_path(), "cached_regexes")

  defmacro sigil_r({:<<>>, _, [binary]}, modifiers) do
    regexes =
      case File.read(@path) do
        {:ok, data} ->
          :erlang.binary_to_term(data)

        {:error, :enoent} ->
          %{}
      end

    counter = :persistent_term.get({__MODULE__, :counter})
    :counters.add(counter, 1, 1)
    key = :counters.get(counter, 1)

    regexes = Map.put(regexes, key, {binary, modifiers})
    File.write!(@path, :erlang.term_to_binary(regexes))

    quote do
      CachedRegexes.__get__(unquote(key))
    end
  end

  def __init__ do
    :persistent_term.put({__MODULE__, :counter}, :counters.new(1, []))
    File.rm_rf!(@path)
  end

  def __get__(key) do
    if not :persistent_term.get({__MODULE__, :loaded}, false) do
      load()
      :persistent_term.put({__MODULE__, :loaded}, true)
    end

    Map.fetch!(:persistent_term.get(__MODULE__), key)
  end

  defp load do
    regexes =
      case File.read(@path) do
        {:ok, data} ->
          for {key, {binary, modifiers}} <- :erlang.binary_to_term(data), into: %{} do
            {key, Regex.compile!(binary, modifiers)}
          end

        {:error, :enoent} ->
          %{}
      end

    :persistent_term.put(__MODULE__, regexes)
  end
end
