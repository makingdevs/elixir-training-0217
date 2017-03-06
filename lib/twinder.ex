defmodule Twinder do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(Bank.Account.Supervisor, []),
      # Implement the Cache with ETS
    ]

    Supervisor.start_link(children, [strategy: :one_for_one])
  end

end
