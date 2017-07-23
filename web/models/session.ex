require IEx
defmodule Blog.Session do
  import Plug.Conn
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]

  def init(default), do: default

  def call(conn, repo) do
    user_id = get_session(conn, :user_id)
    cond do
      user = conn.assigns[:current_user] ->
        puts_current_user(conn, user)
      user = user_id && repo.get(Blog.User, user_id) ->
        puts_current_user(conn, user)
      true ->
        assign(conn, :current_user, nil)
    end
  end

  def puts_current_user(conn, user) do
    token = Phoenix.Token.sign(conn, "user socket", user.id)
    conn
    |> assign(:current_user, user)
    |> assign(:user_token, token)
  end


  def current_user(conn) do
    conn.assigns[:current_user]
  end

  def logged_in?(conn) do
    !!current_user(conn)
  end

  def logout(conn) do
    conn
    |> delete_session(:current_user)
    |> put_flash(:info, "Logged out")
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end
end
