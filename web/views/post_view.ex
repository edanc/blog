defmodule Blog.PostView do
  use Blog.Web, :view
  alias Blog.Post

  def title(%Post{title: title}) do
    title
    |> String.split(" ")
    |> Enum.at(0)
  end

  def content(%Post{body: body}) do
    body
    |> String.split(" ")
    |> Enum.at(0)
  end
end
