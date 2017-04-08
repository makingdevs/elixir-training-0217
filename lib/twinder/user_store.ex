defmodule Twinder.User.Store do
  alias Twinder.Social.User.Github

  def start_link(username) do
    Agent.start_link fn ->
      user = Github.get_user(username)
      followers = Task.Supervisor.async(Twinder.TaskSupervisor, fn ->
        Github.Followers.followers_of user
      end) |> Task.await
      %Twinder.User{ user | followers: followers }
    end
  end

  def add_followers(user, followers) do
    Agent.update(user, fn u -> %Twinder.User{ u | followers: followers} end)
  end

  def current_state(user) do
    Agent.get user, &(&1)
  end

end
