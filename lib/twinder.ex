defmodule Twinder do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      worker(Bank.Account.Cache, []),
      supervisor(Bank.Account.Supervisor, []),
      supervisor(Twinder.User.Supervisor, [])
    ]

    Supervisor.start_link(children, [strategy: :one_for_one])
  end

end
