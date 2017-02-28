defmodule TheRing do

  @moduledoc """
  Creating a ring of processes
  """

  defmodule Worker do
    require Logger

    @moduledoc """
    The worker is the responsible for consume the messages
    The message is passed _n_ times, so you must try a number gerater than the ring
    """

    def loop(idx) do
      receive do
        {next_id, link_pid} ->
          Logger.info("#{idx} linked to #{next_id} at process #{inspect(link_pid)}")
          loop idx, {next_id, link_pid}
        _ ->
          Logger.info "Not recognized at idx"
          loop idx
      end
    end

    def loop(current_id, {_next_id, next_process} = next) do
      receive do
        {msg, 1} ->
          Logger.info "#{msg} at 1"
          loop current_id, next
        {msg, n} when n > 1 ->
          Logger.info "#{msg} at #{n} at #{inspect(self)}"
          send next_process, {msg, n-1}
          loop current_id, next
        _ ->
          Logger.info "Not recognized at id, tuple"
      end
    end

  end

  defmodule Coordinator do
    require Logger

    @moduledoc """
    The coordinator to spawn the processes and send the messages
    """

    @doc """
    Creates the ring and returns a list of processes to make the call in any of them.

    ## Example:

        iex> [h | t] = TheRing.Coordinator.start 5
        [#PID<0.192.0>, #PID<0.193.0>, #PID<0.194.0>, #PID<0.195.0>, #PID<0.196.0>]
        21:06:57.833 [info]  1 linked to 2 at process #PID<0.193.0>
        21:06:57.833 [info]  2 linked to 3 at process #PID<0.194.0>
        21:06:57.834 [info]  3 linked to 4 at process #PID<0.195.0>
        21:06:57.834 [info]  4 linked to 5 at process #PID<0.196.0>
        21:06:57.834 [info]  5 linked to 1 at process #PID<0.192.0>
        iex> send h, {"Hello", 8}
        21:10:03.254 [info]  Hello at 8 at #PID<0.192.0>
        {"Hello", 8}
        21:10:03.254 [info]  Hello at 7 at #PID<0.193.0>
        21:10:03.254 [info]  Hello at 6 at #PID<0.194.0>
        21:10:03.254 [info]  Hello at 5 at #PID<0.195.0>
        21:10:03.254 [info]  Hello at 4 at #PID<0.196.0>
        21:10:03.254 [info]  Hello at 3 at #PID<0.192.0>
        21:10:03.254 [info]  Hello at 2 at #PID<0.193.0>
        21:10:03.254 [info]  Hello at 1

    """
    def start(size) do
      workers = 1..size |> Enum.map(&(spawn(TheRing.Worker, :loop, [&1])))
      for {pid, idx} <- Enum.with_index(workers) do
        next_idx = rem(idx+1, size)
        send pid, {next_idx + 1, Enum.at(workers, next_idx)}
      end
      workers
    end
  end
end
