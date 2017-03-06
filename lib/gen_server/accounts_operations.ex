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

  def info(account) do
    GenServer.call(account, {:info})
  end

  ## GenServer callbacks

  def start_link(account_number, opts \\ []) do
    GenServer.start_link __MODULE__, account_number, opts
  end

  def init(account_number) do
    state = Bank.Account.Cache.find(account_number) || %{account_number: account_number, amount: 0}
    {:ok, state}
  end

  def handle_cast({:deposit, amount}, state) do
    state = %{state | amount: state.amount + amount }
    Bank.Account.Cache.save(state)
    {:noreply, state }
  end

  def handle_cast({:withdraw, amount}, state) do
    state = %{state | amount: state.amount - amount }
    Bank.Account.Cache.save(state)
    {:noreply, state }
  end

  def handle_call({:balance}, _from, state) do
    {:reply, state.amount, state}
  end

  def handle_call({:info}, _from, state) do
    {:reply, state.account_number, state}
  end

end
