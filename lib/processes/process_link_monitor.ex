defmodule MyProceses.Linking do
  def explode, do: exit(:pelaz)
  def run do
    Process.flag(:trap_exit, true)
    spawn_link(__MODULE__, :explode, [])
    receive do
      {:EXIT, _from_pid, reason} ->
        IO.puts "Exit: #{reason}"
    end
  end

  def run2 do
    {_pid, ref} = spawn_monitor(__MODULE__, :explode, [])
    receive do
      {:DOWN, ^ref, :process, _from_pid, reason} ->
        IO.puts "Exit: #{reason}"
    end
  end

  def double(x) do
    :timer.sleep 2000
    x * 2
  end
end
