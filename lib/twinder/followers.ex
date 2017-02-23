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
  @http_options [ssl: [{:versions, [:'tlsv1.2']}], recv_timeout: 500]

  def run_async do
    receive do
      {parent, username} -> send parent, {:ok, followers_of(username)}
      _ -> :noop
    end
  end

  def followers_of(username) do
    username
    |> create_url
    |> make_a_request
    |> parse_response
    |> extract_followers_info
    |> create_a_list_of_users
  end

  defp create_url(username) do
    import String, only: [replace: 3]
    @followers_url
    |> replace(":username", username)
  end

  defp make_a_request(url) do
    HTTP.get url, @headers, @http_options
  end

  defp parse_response({:ok, %Response{
                          body: body, headers: _headers, status_code: 200}}) do
    body |> decode
  end
  defp parse_response({:ok, %HTTPoison.Response{
                          body: body, headers: _headers, status_code: code}}) when code in 400..499 do
    body |> decode
  end

  defp extract_followers_info({:ok, %{"message" => "Not Found"}}) do
    []
  end

  defp extract_followers_info({:ok, followers}) when is_list(followers) do
    for u <- followers,
      do: {u["id"], u["login"]}
  end

  defp create_a_list_of_users(users_info) do
    for {id, username} <- users_info,
      do: User.new(id, username)
  end

end
