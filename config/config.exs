use Mix.Config

# config :hub88, hub88_pubkey_path: "#{:code.priv_dir(:hub88)}/hub88.pem"
# config :hub88, wallet_url: "dev-wallet:8000"

config :marketplace_api, env: Mix.env()

config :marketplace_api, MarketplaceApi.Repo,
  database: "marketplace",
  username: "marketplace",
  password: "marketplace",
  hostname: "localhost",
  port: 4050,
  # ssl: true,
  show_sensitive_data_on_connection_error: true

import_config "#{Mix.env()}.exs"
