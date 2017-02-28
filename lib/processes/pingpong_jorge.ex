defmodule Processes do

  def start do
    pid1 = spawn(Processes, :ping, [])
    pid2 = spawn(Processes, :pong, [])
    send pid1, {pid2, :ping}
  end

  def ping do
    receive do
      {caller, :ping} ->
        IO.puts "Ping!!!"
        :timer.sleep 2000
        send caller, {self(), :pong}
        ping()
    end
  end

  def pong do
    receive do
      {caller, :pong} ->
        IO.puts "Pong!!!"
        :timer.sleep 2000
        send caller, {self(), :ping}
        pong()
    end
  end
end
