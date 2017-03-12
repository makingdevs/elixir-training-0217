defmodule Twinder.User.Supervisor do
  use Supervisor

  ## Supervisor API

  def new_user(username) do
    Supervisor.start_child __MODULE__, [username]
  end

  def all_accounts do
    childrens()
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
