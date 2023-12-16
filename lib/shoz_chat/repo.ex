defmodule ShozChat.Repo do
  use Ecto.Repo,
    otp_app: :shoz_chat,
    adapter: Ecto.Adapters.Postgres
end
