defmodule Twinder.User do

  def followers_of(users) when is_list(users) do
    coordinator = spawn(Twinder.Coordinator, :loop, [ [], Enum.count(users), self() ])
    users
    |> Enum.map(fn u ->
      pid = spawn(Twinder.User.Followers, :run_async, [])
      send pid, {coordinator, u}
    end)
    await(self()) # This needs refactor
  end

  defp await(pid) do
    receive do
      {:ok, results, ^pid} -> results
      _ -> "No message"
    end
  end

  def quick_process do
    self() |> create_and_send |> handle_msg
  end

  defp create_and_send(parent) do
    pid = spawn fn ->
      send parent, {self(), 1+1}
    end
    pid
  end

  defp handle_msg(pid) do
    receive do
      {^pid, result} -> result
    end
  end

end
