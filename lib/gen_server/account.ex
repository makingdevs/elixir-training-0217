defmodule Bank.Account do

  def start_link do
    Agent.start_link fn -> {:os.system_time(:millisecond) , 0} end
  end

  def deposit(account, amount) do
    Agent.update(account, fn {account_number, balance} ->
      {account_number, balance + amount}
    end)
  end

  def withdraw(account, amount) do
    Agent.update(account, fn {account_number, balance} ->
      {account_number, balance - amount}
    end)
  end

  def balance(account) do
    Agent.get account, &(&1)
  end

end
