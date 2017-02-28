#pinpong.ex
defmodule Pinpong do

  def ping(limit) do
    receive do
      {from, :ping, n, _} when is_integer(n) and n<limit ->
        IO.puts '#{n} :pong '
        send from, {self(), :pong, n+1, limit}
        ping(limit)
      {from, :ping, n, _} when is_integer(n) and n>=limit ->
        IO.puts '#{n} :pong -end'
        send from, {self(), :pong, n+1, limit}
    end
  end

  def pong do
    receive do
      {from, :pong, n, limit} when is_integer(limit) and n<limit ->
        IO.puts '#{n} :ping'
        send from, {self(), :ping, n+1, limit}
        pong()
      {from, :pong, n, limit} when is_integer(limit) and n>=limit ->
        IO.puts '#{n} :ping- end'
        send from, {self(), :ping, n+1, limit}
    end
  end

  def rebotar(n) when n<=0 do
    IO.puts "Debe ser mayor que cero el numero de veces"
  end
  def rebotar(n) when n>0 do
    ping_pid = spawn __MODULE__, :ping, [n-1]
    pong_pid = spawn __MODULE__, :pong, [] #5
    IO.inspect ping_pid
    IO.inspect pong_pid
    #{ping_pid, pong_pid} = start
    send ping_pid, {pong_pid, :ping, 0, 0}
  end
end
