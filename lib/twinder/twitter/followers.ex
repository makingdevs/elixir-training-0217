defmodule Twinder.Social.User.Twitter.Followers do
  @behaviour Twinder.Social.User.Followers

  alias Twinder.User

  def followers_of(%User{followers_size: 0}), do: []
  def followers_of(%User{username: username}) do
    username
    |> find_followers_for
    |> create_a_list_of_users
  end

  defp find_followers_for(username) do
    join_followers(username, [],-1)
  end

  defp join_followers(_,followers, 0) do
    followers
  end

  defp join_followers(username,followers, cursor) do
    current_page_followers = ExTwitter.followers(username, count: 200, cursor: cursor)
    join_followers(username, followers ++ current_page_followers.items, current_page_followers.next_cursor)
  end

  defp create_a_list_of_users(users_info) do
    for user_data  <- users_info,
      do: create_new_user(user_data)
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
