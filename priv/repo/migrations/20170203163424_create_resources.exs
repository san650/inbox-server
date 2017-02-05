defmodule Inbox.Repo.Migrations.CreateResources do
  use Ecto.Migration

  def change do
    create table(:resources) do
      add :uri, :binary, null: false

      timestamps
    end

    create unique_index(:resources, [:uri])
  end
end
