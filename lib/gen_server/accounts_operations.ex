defmodule Bank.Account.Operations do
  use GenServer

  ## GenServer API

  def new_account(bank) do
    GenServer.cast(bank, :new)
  end

  def deposit(bank, account_number, amount) do
    GenServer.cast(bank, {:deposit, account_number, amount})
  end

  def withdraw(bank, account_number, amount) do
    GenServer.cast(bank, {:withdraw, account_number, amount})
  end

  def balance(bank, account_number) do
    GenServer.call(bank, {:balance, account_number})
  end

  ## GenServer callbacks

  def start_link(opts \\ []) do
    GenServer.start_link __MODULE__, state, opts
  end

  def init do
    {:ok, []}
  end

  def handle_cast(:new, state) do
    
  end

  def handle_cast({:deposit, account_number, amount}, state) do
    
  end

  def handle_cast({:withdraw, account_number, amount}, state) do
    
  end

  def handle_call({:balance, account_number}, _from, state) do
    
  end
end
