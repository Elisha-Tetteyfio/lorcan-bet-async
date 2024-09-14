import Config

DotenvParser.load_file(".env")

config :lorcan, Lorcan.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: System.get_env("LORCAN_DB_NAME"),
  username: System.get_env("LORCAN_USER"),
  password: System.get_env("LORCAN_PASSWORD"),
  hostname: "localhost",
  pool_size: 2
