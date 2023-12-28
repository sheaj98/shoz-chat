defmodule ShozChat.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :content, :string
      add :sender_id, references(:users, on_delete: :nothing)
      add :chat_room_id, references(:chatrooms, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:messages, [:sender_id])
    create index(:messages, [:chat_room_id])
  end
end
