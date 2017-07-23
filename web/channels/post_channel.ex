require IEx
defmodule Blog.PostChannel do
  use Blog.Web, :channel
  alias Blog.CommentView

  def join("posts:" <> post_id, params, socket) do
    post_id = String.to_integer(post_id)
    post = Repo.get!(Blog.Post, post_id)
    comments = Repo.all(
      from a in assoc(post, :comments),
      preload: [:user],
      limit: 200
    )
    resp = %{comments: Phoenix.View.render_many(comments, CommentView, "comment.json")}

    {:ok, resp, assign(socket, :post_id, post_id)}
  end

  def handle_in(event, params, socket) do
    post = Repo.get(Blog.Post, socket.assigns.post_id)
    user = Repo.get(Blog.User, socket.assigns.user_id)
    handle_in(event, params, user, post, socket)
  end

  def handle_in("new_comment", params, user, post, socket) do
    changeset =
      post
      |> build_assoc(:comments, content: params["content"], user_id: user.id)
      |> Blog.Comment.changeset(params)

    case Repo.insert(changeset) do
      {:ok, comment} ->
        broadcast! socket, "new_comment", %{
          id: comment.id,
          content: comment.content,
        }
        {:reply, :ok, socket}

      {:error, changeset} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end
  end
end
