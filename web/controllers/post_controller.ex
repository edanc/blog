defmodule Blog.PostController do
  use Blog.Web, :controller
  alias Blog.Post

  def index(conn, _params) do
    posts = Repo.all(Post)
    token = Phoenix.Token.sign(conn, "user socket")
    conn
    |> assign(:user_token, token)
    render(conn, "index.html", posts: posts)
  end

  def new(conn, _params) do
    changeset = Post.changeset(%Post{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"post" => post_params}) do
    changeset = Post.changeset(%Post{}, post_params)
    case Repo.insert(changeset) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "#{post.title} created!")
        |> redirect(to: post_path(conn, :show, post.id))
      {:error, changeset } ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    post = Repo.get(Post, id)
    render conn, "show.html", post: post
  end
end
