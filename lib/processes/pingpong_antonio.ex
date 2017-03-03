defmodule PingPong.Player do

  def do_catch(n) do
    receive do
      {oponent, :ping} ->
        IO.puts "#{n} catch PING"
        cond do
          n < 10 ->
            send oponent, {self(), :pong}
            do_catch(n+1)
          n >= 10 ->
            IO.puts "Game over"
        end
      {oponent, :pong} ->
        IO.puts "#{n} catch PONG"
        cond do
          n < 10  ->
            send oponent, {self(),:ping}
            do_catch(n+1)
          n >= 10 ->
            IO.puts "Game over"
        end
    after 10000 ->
        IO.puts "EXIT"
        Process.exit self(), :kill
    end
  end
end
