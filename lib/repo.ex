defmodule MarketplaceApi.Repo do
  @moduledoc """
  Module to connect to Repo in read only mode
  """
  use Ecto.Repo,
    otp_app: :marketplace_api,
    adapter: Ecto.Adapters.MyXQL
end
