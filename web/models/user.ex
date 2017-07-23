defmodule Blog.User do
  use Blog.Web, :model

  schema "users" do
    field :name, :string
    field :username, :string
    field :avatar, :string
    has_many :comments, Blog.Comment

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(model,  params \\ %{}) do
    model
    |> cast(params, ~w(name username avatar))
    |> validate_required([:name, :username])
    |> unique_constraint(:username)
  end
end
