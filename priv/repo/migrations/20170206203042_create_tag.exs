defmodule Inbox.Repo.Migrations.CreateTag do
  use Ecto.Migration

  def change do
    create table(:tags) do
      add :name, :string, null: false
      add :group, :string, default: "user", null: false
      add :system, :boolean, default: false, null: false

      timestamps
    end

    create unique_index(:tags, [:name])
  end
end
