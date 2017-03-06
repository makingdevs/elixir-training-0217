defmodule Bank.Account.Operations do
  use GenServer

  ## GenServer API

  def deposit(account, amount) do
    GenServer.cast(account, {:deposit, amount})
  end

  def withdraw(account, amount) do
    GenServer.cast(account, {:withdraw, amount})
  end

  def balance(account) do
    GenServer.call(account, {:balance})
  end

  ## GenServer callbacks

  def start_link(account_number, opts \\ []) do
    GenServer.start_link __MODULE__, account_number, opts
  end

  def init(account_number) do
    # Here is the chance for ETS cache
    {:ok, %{account_number: account_number, amount: 0}}
  end

  def handle_cast({:deposit, amount}, state) do
    {:noreply, %{state | amount: state.amount + amount } }
  end

  def handle_cast({:withdraw, amount}, state) do
    {:noreply, %{state | amount: state.amount - amount } }
  end

  def handle_call({:balance}, _from, state) do
    {:reply, state.amount, state}
  end

end
