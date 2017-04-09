defmodule Twinder.User.Store do
  alias Twinder.Social.User.Github
  alias Twinder.Social.User.Twitter

  def start_link(username, network) do
    Agent.start_link fn ->
      case network do
        :twitter -> start_link_for_github(username)
        :github -> start_link_for_twitter(username)
      end
    end
  end

  def add_followers(user, followers) do
    Agent.update(user, fn u -> %Twinder.User{ u | followers: followers} end)
  end

  def current_state(user) do
    Agent.get user, &(&1)
  end

  defp start_link_for_github(username) do
    user = Github.get_user(username)
    followers = Task.Supervisor.async(Twinder.TaskSupervisor, fn ->
      Github.Followers.followers_of user
    end) |> Task.await
    %Twinder.User{ user | followers: followers }
  end

  defp start_link_for_twitter(username) do
    user = Twitter.get_user(username)
    followers = Task.Supervisor.async(Twinder.TaskSupervisor, fn ->
      Twitter.Followers.followers_of user
    end) |> Task.await
    %Twinder.User{ user | followers: followers }
  end

end
