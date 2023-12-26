defmodule ShozChat.Repo.Migrations.CreateChatrooms do
  use Ecto.Migration

  def change do
    create table(:chatrooms) do
      add :name, :string
      add :description, :string

      timestamps(type: :utc_datetime)
    end
  end
end
