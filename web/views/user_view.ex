defmodule Blog.UserView do
  use Blog.Web, :view

  #def first_name(%User{name: name}) do
  #  name
  #  |> String.split(" ")
  #  |> Enum.at(0)
  #end

  def render("user.json", %{user: user}) do
    %{id: user.id, username: user.username}
  end
end
