defmodule Twinder.User.Store do

  ## TODO: This is a bada impl, surely...
  ## We have to make a Task to process
  def start_link(username) do
    Agent.start_link fn ->
      followers = Task.Supervisor.async(Twinder.TaskSupervisor, fn ->
        Twinder.User.Followers.followers_of username
      end) |> Task.await
      %Twinder.User{ Twinder.User.get_user(username) |
                    followers: followers }
    end
  end

  def add_followers(user, followers) do
    Agent.update(user, fn u -> %Twinder.User{ u | followers: followers} end)
  end

  def current_state(user) do
    Agent.get user, &(&1)
  end

end
