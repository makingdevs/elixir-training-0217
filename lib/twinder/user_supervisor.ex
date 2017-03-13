defmodule Twinder.User.Supervisor do
  use Supervisor

  alias Twinder.User.Store
  alias Twinder.User

  ## Supervisor API

  def new_user(username) do
    case find_one(username) do
      nil ->
        Task.Supervisor.start_child(Twinder.TaskSupervisor, fn ->
          Supervisor.start_child __MODULE__, [username]
        end)
      _ -> :already_exists
    end
  end

  def new_users(many_usernames) do
    many_usernames
    |> Enum.map(&(new_user/1))
  end

  def find_one(username) do
    all_accounts()
    |> Enum.find(fn %User{username: u} ->
      u == username
    end)
  end

  def find_many(usernames) do
    usernames
    |> Enum.map(&(find_one/1))
  end

  def common_followers(username1, username2) do
    u1 = find_one(username1)
    u2 = find_one(username2)
    for follower_for_user1 <- u1.followers,
      follower_for_user2 <- u2.followers,
      follower_for_user1.id == follower_for_user2.id,
      do: follower_for_user1.username
  end

  def find_interactions(followers) do
    for current_user <- followers,
      user <- followers,
      current_user != nil,
      user != nil,
      current_user.id != user.id,
      do: {current_user.username, is_in_followers_of(current_user, user), user.username}
  end

  defp is_in_followers_of(user1, user2) do
    ids = user2.followers |> Enum.map(&(&1.id))
    case user1.id in ids do
      true -> :following
      false -> :not_following
    end
  end

  def all_accounts do
    childrens()
    |> Enum.map(fn {_, pid, _, _} ->
      Store.current_state pid
    end)
  end

  defp childrens, do: __MODULE__ |> Supervisor.which_children

  ## Supervisor callbacks

  def start_link do
    Supervisor.start_link __MODULE__, :ok, name: __MODULE__
  end

  def init(:ok) do
    children = [
      worker(Twinder.User.Store, [])
    ]
    supervise(children, strategy: :simple_one_for_one)
  end

end
