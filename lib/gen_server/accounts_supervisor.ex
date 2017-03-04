defmodule Bank.Account.Supervisor do
  use Supervisor

  ## Supervisor API

  def start_link(opts \\ []) do
    Supervisor.start_link __MODULE__, :ok, opts
  end

  def start_account(supervisor) do
    Supervisor.start_child supervisor, []
  end

  ## Supervisor Callbacks

  def init(:ok) do
    children = [
      worker(Bank.Account, [])
    ]
    supervise(children, strategy: :simple_one_for_one)
  end

end
