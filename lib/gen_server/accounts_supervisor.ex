defmodule Bank.Account.Supervisor do
  use Supervisor

  ## Supervisor API

  def new_account do
    Supervisor.start_child __MODULE__, [:os.system_time(:millisecond) ]
  end

  def find_account(account_number) do
    childrens()
    |> Enum.find( fn {_, a, _, _} ->
      # Search in GenServer
      Bank.Account.Operations.info(a) == account_number
    end)
    |> elem(1) # {_, pid, _, _}
  end

  def all_accounts do
    childrens()
    |> Enum.map( fn {_, a, _, _} ->
      Bank.Account.Operations.info(a)
    end)
  end

  defp childrens, do: __MODULE__ |> Supervisor.which_children

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
