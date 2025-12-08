defmodule Sample.Repo.Migrations.CreateUrls do
  use Ecto.Migration

  def change do
    create table(:urls) do
      add :url, :string
      add :original_url, :text, null: false
      add :short_code, :string, size: 10, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:urls, [:short_code])
  end
end
