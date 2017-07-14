require IEx
defmodule Blog.AuthController do
  use Blog.Web, :controller

  def index(conn, %{"provider" => provider}) do
    redirect conn, external: authorize_url!(provider)
  end

  def callback(conn, %{"provider" => provider, "code" => code}) do
    # Exchange an auth code for an access token
    token = get_token!(provider, code)

    # Request the user's data with the access token
    user = get_user!(provider, token)

    # Store the user in the session under `:current_user` and redirect to /.
    # In most cases, we'd probably just store the user's ID that can be used
    # to fetch from the database. In this case, since this example app has no
    # database, I'm just storing the user map.
    #
    # If you need to make additional resource requests, you may want to store
    # the access token as well.
    conn
    |> put_session(:current_user, user)
    |> put_session(:access_token, token.token.access_token)
    |> redirect(to: "/")
  end

  defp authorize_url!("google") do
    Google.authorize_url!(scope: "https://www.googleapis.com/auth/userinfo.email")
  end

  defp authorize_url!(_), do: raise "No matching provider available"

  defp get_token!("google", code), do: Google.get_token!(code: code)
  defp get_token!(_, _), do: raise "No matching provider available"

  defp get_user!("google", client) do
    %{body: user} = OAuth2.Client.get!(client, "https://www.googleapis.com/plus/v1/people/me/openIdConnect")
    %{name: user["name"], avatar: user["picture"]}
  end
end
