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
    Agent.get account, &(&1)
    |> calculate_the_balance_from_movements
  end

  defp calculate_the_balance_from_movements({_, movements}) do
    movements
    |> Enum.reduce(0, fn movement, accum ->
      case movement do
        {:deposit , amount} -> accum + amount
        {:withdraw, amount} -> accum - amount
      end
    end)
  end

end
