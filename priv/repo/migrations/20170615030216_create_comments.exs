defmodule Blog.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :content, :text

      timestamps()
    end
    #create index(:comments, [:user_id])
  end
end
