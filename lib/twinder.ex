defmodule Twinder do
  use Application

  def start(_type, _args) do
    Bank.Supervisor.start_link
  end

end
