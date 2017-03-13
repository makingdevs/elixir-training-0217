defmodule Twinder.User.Followers do
  import JSON, only: [decode: 1]
  alias Twinder.User
  alias HTTPoison, as: HTTP
  alias HTTP.Response
  # import Integer, only: :macros
  # import Integer, only: :functions

  @followers_url "https://api.github.com/users/:username/followers"
  @access_token Application.get_env(:twinder, :access_token)
  @headers ["Authorization": "token #{@access_token}"]
  @http_options [ssl: [{:versions, [:'tlsv1.2']}], recv_timeout: 1000]

  def run_async do
    receive do
      {parent, username} ->
        send parent, {:ok, followers_of(username)}
      _ -> :noop
    end
  end

  def followers_of(username) do
    username
    |> create_url
    |> collect_followers_info
    |> extract_followers_info
    |> create_a_list_of_users
  end

  defp create_url(username) do
    import String, only: [replace: 3]
    @followers_url
    |> replace(":username", username)
  end

  defp collect_followers_info(url), do: join_followers(url, [], 1)

  defp join_followers(url, followers, 0), do: followers
  defp join_followers(url, followers, page) do
    {followers_per_page, should_continue} = url <> "?page=#{page}"
    |> make_a_request
    |> parse_response
    next_page = if should_continue, do: page + 1, else: 0
    join_followers(url, followers_per_page ++ followers, next_page)
  end

  defp make_a_request(url) do
    HTTP.get url, @headers, @http_options
  end

  defp parse_response({:ok, %Response{
                          body: body, headers: headers, status_code: 200}}) do
    more_pages? = headers
    |> Enum.find( fn {name, _} -> name == "Link"  end)
    |> extract_header_value
    |> String.contains?("next")
    {:ok, followers} = body |> decode
    {followers, more_pages?}
  end
  defp parse_response({:ok, %Response{
                          body: body, headers: _headers, status_code: code}}) when code in 400..499 do
    body |> decode
  end

  defp extract_header_value(nil), do: ""
  defp extract_header_value({_, value}), do: value

  defp extract_followers_info(followers) when is_list(followers) do
    for u <- followers,
      do: {u["id"], u["login"], u["name"]}
  end

  defp create_a_list_of_users(users_info) do
    for {id, username, name} <- users_info,
      do: %User{id: id, username: username, name: name}
  end

end
