defmodule Speaker do
  def speak do
    receive do
      {:say, msg} ->
        IO.puts msg
      _other ->
        :noop
    end
    speak()
  end

  def handle_message({:say, msg}) do
    IO.puts msg
  end

  def handle_message(_other) do
    false
  end
end

defmodule ServerWithNoResponse do
  def start(callback_module) do
    spawn fn ->
      loop(callback_module)
    end
  end

  def loop(callback_module) do
    receive do
      msg -> callback_module.handle_message(msg)
    end
    loop(callback_module)
  end
end

defmodule PingPongNew do
  def handle_message({:ping, from}) do
    send from, :pong
  end
  def handle_message({:pong, from}) do
    send from, :ping
  end
end

defmodule ServerWithResponse do
  def start(callback_module) do
    parent = self()
    spawn fn ->
      loop(callback_module, parent)
    end
  end

  def loop(callback_module, parent) do
    receive do
      msg -> callback_module.handle_message({msg, parent})
    end
    loop(callback_module, parent)
  end
end

defmodule BankAccount do

  def handle_message({:deposit, amount}, _from, balance) do
    balance + amount
  end
  def handle_message({:withdraw, amount}, _from, balance) do
    balance - amount
  end
  def handle_message(:balance, from, balance) do
    send from, {:balance, balance}
    balance
  end
end

defmodule ServerWithResponseAndState do
  def start(callback_module, state) do
    parent = self()
    spawn fn ->
      loop(callback_module, parent, state)
    end
  end

  def loop(callback_module, parent, state) do
    receive do
      msg ->
        new_state = callback_module.handle_message(msg, parent, state)
        loop(callback_module, parent, new_state)
    end
  end
end
