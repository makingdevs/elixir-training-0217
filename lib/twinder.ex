defmodule Twinder do
  use Application


  @bank_account_supervisor Bank.Account.Supervisor

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(Bank.Supervisor, []),
      supervisor(Bank.Account.Supervisor, [[name: Bank.Account.Supervisor]]),
      worker(Bank.Account.Operations, [@bank_account_supervisor, [name: Bank.Account.Operations]])
      # Implement the Cache with ETS
    ]

    Supervisor.start_link(children, [strategy: :one_for_one])
  end

end
