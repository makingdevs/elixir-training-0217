defmodule Bank.Account.Supervisor do
  use Supervisor

  ## Supervisor API

  def start_account do
    # Here is the chance for ETS cache
    Supervisor.start_child __MODULE__, []
  end

  def find_account(account) do
    which_accounts()
    |> Enum.find( fn a ->
      {account_number, _} = Bank.Account.balance a
      account_number == account
    end)
  end

  def which_accounts do
    __MODULE__
    |> Supervisor.which_children
  end

  ## Supervisor Callbacks

  def start_link do
    Supervisor.start_link __MODULE__, :ok, name: __MODULE__
  end

  def init(:ok) do
    children = [
      worker(Bank.Account, [])
    ]
    supervise(children, strategy: :simple_one_for_one)
  end

end
