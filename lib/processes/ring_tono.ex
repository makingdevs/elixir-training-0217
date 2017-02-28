defmodule Ring do
  def run do
    receive do
      {[h | [s|t]]} ->
        IO.inspect self()
        send s, {h, t}
        run()
      {pid,[h | t]} ->
        IO.inspect self()
        send h, {pid, t}
      {pid,[]} ->
        IO.inspect self()
        send pid, {[]}
      {[]} ->
        IO.inspect self()
        :end
    end
  end
  def start(n) do
    [p1 | t] = 0..n
    |>Enum.map(fn _ -> spawn(Ring, :run, []) end)
    send p1, {[p1 | t]}
  end
end
