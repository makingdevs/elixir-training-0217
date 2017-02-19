defmodule MyProceses do
  #  for x <- 1..10000, y <- 1..1000, do: send(pid, {self, x, y})
  def operation(n) do
    receive do
      {parent, :+,a,b} ->
        send parent, a + b; operation(n+1)
      {parent, :-,a,b} ->
        send parent, a - b; operation(n+1)
      :counter ->
        IO.puts "#{n} times"; operation(n)
      :terminate ->
        IO.puts "Terminado"
      _ ->
        operation(n)
    end
  end

  def pmap(collection, fun) do
    collection
    |> Stream.map(&spawn_process(&1, self, fun))
    |> Stream.map(&await/1)
    |> Enum.map(&(&1))
  end

  defp spawn_process(item, parent, fun) do
    pid = spawn fn ->
      send parent, {self, fun.(item)}
    end
    pid
  end

  defp await(pid) do
    receive do
      {^pid, result} -> result
    end
  end

end
