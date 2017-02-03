defmodule Inbox.Repo.Migrations.CreateResources do
  use Ecto.Migration

  def change do
    create table(:resources) do
      add :url, :binary, null: false

      timestamps
    end

    create unique_index(:resources, [:url])
  end
end
