defmodule Bank.Account.Cache do
  use GenServer

  ## API client

  def save(account) do
    :ets.insert(__MODULE__, {account.account_number, account})
  end

  def find(account_number) do
    case :ets.lookup(__MODULE__, account_number) do
      [{_id, value}] -> value
      [] -> nil
    end
  end

  def clear do
    :ets.delete_all_objects(__MODULE__)
  end

  ## GenServer callbacks

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    table = :ets.new(__MODULE__, [:named_table, :public])
    {:ok, table}
  end

end
