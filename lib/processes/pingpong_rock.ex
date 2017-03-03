defmodule PingPong.Rock do
  def ping() do
    receive do
      {pid_pong} ->
        IO.puts ("Ping")
        :timer.sleep 2000
        send(pid_pong, {self()})
        ping()
    end
  end

  def pong() do
    receive do
      {pid_ping} ->
        IO.puts ("Pong")
        :timer.sleep 2000
        send(pid_ping, {self()})
        pong()
    end
  end

  def run() do
    pid_ping = spawn(PingPong.Rock, :ping, [])
    pid_pong = spawn(PingPong.Rock, :pong, [])
    send(pid_ping, {pid_pong})
  end
end
