defmodule Blog.SessionController do
  use Blog.Web, :controller

  def create(conn, %{"session" => %{"username" => user, "password" => pass}}) do
    case Rumbl.Auth.login_by_username_and_pass(conn, user, pass, repo: Repo) do
      {:ok, conn } ->
        conn
        |> put_flash(:info, "Welcome Back!")
        |> redirect(to: page_path(conn, :index))
      {:error, _reason, conn } ->
        conn
        |> put_flash(:error, "Invalid username/password combination")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> Blog.Session.logout
    |> redirect(to: "/")
  end
end
