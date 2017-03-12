defmodule Twinder.User.Supervisor do
  use Supervisor

  alias Twinder.User.Store
  alias Twinder.User

  ## Supervisor API

  def new_user(username) do
    Task.Supervisor.start_child(Twinder.TaskSupervisor, fn ->
      Supervisor.start_child __MODULE__, [username]
    end)
  end

  def find_one(username) do
    all_accounts()
    |> Enum.find(fn %User{username: u} ->
      u == username
    end)
  end

  def common_followers(username1, username2) do
    u1 = find_one(username1)
    u2 = find_one(username2)
    for follower_for_user1 <- u1.followers,
      follower_for_user2 <- u2.followers,
      follower_for_user1.id == follower_for_user2.id,
      do: follower_for_user1
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
