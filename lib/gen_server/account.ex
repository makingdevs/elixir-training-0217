defmodule Bank.Account do

  def start_link(account_number) do
    Agent.start_link fn -> {account_number , []} end
  end

  def deposit(account, amount) do
    Agent.update(account, fn {account_number, movements} ->
      {account_number, [ {:deposit, amount} | movements ] }
    end)
  end

  def withdraw(account, amount) do
    Agent.update(account, fn {account_number, movements} ->
      {account_number, [ {:withdraw, amount} | movements ] }
    end)
  end

  def balance(account) do
    # Todo: do the calculation
    Agent.get account, &(&1)
  end

end
