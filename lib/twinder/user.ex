defmodule Twinder.User do
  defstruct username: "", id: 0, followers: []

  def new(id, username) do
    %__MODULE__{id: id, username: username}
  end

  def capitalize_username(%Twinder.User{ username: username}) do
    String.capitalize username
  end
end
