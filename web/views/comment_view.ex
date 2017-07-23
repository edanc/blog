defmodule Blog.CommentView do
  use Blog.Web, :view

  def render("comment.json", %{comment: comment}) do
    %{
      id: comment.id,
      content: comment.content,
      user: render_one(comment.user, Blog.UserView, "user.json")
    }
  end
end
