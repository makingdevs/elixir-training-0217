defmodule Twinder.User.Server do
  use GenServer

  ## API 

  def user_info(user) do
    GenServer.call(user, {:info})
  end

  ## GenServer Callback

  def start_link(username, opts \\ []) do
    GenServer.start_link __MODULE__, username, opts
  end

  def init(username) do
    user = Twinder.User.get_user username
    {:ok, user}
  end

  def handle_cast({:info}, _from, state) do
    {:reply, state, state}
  end
end
