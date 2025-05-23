defmodule CachedRegexs do
  defmacro __using__(_) do
    quote do
      import Kernel, except: [sigil_r: 2]
      import CachedRegexs
    end
  end

  @path Path.join(Mix.Project.build_path(), "cached_regexs")

  defmacro sigil_r({:<<>>, _, [binary]}, modifiers) do
    regexs =
      case File.read(@path) do
        {:ok, data} ->
          :erlang.binary_to_term(data)

        {:error, :enoent} ->
          %{}
      end

    key = map_size(regexs)
    regexs = Map.put(regexs, key, {binary, modifiers})
    File.write!(@path, :erlang.term_to_binary(regexs))

    quote do
      CachedRegexs.__get__(unquote(key))
    end
  end

  def __init__ do
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
    regexs =
      case File.read(@path) do
        {:ok, data} ->
          for {key, {binary, modifiers}} <- :erlang.binary_to_term(data), into: %{} do
            {key, Regex.compile!(binary, modifiers)}
          end

        {:error, :enoent} ->
          %{}
      end

    :persistent_term.put(__MODULE__, regexs)
  end
end
