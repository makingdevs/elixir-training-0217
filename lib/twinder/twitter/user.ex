defmodule Twinder.Social.User.Twitter do
  @behaviour Twinder.Social.User

  alias Twinder.User

  def get_user(username) do
    username
    |> ExTwitter.user
    |> create_new_user
  end


  defp create_new_user(user_info) do
    %User{
      id: user_info.id,
      username: user_info.screen_name,
      name: user_info.name,
      followers_size: user_info.followers_count,
      network: :twitter
    }
  end

end
