defmodule Blog.Comment do
  use Blog.Web, :model

  schema "comments" do
    field :content, :string
    belongs_to :post, Blog.Post
    belongs_to :user, Blog.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [])
    |> validate_required([])
  end
end
