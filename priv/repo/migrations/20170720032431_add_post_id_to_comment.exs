defmodule Blog.Repo.Migrations.AddPostIdToComment do
  use Ecto.Migration

  def change do
    alter table(:comments) do
      add :post_id, references(:posts)
    end

    create index(:comments, [:post_id])
  end
end
