defmodule Bank.Account.Operations do
  use GenServer

  ## GenServer API

  def new_account do
    GenServer.cast(__MODULE__, :new)
  end

  def deposit(account_number, amount) do
    GenServer.cast(__MODULE__, {:deposit, account_number, amount})
  end

  def withdraw(account_number, amount) do
    GenServer.cast(__MODULE__, {:withdraw, account_number, amount})
  end

  def balance(account_number) do
    GenServer.call(__MODULE__, {:balance, account_number})
  end

  def all_accounts do
    GenServer.call(__MODULE__, :accounts)
  end

  ## GenServer callbacks

  def start_link(supervisor, opts \\ []) do
    GenServer.start_link __MODULE__, supervisor, opts
  end

  def init(supervisor) do
    {:ok, %{supervisor: supervisor, accounts: []}}
  end

  def handle_cast(:new, state) do
    {:ok, account} = Bank.Account.Supervisor.start_account state.supervisor
    {:noreply, %{state | accounts: [account | state.accounts]}}
  end

  def handle_cast({:deposit, account_number, amount}, state) do
    account = state.accounts |> find_account(account_number)
    Bank.Account.deposit(account, amount)
    {:noreply, state}
  end

  def handle_cast({:withdraw, account_number, amount}, state) do
    account = state.accounts |> find_account(account_number)
    Bank.Account.withdraw(account, amount)
    {:noreply, state}
  end

  def handle_call({:balance, account_number}, _from, state) do
    account = state.accounts |> find_account(account_number)
    {:reply, Bank.Account.balance(account), state}
  end

  def handle_call(:accounts, _from, state) do
    accounts = for a <- state.accounts, do: Bank.Account.balance a
    {:reply, accounts, state}
  end

  defp find_account(accounts, query_account) do
    accounts
    |> Enum.find( fn a ->
      {account_number, _} = Bank.Account.balance a
      account_number == query_account
    end)
  end
end
