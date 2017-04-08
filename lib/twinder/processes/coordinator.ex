defmodule Twinder.Coordinator do

  def loop(users \\ [], users_expected, parent) do
    receive do
      {:ok, user} ->
        new_users = [user | users]
        if Enum.count(new_users) == users_expected do
          send self(), :exit
        end
        loop(new_users, users_expected, parent)
      :exit ->
        # IO.inspect users
        send parent, {:ok, users, parent}
      _ ->
        loop(users, users_expected, parent)
    end
  end

end
