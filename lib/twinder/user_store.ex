defmodule Twinder.User.Store do

  def start_link({id, username}) do
    Agent.start_link fn -> Twinder.User.new(id, username) end
  end

  def add_followers(user, followers) do
    Agent.update(user, fn u -> %Twinder.User{ u | followers: followers} end)
  end

  def current_state(user) do
    Agent.get user, &(&1)
  end

end
