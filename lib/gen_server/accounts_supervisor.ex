defmodule Bank.Account.Supervisor do
  use Supervisor

  ## Supervisor API

  def new_account(account_number) do
    Supervisor.start_child __MODULE__, [account_number]
  end

  def find_account(account_number) do
    __MODULE__
    |> Supervisor.which_children
    |> Enum.find( fn {_, a, _, _} ->
      # Search in GenServer
    end)
    |> elem(1) # {_, pid, _, _}
  end

  ## Supervisor Callbacks

  def start_link do
    Supervisor.start_link __MODULE__, :ok, name: __MODULE__
  end

  def init(:ok) do
    children = [
      worker(Bank.Account.Operations, [])
    ]
    supervise(children, strategy: :simple_one_for_one)
  end

end
