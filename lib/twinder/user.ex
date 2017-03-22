defmodule Twinder.User do
  @behaviour Twinder.Social.User
  import JSON, only: [decode: 1]
  alias HTTPoison, as: HTTP
  alias HTTP.Response

  defstruct username: "", name: "", id: 0, followers: [], followers_size: 0

  @user_url "https://api.github.com/users/:username"
  @access_token Application.get_env(:twinder, :access_token)
  @headers ["Authorization": "token #{@access_token}"]
  @http_options [ssl: [{:versions, [:'tlsv1.2']}], recv_timeout: 1000]

  def get_user(username) do
    username
    |> create_url
    |> make_a_request
    |> parse_response
    |> create_new_user
  end

  defp create_url(username) do
    import String, only: [replace: 3]
    @user_url
    |> replace(":username", username)
  end

  defp make_a_request(url) do
    HTTP.get url, @headers, @http_options
  end

  defp parse_response({:ok, %Response{
                          body: body, headers: _headers, status_code: 200}}) do
    body |> decode
  end
  defp parse_response({:ok, %Response{
                          body: body, headers: _headers, status_code: code}}) when code in 400..499 do
    body |> decode
  end

  defp create_new_user({:ok, user_info}) do
    %__MODULE__{
      id: user_info["id"],
      username: user_info["login"],
      name: user_info["name"],
      followers_size: user_info["followers"]
    }
  end

end
