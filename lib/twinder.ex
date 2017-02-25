defmodule Twinder do

  def followers_of(users) when is_list(users) do
    coordinator = spawn(Twinder.Coordinator, :loop, [ [], Enum.count(users) ])
    users
    |> Enum.map(fn u ->
      pid = spawn(Twinder.User.Followers, :run_async, [])
      send pid, {coordinator, u}
    end)
  end
end
