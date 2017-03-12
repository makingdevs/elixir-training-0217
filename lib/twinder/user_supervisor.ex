defmodule Twinder.User.Supervisor do
  use Supervisor

  ## Supervisor API

  def new_user(username) do
    Task.Supervisor.start_child(Twinder.TaskSupervisor, fn ->
      Supervisor.start_child __MODULE__, [username]
    end)
  end

  def all_accounts do
    childrens()
    |> Enum.map(fn {_, pid, _, _} ->
      Twinder.User.Store.current_state pid
    end)
  end

  defp childrens, do: __MODULE__ |> Supervisor.which_children

  ## Supervisor callbacks

  def start_link do
    Supervisor.start_link __MODULE__, :ok, name: __MODULE__
  end

  def init(:ok) do
    children = [
      worker(Twinder.User.Server, [])
    ]
    supervise(children, strategy: :simple_one_for_one)
  end

end
