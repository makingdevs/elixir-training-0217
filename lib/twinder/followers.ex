defmodule Twinder.User.Followers do
  @behaviour Twinder.Social.User.Followers
  import JSON, only: [decode: 1]
  import Enum, only: :functions
  alias Twinder.User
  alias HTTPoison, as: HTTP
  alias HTTP.Response

  @followers_url "https://api.github.com/users/:username/followers"
  @access_token Application.get_env(:twinder, :access_token)
  @headers ["Authorization": "token #{@access_token}"]
  @http_options [ssl: [{:versions, [:'tlsv1.2']}], recv_timeout: 3000]

  def followers_of(%User{username: username, followers_size: followers_size}) do
    username
    |> create_url
    |> make_request_for_size(followers_size)
    |> collect_followers_info
    |> extract_followers_info
    |> create_a_list_of_users
  end

  defp create_url(username) do
    import String, only: [replace: 3]
    @followers_url
    |> replace(":username", username)
  end

  defp make_request_for_size(url, followers_size) do
    pages = div(followers_size, 30) + 1
    1..pages
    |> map(fn page ->
      Task.async(fn -> make_a_request(url <> "?page=#{page}") end)
    end)
  end

  defp collect_followers_info(tasks) do
    tasks
    |> map(fn task -> Task.await(task) end)
    |> map(fn response -> parse_response(response) end)
    |> flat_map(&(&1))
  end

  defp make_a_request(url) do
    HTTP.get url, @headers, @http_options
  end

  defp parse_response({:ok, %Response{
                          body: body, headers: _headers, status_code: 200}}) do
    {:ok, followers} = body |> decode
    followers
  end
  defp parse_response({:ok, %Response{
                          body: body, headers: _headers, status_code: code}}) when code in 400..499 do
    body |> decode
  end

  defp extract_followers_info(followers) when is_list(followers) do
    for u <- followers,
      do: {u["id"], u["login"], u["name"]}
  end

  defp create_a_list_of_users(users_info) do
    for {id, username, name} <- users_info,
      do: %User{id: id, username: username, name: name}
  end

end
