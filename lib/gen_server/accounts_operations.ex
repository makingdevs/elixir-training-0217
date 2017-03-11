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
    {:ok, account} = Bank.Account.start_link(account_number)
    state = %{account_number: account_number, movements: account}
    {:ok, state}
  end

  def handle_cast({:deposit, amount}, %{movements: account} = state) do
    Bank.Account.deposit(account, amount)
    {:noreply, state }
  end

  def handle_cast({:withdraw, amount}, %{movements: account} = state) do
    Bank.Account.withdraw(account, amount)
    {:noreply, state }
  end

  def handle_call({:balance}, _from, state) do
    {:reply, state.amount, state}
  end

  def handle_call({:info}, _from, state) do
    {:reply, state.account_number, state}
  end

end
